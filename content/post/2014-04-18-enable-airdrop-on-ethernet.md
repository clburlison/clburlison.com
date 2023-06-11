---
categories:
- tech
date: 2014-04-18T00:00:00Z
description: Quick post over enabling AirDrop over Ethernet.
keywords: AirDrop, Ethernet, cli, Terminal,
modified: 2014-11-19
aliases:
- /blog/2014/04/18/enable-airdrop-on-ethernet/
tags:
- macos
title: Enable AirDrop on Ethernet
---

A quick post over enabling AirDrop to use an ethernet connection along with the default wireless connection.

---

> AirDrop helps you share items with others nearby...a quick way to share files wirelessly between two Macs, without having to connect to an existing network.
>
> -- [Apple KB Article](http://support.apple.com/kb/ht4783)

AirDrop provides a great file-sharing experience and numerous departments at my workplace have grown to love it. The service is good for simple file exchanges without needing to use a files-share. That is until someone in the audio video department tries to send five (5) or more gigabytes of video files to someone sitting right next to him. This starts to cause problems as people experience slow downs and decide to wait instead of using our gigabit ethernet connection.

Apple provides the ability to use AirDrop over ethernet but did not enable it by default. We can only assume this was for good reason so enabling it could have unknown consequences. I have been using it for well over three (3) months without any issue, but your milage may vary. I will state that after issuing this change I needed to restart both machines for the devices to be able to utilize the AirDrop service (wireless or wired).

Type the following line of code into Terminal to make the change. Remember this needs to be made on both machines for it to take place.

**Enable AirDrop Over Any Network Connection**
```bash
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
```

**Disable AirDrop Over Any Network Connection**
```bash
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 0
```

---

Article:
[Mac Basics: AirDrop](http://support.apple.com/kb/ht4783)
