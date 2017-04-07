---
categories:
- tech
date: 2014-04-01T00:00:00Z
description: Article examines steps to reduce the disk size of a vmdk file on a mac.
keywords: vmware, osx, mac, shrinking vmdk, mavericks
modified: null
aliases:
- /blog/2014/04/01/shrinking-the-disk-image-of-an-os-x-vm/
tags:
- vmware
- macos
title: Shrinking the disk image of an OS X VM
---

Reducing the size of a guest OS X Virtual Machines's vmdk file requires a few steps.  For a Windows VM's, there is a tool from VMWare with a GUI.  Unfortunately, there is not an equivalent tool for the Mac guest VM.

---

This technique has tested and confirmed on OS X 10.9.2 using VMware Fusion 6.02 though it should work from 10.7 and up. This assumes your guest vm’s disk is not pre-allocated, and the virtual machine does not have any snapshots. If you have any snapshots now would be a good time to delete them.  

Space is always a constraint so the smaller my Virtual Machines the better. Plus, backing up a Virtual Machine or transferring to a separate drive is much faster the smaller the vmdk is.

1. Prepare the disk image for shrinking by using the guest vm’s Disk Utility.app to “Erase Free Space” (fast zero’ing will suffice).  For a disk image using 15 to 20GB, this may take five to ten minutes. When complete, shut down the vm and close the VMware Fusion app.

2. Using Finder, confirm the location of your guest vm’s vmdk files.

3. Open Terminal and type the following changing the path to your virtual disk at the end.
```bash
$ "/Applications/VMware Fusion.app/Contents/Library/vmware-vdiskmanager" \
 -k "/path/to/your/vm/disk.vmdk"
```

If you’ve successfully entered the command, Terminal will display ``"$ Shrink: xx% done."`` until the operation is complete.  

---

Article: [http://blog.aitrus.com/](http://blog.aitrus.com/2012/07/28/vmware-fusion-shrinking-the-disk-image-of-an-os-x-guest-vm/)
