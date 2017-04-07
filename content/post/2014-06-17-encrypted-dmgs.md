---
categories:
- tech
comments: true
date: 2014-06-17T00:00:00Z
description: Apple has a build in way to create secure encrypted 256-bit AES disk
  images. This is a guide on creating these disk images, usage, draw backs, and think
  to remember.
keywords: apple, dmg, encryption, encrypted, secure, files, security
modified: 05-12-2015
published: true
aliases:
- /blog/2014/06/17/encrypted-dmgs/
tags:
- macos
title: Encrypted DMGs
---

We all know about file security but how many of our users take the time to properly protect their data? Sure you can make policy but unless someone documents the expectations, reasons, and how to do it, many users will simply ignore policy. How about personal files, we all store data on our computers that we know should be protect but how? Well luckily Apple has a very simple solution to the problem explained above.

## What to secure
First, you can secure whatever files your heart desires: bank statements, work files, photos, passwords, etc. Pretty much anything you want, though fair-warning this is not a backup solution and if you forget your encryption password it will make accessing those files quite difficult.

We secure files to limit access. This will help protect you in case your laptop gets stolen or maybe it just gets physically accessed by someone you know. This method will use a 256-bit AES encryption algorithm to secure your data. That being said if you use a simple password, *cough* `password` *cough*, then it is quite simple for someone to brute force hack that password and have access to your data.

**Disclaimer**: Nothing is 100% secure. This method is just another step that can help make it harder for someone to obtain your information. With enough time the right person could access these files but your average Joe is going to have a darn hard time.


# Creating an encrypted DMG
Step 1 - Open Disk Utility  
![](/images/2014-06-17/step1.png)

Step 2 - Create a Blank Disk Image...  
![](/images/2014-06-17/step2.png)

Step 3 - Name your new dmg. Note the values shown are important.

* Name: the mounted disk image name
* Size: depends on your data needs
* Format: the default `Mac OS Extended (Journaled)` should be fine for most needs
* Encryption: use 256-bit AES unless you have a solid reason to not
* Partitions: using `Single partition - GUID Partition Map` is a standard that is compatible with most Macs
* Image Format: using `sparse disk image` will save space on your hard drive and only use the disk space needed by the dmg

![](/images/2014-06-17/step3.png)

Step 4 - Here you want to type a secure password  
![](/images/2014-06-17/step4.png)

Step 5 - If you click the ``key icon`` OS X will help you create a secure password using the Password Assistant  
![](/images/2014-06-17/step5.png)

Step 6 - Note the file names. This is your encrypted dmg. You can store files here just like a flash drive.  
![](/images/2014-06-17/step6.png)

Step 7 - If you eject your dmg you will be presented with this pop-up the next time you try to open the dmg. Type your encryption password to unlock the dmg.  
![](/images/2014-06-17/step7.png)


## Video showing the process

{{< youtube zAc9H7AQ2TQ >}}

# Conclusion
Creating an encrypted dmg is quite easy once you know the steps. My preference is to not store the password in your Keychain. If you are logged into your machine another users could walk right up and open the dmg without typing a password.
