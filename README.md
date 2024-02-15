# Azure Ubuntu Assessment Runbook

This repository contains a PowerShell runbook for Azure Automation, designed to assess Ubuntu virtual machines (VMs) across your Azure estate for security updates.

## Prerequisites

Before using this runbook, ensure the following prerequisites are met:

1. **Azure Automation Account**: You must have an Azure Automation account set up.
2. **Managed Identity**: The Automation account should have a Managed Identity assigned.
3. **Permissions**: The Managed Identity requires permissions to access VM information and perform actions as needed across your Azure subscription(s).

## Setup

1. **Assign Managed Identity**: Ensure your Automation account's Managed Identity is assigned and has the appropriate permissions to access and manage your VMs.
2. **Import Runbook**: Import the PowerShell script provided in this repository into your Azure Automation account as a new runbook.

## Usage

To use this runbook:

1. **Navigate** to your Azure Automation account in the Azure Portal.
2. **Open** the imported runbook.
3. **Start** the runbook with the necessary parameters, such as your Azure Subscription ID.

### Parameters

- `SubscriptionId`: The ID of the Azure subscription containing the VMs to be assessed. This parameter is mandatory.

## Functionality

This runbook performs the following actions:

- Iterates through all Ubuntu VMs within the specified Azure subscription.
- Executes the `ubuntu-advantage security-status` command on each VM to assess the security update status.
- Aggregates the output from all VMs to provide a consolidated view of packages that require updates.

## Output

The runbook outputs:

- A summary of the security update status for each Ubuntu VM.
- A list of packages that require updates, categorized by their availability (standard updates, ESM updates, etc.).
- Aggregated statistics on the number of VMs compliant, non-compliant, and not applicable for updates.

## Contributing

We welcome contributions and suggestions to improve this runbook. Please feel free to submit issues or pull requests to the repository.


