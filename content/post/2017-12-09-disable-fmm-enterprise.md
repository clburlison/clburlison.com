---
categories:
- tech
date: 2017-12-08
draft: false
modified:
tags:
- macos
title: Disable FMM in Enterprise
toc: false
---

Find My Mac (FMM) is a service from Apple that allows individual iCloud users to locate their devices as long as they are signed in and the device has a valid internet connection. The problem, in enterprise, is we often do not want these services up and running due to security. You can disable the ability to sign into iCloud all together but what if you want to just stop FMM?

It is pretty easy to detect if FMM has been setup with:

```bash
/usr/sbin/nvram -x -p | /usr/bin/grep fmm-mobileme-token-FMM
```

and it's also pretty easy to disable:

```bash
nvram -d fmm-mobileme-token-FMM
```

However, the above option requires a restart! Users really do not like restarting their computers. Instead you can simply restart the `findmydeviced` process. This will properly remove the token and update the System Preference GUI to reflect the change.

```bash
nvram -d fmm-computer-name
nvram -d fmm-mobileme-token-FMM
killall -HUP findmydeviced
killall -HUP FindMyMacd
```

Technically removing the `fmm-computer-name` variable and restarting the `FindMyMacd` process are not required but for completeness they are shown. Since FindMyMacd obviously has something to do with FMM I would rather restart it just incase Apple changes something in a future release.


### More info
* [Disable iCloud, iCloud Drive...JamfNation](https://www.jamf.com/jamf-nation/discussions/19085/disable-icloud-icloud-drive-and-find-my-mac-on-existing-systems)
* [Find My Mac...clburlison.com](https://clburlison.com/find-my-mac/)
