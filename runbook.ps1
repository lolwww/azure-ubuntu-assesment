### Before you start:
### 1. Automation account should have a managed identity assigned
### 2. This managed identity has to be added to the designated subscription


Param
(
  [Parameter (Mandatory=$true)]
  [String] $SubscriptionId
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

$metadata = @{}

# Create a temporary file for the script
$TempFile = New-TemporaryFile
$TempFilePath = $TempFile.FullName


# Script to check Ubuntu security updates status
$ScriptToRun = @"
/usr/bin/ubuntu-advantage security-status --format json 2>/dev/null | jq '{
    updateSum: (.summary.num_esm_apps_updates + .summary.num_esm_infra_updates + .summary.num_standard_security_updates),
    upgradeAvailablePackages: [.packages[] | select(.status == "upgrade_available") | .package],
    pendingAttachPackages: [.packages[] | select(.status == "pending_attach") | .package]
  }'  
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
    $upgradeAvailablePackages = $jobResult.upgradeAvailablePackages
    $pendingAttachPackages = $jobResult.pendingAttachPackages

    # Check and set $totalOutdatedPackages
    if (-not $totalOutdatedPackages -or $totalOutdatedPackages -eq 0) {
       $totalOutdatedPackages = "NONE"
    }

    # Check and set $upgradeAvailablePackages
    if (-not $upgradeAvailablePackages -or $upgradeAvailablePackages.Count -eq 0) {
       $upgradeAvailablePackages = "NONE"
    } else {
       # Join the array elements into a string if not empty
        $upgradeAvailablePackages = $upgradeAvailablePackages -join ", "
    }

    # Check and set $pendingAttachPackages
    if (-not $pendingAttachPackages -or $pendingAttachPackages.Count -eq 0) {
        $pendingAttachPackages = "NONE"
    } else {
    # Join the array elements into a string if not empty
       $pendingAttachPackages = $pendingAttachPackages -join ", "
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
Total VMs: $($compliantVMs + $nonCompliantVMs + $notApplicableVMs)
Compliant VMs: $compliantVMs
Non-compliant VMs: $nonCompliantVMs
N/A VMs: $notApplicableVMs
"@

Write-Output $prettifiedOutput