## Example output
The result you can see is like this:
```
Retrieved VM status for 5 VM(s).

Machine test-for-demo-j has total of 22 packages outdated

The packages available to upgrade on test-for-demo-j are the following:

libmagick++-6.q16-8 libimage-magick-perl libmagickcore-6.q16-6-extra libimage-magick-q16-perl libgegl-0.4-0 lynx-common libzmq5 python2.7-minimal libmagickwand-6.q16-6 libgegl-common python2.7 libvlc5 libmediainfo0v5 libvlccore9 imagemagick-6.q16 libopenexr24 libsdl2-2.0-0 libmysofa1 libmagickcore-6.q16-6 libpython2.7-minimal libpython2.7-stdlib imagemagick-6-common

Upgrades available with Ubuntu PRO only are the following: 

Machine test-2-demo-j has total of 9 packages outdated

The packages available to upgrade on test-2-demo-j are the following:

libsystemd0 udev libudev1 libapparmor1 systemd-sysv libpam-systemd systemd libnss-systemd apparmor

Upgrades available with Ubuntu PRO only are the following: 

Machine test-4 has total of 44 packages outdated

The packages available to upgrade on test-4 are the following:

bind9-host bind9-dnsutils login bind9-libs passwd

Upgrades available with Ubuntu PRO only are the following: vlc-plugin-qt libvlc5 libimage-magick-perl vlc-data libvlccore9 vlc imagemagick vlc-bin libjs-jquery-ui vlc-l10n libavdevice58 ffmpeg libopenexr25 libmagick++-6.q16-8 python3-scipy libpostproc55 libmagickcore-6.q16-6-extra vlc-plugin-samba libavcodec58 libimage-magick-q16-perl libmagickwand-6.q16-6 vlc-plugin-notify libavutil56 imagemagick-6.q16 libswscale5 libmagickcore-6.q16-6 vlc-plugin-access-extra vlc-plugin-skins2 libgsl27 vlc-plugin-video-splitter libswresample3 imagemagick-6-common vlc-plugin-video-output libavformat58 libgslcblas0 libvlc-bin vlc-plugin-base vlc-plugin-visualization libavfilter7

Machine test-3-inst has total of 44 packages outdated

The packages available to upgrade on test-3-inst are the following:

bind9-host bind9-dnsutils login bind9-libs passwd

Upgrades available with Ubuntu PRO only are the following: vlc-plugin-qt libvlc5 libimage-magick-perl vlc-data libvlccore9 vlc imagemagick vlc-bin libjs-jquery-ui vlc-l10n libavdevice58 ffmpeg libopenexr25 libmagick++-6.q16-8 python3-scipy libpostproc55 libmagickcore-6.q16-6-extra vlc-plugin-samba libavcodec58 libimage-magick-q16-perl libmagickwand-6.q16-6 vlc-plugin-notify libavutil56 imagemagick-6.q16 libswscale5 libmagickcore-6.q16-6 vlc-plugin-access-extra vlc-plugin-skins2 libgsl27 vlc-plugin-video-splitter libswresample3 imagemagick-6-common vlc-plugin-video-output libavformat58 libgslcblas0 libvlc-bin vlc-plugin-base vlc-plugin-visualization libavfilter7

--------------------------------------------------------------------------------------------------------------

Total VMs on the subscription: 5

Fully compliant VMs: 0

Non fully compliant VMs: 4

N/A VMs: 1

Total unique esm-infra/esm-apps packages outdated across VMs: 65

List of unique esm-infra/esm-apps packages outdated across VMs: libmagick++-6.q16-8, libimage-magick-perl, libmagickcore-6.q16-6-extra, libimage-magick-q16-perl, libgegl-0.4-0, lynx-common, libzmq5, python2.7-minimal, libmagickwand-6.q16-6, libgegl-common, python2.7, libvlc5, libmediainfo0v5, libvlccore9, imagemagick-6.q16, libopenexr24, libsdl2-2.0-0, libmysofa1, libmagickcore-6.q16-6, libpython2.7-minimal, libpython2.7-stdlib, imagemagick-6-common, libsystemd0, udev, libudev1, libapparmor1, systemd-sysv, libpam-systemd, systemd, libnss-systemd, apparmor, bind9-host, bind9-dnsutils, login, bind9-libs, passwd, vlc-plugin-qt, vlc-data, vlc, imagemagick, vlc-bin, libjs-jquery-ui, vlc-l10n, libavdevice58, ffmpeg, libopenexr25, python3-scipy, libpostproc55, vlc-plugin-samba, libavcodec58, vlc-plugin-notify, libavutil56, libswscale5, vlc-plugin-access-extra, vlc-plugin-skins2, libgsl27, vlc-plugin-video-splitter, libswresample3, vlc-plugin-video-output, libavformat58, libgslcblas0, libvlc-bin, vlc-plugin-base, vlc-plugin-visualization, libavfilter7



List of packages with upgrades available now and how many times across your VMs:

{

  "lynx-common": 1,

  "imagemagick-6.q16": 1,

  "libpython2.7-stdlib": 1,

  "libimage-magick-perl": 1,

  "libmysofa1": 1,

  "libmagickwand-6.q16-6": 1,

  "libgegl-0.4-0": 1,

  "libpython2.7-minimal": 1,

  "libnss-systemd": 1,

  "bind9-libs": 2,

  "systemd-sysv": 1,

  "udev": 1,

  "python2.7": 1,

  "python2.7-minimal": 1,

  "libopenexr24": 1,

  "libpam-systemd": 1,

  "libimage-magick-q16-perl": 1,

  "imagemagick-6-common": 1,

  "libvlc5": 1,

  "libapparmor1": 1,

  "libsystemd0": 1,

  "libudev1": 1,

  "bind9-host": 2,

  "apparmor": 1,

  "libvlccore9": 1,

  "bind9-dnsutils": 2,

  "login": 2,

  "passwd": 2,

  "systemd": 1,

  "libmagickcore-6.q16-6": 1,

  "libmagick++-6.q16-8": 1,

  "libgegl-common": 1,

  "libmagickcore-6.q16-6-extra": 1,

  "libzmq5": 1,

  "libmediainfo0v5": 1,

  "libsdl2-2.0-0": 1

}



List of packages with upgrade available with Ubuntu PRO:

{

  "libavcodec58": 2,

  "libavdevice58": 2,

  "imagemagick-6.q16": 2,

  "vlc-plugin-qt": 2,

  "libimage-magick-perl": 2,

  "vlc-plugin-skins2": 2,

  "vlc-plugin-samba": 2,

  "libmagickwand-6.q16-6": 2,

  "libpostproc55": 2,

  "imagemagick": 2,

  "libswscale5": 2,

  "vlc-plugin-notify": 2,

  "vlc-plugin-base": 2,

  "libavformat58": 2,

  "libavutil56": 2,

  "vlc-plugin-access-extra": 2,

  "vlc-plugin-video-output": 2,

  "libgslcblas0": 2,

  "libimage-magick-q16-perl": 2,

  "imagemagick-6-common": 2,

  "libvlc5": 2,

  "libmagickcore-6.q16-6": 2,

  "vlc-data": 2,

  "libswresample3": 2,

  "libvlccore9": 2,

  "vlc-plugin-video-splitter": 2,

  "python3-scipy": 2,

  "vlc": 2,

  "libmagick++-6.q16-8": 2,

  "libopenexr25": 2,

  "libmagickcore-6.q16-6-extra": 2,

  "vlc-plugin-visualization": 2,

  "libgsl27": 2,

  "libavfilter7": 2,

  "libvlc-bin": 2,

  "vlc-l10n": 2,

  "vlc-bin": 2,

  "libjs-jquery-ui": 2,

  "ffmpeg": 2

}



```
