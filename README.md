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
Subscription 1 (XXXXXXX)

Retrieved VM status for 3 VM(s).

Machine test-for-demo-j has total of 55 packages outdated

The packages available to upgrade on test-for-demo-j are the following:

vlc-bin vlc-pluginvideo-output libavformat58 libmagick++-6.q16-8 libavfilter7 libimage-magick-perl ffmpeg vlc-plugin-samba libmagickcore-6.q16-6-extra libimage-magick-q16-perl imagemagick libswresample3 vlc-plugin-qt libgegl-0.4-0 lynx-common libzmq5 python2.7-minimal libmagickwand-6.q16-6 vlc-plugin-skins2 weechat libgegl-common vlc-plugin-visualization weechat-plugins vlc-l10n python2.7 weechat-ruby vlc-plugin-notify libvlc5 libmediainfo0v5 lynx libpostproc55 libvlccore9 libvlc-bin imagemagick-6.q16 weechat-core weechat-perl libavcodec58 weechat-python weechat-curses vlc libavutil56 vlc-data libavdevice58 libswscale5 libopenexr24 libsdl2-2.0-0 libmysofa1 libmagickcore-6.q16-6 vlc-plugin-video-splitter glances libpython2.7-minimal vlc-plugin-base libpython2.7-stdlib libavresample4 imagemagick-6-common

Upgrades available with Ubuntu PRO only are the following: 

Machine test-2-demo-j has total of 9 packages outdated

The packages available to upgrade on test-2-demo-j are the following:

libsystemd0 udev libudev1 libapparmor1 systemd-sysv libpam-systemd systemd libnss-systemd apparmor

Upgrades available with Ubuntu PRO only are the following: 

--------------------------------------------------------------------------------------------------------------

Total VMs on the subscription: 3

Fully compliant VMs: 0

Non fully compliant VMs: 2

N/A VMs: 1

Total unique esm-infra/esm-apps packages outdated across VMs: 64

List of unique esm-infra/esm-apps packages outdated across VMs:

vlc-bin, vlc-plugin-video-output, libavformat58, libmagick++-6.q16-8, libavfilter7, libimage-magick-perl, ffmpeg, vlc-plugin-samba, libmagickcore-6.q16-6-extra, libimage-magick-q16-perl, imagemagick, libswresample3, vlc-plugin-qt, libgegl-0.4-0, lynx-common, libzmq5, python2.7-minimal, libmagickwand-6.q16-6, vlc-plugin-skins2, weechat, libgegl-common, vlc-plugin-visualization, weechat-plugins, vlc-l10n, python2.7, weechat-ruby, vlc-plugin-notify, libvlc5, libmediainfo0v5, lynx, libpostproc55, libvlccore9, libvlc-bin, imagemagick-6.q16, weechat-core, weechat-perl, libavcodec58, weechat-python, weechat-curses, vlc, libavutil56, vlc-data, libavdevice58, libswscale5, libopenexr24, libsdl2-2.0-0, libmysofa1, libmagickcore-6.q16-6, vlc-plugin-video-splitter, glances, libpython2.7-minimal, vlc-plugin-base, libpython2.7-stdlib, libavresample4, imagemagick-6-common, libsystemd0, udev, libudev1, libapparmor1, systemd-sysv, libpam-systemd, systemd, libnss-systemd, apparmor


List of packages with upgrades available now:


{
  "python2.7": 1,
  "libswscale5": 1,
  "udev": 1,
  "libapparmor1": 1,
  "libavformat58": 1,
  "ffmpeg": 1,
  "weechat-curses": 1,
  "vlc-plugin-notify": 1,
  "libavdevice58": 1,
  "libzmq5": 1,
  "weechat": 1,
  "libnss-systemd": 1,
  "libudev1": 1,
  "imagemagick-6.q16": 1,
  "apparmor": 1,
  "libmagickcore-6.q16-6": 1,
  "libvlc5": 1,
  "libgegl-common": 1,
  "vlc-plugin-video-output": 1,
  "vlc-plugin-samba": 1,
  "weechat-ruby": 1,
  "lynx": 1,
  "python2.7-minimal": 1,
  "libavfilter7": 1,
  "libgegl-0.4-0": 1,
  "vlc": 1,
  "weechat-python": 1,
  "libvlccore9": 1,
  "imagemagick": 1,
  "libpam-systemd": 1,
  "imagemagick-6-common": 1,
  "vlc-bin": 1,
  "lynx-common": 1,
  "vlc-l10n": 1,
  "libavutil56": 1,
  "libmagick++-6.q16-8": 1,
  "libavcodec58": 1,
  "libopenexr24": 1,
  "vlc-plugin-video-splitter": 1,
  "libswresample3": 1,
  "libmagickwand-6.q16-6": 1,
  "libpython2.7-stdlib": 1,
  "libsystemd0": 1,
  "glances": 1,
  "vlc-data": 1,
  "libpython2.7-minimal": 1,
  "libpostproc55": 1,
  "weechat-plugins": 1,
  "libimage-magick-perl": 1,
  "libmysofa1": 1,
  "libvlc-bin": 1,
  "systemd-sysv": 1,
  "libmediainfo0v5": 1,
  "weechat-perl": 1,
  "weechat-core": 1,
  "vlc-plugin-skins2": 1,
  "vlc-plugin-qt": 1,
  "vlc-plugin-base": 1,
  "libimage-magick-q16-perl": 1,
  "libsdl2-2.0-0": 1,
  "vlc-plugin-visualization": 1,
  "libavresample4": 1,
  "systemd": 1,
  "libmagickcore-6.q16-6-extra": 1
}

List of packages with upgrade available with Ubuntu PRO:

{}
```
