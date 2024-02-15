# azure-ubuntu-assesment
Runbooks for Microsoft Azure which help you to perform assesment across your Ubuntu estate on Azure. 

### Before you start:
### 1. Automation account should have a managed identity assigned
### 2. This managed identity has to be added to the designated subscription

Run this runbook with Azure Automation by supplying Subscription ID to it.
Script goes through all of the available VMs and attempts to execute 

'ubuntu-advantage security-status' then parse the output of it, then combines the outputs from all VMs.

In the end, you can see which packages requires update across your VMs and how many machines are affected per specific one.

The result you can see is like this:

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
