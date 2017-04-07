---
categories:
- tech
date: 2014-05-19T00:00:00Z
description: null
keywords: Find My Mac, iCloud, nvram,
modified: 2015-09-21
aliases:
- /blog/2014/05/19/find-my-mac/
tags:
- macos
title: Find My Mac
---

Under the hood of Find My Mac there are some security details that are not widely published. These details should not concern most consumers however I found them quite interesting.

When a user enables Find My Mac (FMM) on their computer this is a system level change. This means if a user wishes to enable FMM they must be an administrator of the computer. A result of this is that in most environments where students are standard users this feature should never be enabled by accident. Another action that can be taken to limit FMM on machines under your management is to disable the iCloud prompt when a user logs into the machine for the first time. Look at Rich Trouton's [script](https://github.com/rtrouton/rtrouton_scripts/blob/master/rtrouton_scripts/disable_icloud_pop_up/disable_icloud_pop_up.sh) if you need a solution to do just that.


Some side affects of enabling FMM means giving access from [iCloud.com](https://www.icloud.com/#find) to do the following:

1. play a sound on the computer
2. lock the computer
	+ requiring a four (4) digit passcode
	+ optionally include a recovery message on the lock screen
3. erase the computer

The web interface  
![](/images/2014-05-19/icloud-interface.png)

Close up of the options  
![](/images/2014-05-19/icloud-options.png)


From my testing, if a computer is offline while one of these options are clicked from iCloud it takes approximately one minute for the signal to be processed on the computer in question (those this could be connectivity related). Playing a sound is by far the fastest option while taking less than one second most of the time when the computer is online. If you choice to lock the computer this will cause your computer will immediately lock up and restart. You will presented with the a screen like the following.  
![](/images/2014-05-19/icloud-lock.png)

Though I did not test, my guess is that an erase will prompt the computer to go into a state like the lock screen while deleting your data. If anyone feels like testing this feel free to contact me with results on twitter.

## NVRAM
None of the information above is particularly shocking if you yourself have ever used Find my iPhone or any of the similar Find my device services from Apple. What is interesting is where this data is stored on your computer...the nvram. This means even if someone removes the hard drive of your computer the information to connect to iCloud is still present. This is great news if your laptop was actually stolen (and connected to the internet) but what does this mean when reassigning a computer that has had FMM enabled? Well the previous user could erase all the information on this laptop at any time in the future. So now I have to check with every user to see if they have had FMM enabled when reassigning a computer? Well, instead of dealing with that huge hassle when it comes around to re-imaging or reassigning a computer you can simply run the following command to clear the nvram of content related to Find my Mac.

**Disable iCloud from the Command Line**   
```bash
$ nvram -d fmm-computer-name  
$ nvram -d fmm-mobileme-token-FMM
```

## Consumers
This means if you ever purchase a second hand Mac from someone you will want to run the same command just for safty. Also, if you are attempting to sell your device be a good consumer and run the command for the next owner.

If you are not familiar with the command line use the following:

#### Resetting NVRAM / PRAM
1. Shut down your Mac.
2. Locate the following keys on the keyboard: Command (⌘), Option, P, and R. You will need to hold these keys down simultaneously in step 4.
3. Turn on the computer.
4. Press and hold the Command-Option-P-R keys before the gray screen appears.
5. Hold the keys down until the computer restarts and you hear the startup sound for the second time.
6. Release the keys.

**Note**: Apple ID's are considered personal. Even if you use a work email address these are accounts are not designed to be use by more than ten (10) devices. This is a hard limit set by Apple. Do _not_ attempt to setup all corporate laptops on one Apple ID it will not work. In fact do not use FMM, it was not designed for this...look into [Meraki](https://meraki.com/login/dashboard_login) if you need a free solution.

---

Articles: [Disable find my Mac](http://ilostmynotes.blogspot.com/2013/11/disable-find-my-mac-by-modifiying-nvram.html)  

External resources regarding iCloud: [Apple Find my Device Support](http://www.apple.com/support/icloud/find-my-device/),
[Cnet](http://www.cnet.com/how-to/how-to-use-find-my-mac-in-icloud/), [Macworld](http://www.macworld.com/article/2034795/how-to-track-a-lost-computer-with-find-my-mac.html)
