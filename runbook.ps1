Param(
    [Parameter(Mandatory=$true)]
    [String]$SubscriptionId
)

# Terminate runbook on non-handled exception
$ErrorActionPreference = "Stop"

# Validate Subscription ID
if (![System.Guid]::TryParse($SubscriptionId, [System.Management.Automation.PSReference][System.Guid]::empty)) {
    Write-Error "Provided subscription ID is not a valid GUID, exiting"
    exit 1
}

# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process | Out-Null

# Connect using a Managed Service Identity
try {
    Connect-AzAccount -Identity | Out-Null
    Set-AzContext -Subscription $SubscriptionId
} catch {
    Write-Output "Error connecting to Azure with Managed Identity. Aborting."
    Write-Error $_
    exit 1
}

# Initialize counters
$compliantVMs = 0
$nonCompliantVMs = 0
$notApplicableVMs = 0
$totalUniqueOutdated = New-Object 'System.Collections.Generic.HashSet[string]'
$dictUpgradesAvailable = @{}
$dictUpgradesPending = @{}
$metadata = @{}

# Create a temporary file for the script
$TempFile = New-TemporaryFile
$TempFilePath = $TempFile.FullName

# Script to check Ubuntu security updates status
$ScriptToRun = @"
/usr/bin/ubuntu-advantage security-status --format json 2>/dev/null | jq '{
    updateSum: (.summary.num_esm_apps_updates + .summary.num_esm_infra_updates + .summary.num_standard_security_updates),
    upgradeAvailablePackages: [.packages[] | select(.status == "upgrade_available") | .package],
    pendingAttachPackages: [.packages[] | select(.status == "pending_attach") | .package]}'  
"@

# Write the script to a temp file
$ScriptToRun | Out-File -FilePath $TempFilePath

# Retrieve VM status
$Status = Get-AzVm -Status
if (-not $Status) {
    Write-Output "No VMs found or unable to retrieve VM status."
    exit 0
}

# Log retrieved VMs
Write-Output "Retrieved VM status for $($Status.Count) VM(s)."

# Process each VM
foreach ($vm in $Status) {
    if ($null -eq $vm.OsProfile.LinuxConfiguration) {
        $notApplicableVMs++
        continue
    }
    if ($vm.PowerState -ne 'VM running') {
        $notApplicableVMs++
        continue
    }

    $job = Invoke-AzVMRunCommand -AsJob -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -CommandId RunShellScript -ScriptPath $TempFilePath
    $metadata[$job.Id] = @{
        "MachineId" = $vm.Id
        "Job" = $job
    }
}

# Wait for all jobs to complete
Start-Sleep -Seconds 10
Get-Job | Wait-Job | Out-Null

# Process each job result
foreach ($job in $metadata.GetEnumerator()) {
    $machineId = $job.Value["MachineId"]
    try {
        $jobOutputMessage = $job.Value["Job"].Output.Value.Message
        $stdoutStart = $jobOutputMessage.IndexOf("[stdout]") + "[stdout]".Length
        $stderrStart = $jobOutputMessage.IndexOf("[stderr]", $stdoutStart)
        $jsonString = $jobOutputMessage.Substring($stdoutStart, $stderrStart - $stdoutStart).Trim()
        if (-not $jsonString) {
            throw "No JSON found in the output message."
        }

        $jobResult = $jsonString | ConvertFrom-Json
    }
    catch {
        $nonCompliantVMs++
        Write-Error "VM $machineId error parsing UA output: $_"
        continue
    }
    
    $totalOutdatedPackages = $jobResult.updateSum
    $upgradeAvailablePackages = if ($jobResult.upgradeAvailablePackages -eq $null) { @() } else { $jobResult.upgradeAvailablePackages }
    $pendingAttachPackages = if ($jobResult.pendingAttachPackages -eq $null) { @() } else { $jobResult.pendingAttachPackages }

    # Add to HashSet 
    foreach ($pkg in $upgradeAvailablePackages) {
        $totalUniqueOutdated.Add($pkg) | Out-Null
    }
    foreach ($pkg in $pendingAttachPackages) {
        $totalUniqueOutdated.Add($pkg) | Out-Null
    }

    # Handling HashSet output
    $totalUniqueOutdatedList = if ($totalUniqueOutdated.Count -gt 0) { 
        $totalUniqueOutdated -join ", " 
    } else { 
        "None" 
    }
    
    $upgradeAvailablePackagesArray = @()
    if ($upgradeAvailablePackages -ne $null -and $upgradeAvailablePackages -ne '') {
        $upgradeAvailablePackagesArray = $upgradeAvailablePackages -split ' '
    }

    # Ensure packages are correctly split and converted to lists
    $upgradeAvailablePackagesList = New-Object 'System.Collections.Generic.List[string]'
    if ($upgradeAvailablePackages -ne $null -and $upgradeAvailablePackages -ne '') {
        $upgradeAvailablePackagesArray = $upgradeAvailablePackages -split ' '
        foreach ($item in $upgradeAvailablePackagesArray) {
            if ($item -ne $null -and $item.Trim() -ne '') {
                $upgradeAvailablePackagesList.Add($item.Trim())
            }
        }
    }   

    $pendingAttachPackagesArray = @()
    if ($pendingAttachPackages -ne $null -and $pendingAttachPackages -ne '') {
        $pendingAttachPackagesArray = $pendingAttachPackages -split ' '
    }
    $pendingAttachPackagesList = New-Object 'System.Collections.Generic.List[string]'
    if ($pendingAttachPackages -ne $null -and $pendingAttachPackages -ne '') {
        $pendingAttachPackagesArray = $pendingAttachPackages -split ' '
        foreach ($item in $pendingAttachPackagesArray) {
            if ($item -ne $null -and $item.Trim() -ne '') {
                $pendingAttachPackagesList.Add($item.Trim())
            }
        }
    }   

    #Format upgrade list
    foreach ($package in $upgradeAvailablePackagesList) {
        if ($package -eq "" -or $package -eq $null) {
            continue
        }

        if ($dictUpgradesAvailable.ContainsKey($package)) {
            $dictUpgradesAvailable[$package]++
        } else {
            $dictUpgradesAvailable.Add($package, 1)
        }
    }
    #Format pending list
    foreach ($package in $pendingAttachPackagesList) {
        if ($package -eq "" -or $package -eq $null) {
            continue
        }
        
        if ($dictUpgradesPending.ContainsKey($package)) {
            $dictUpgradesPending[$package]++
        } else {
            $dictUpgradesPending.Add($package, 1)
        }
    }

    $machineName = $machineId.Split('/')[-1]
    if ($jobResult.updateSum -gt 0) {
        Write-Output "Machine $machineName has total of $totalOutdatedPackages packages outdated"
        Write-Output "The packages available to upgrade on $machineName are the following:"
        Write-Output "$upgradeAvailablePackages"
        Write-Output "Upgrades available with Ubuntu PRO only are the following: $pendingAttachPackages"
        $nonCompliantVMs++
    } else {
        Write-Output "Machine $machineName is compliant (no outdated packages)"
        $compliantVMs++
    }
}

# Output summary
$prettifiedOutput = @"
--------------------------------------------------------------------------------------------------------------
Total VMs on the subscription: $($compliantVMs + $nonCompliantVMs + $notApplicableVMs)
Fully compliant VMs: $compliantVMs
Non fully compliant VMs: $nonCompliantVMs
N/A VMs: $notApplicableVMs
Total unique esm-infra/esm-apps packages outdated across VMs: $($totalUniqueOutdated.Count)
List of unique esm-infra/esm-apps packages outdated across VMs: $($totalUniqueOutdatedList)

List of packages with upgrades available now and how many times across your VMs:
$($dictUpgradesAvailable | ConvertTo-Json)

List of packages with upgrade available with Ubuntu PRO:
$($dictUpgradesPending | ConvertTo-Json)
"@

Write-Output $prettifiedOutput
