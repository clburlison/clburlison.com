---
categories:
- tech
date: 2015-02-20T00:00:00Z
excerpt: Steps to shrink the virtual disk of a linux vm using VMware Fusion.
aliases:
- /blog/2015/02/20/shrink-linux-vm-disk/
tags:
- vmware
title: Shrinking a linux virtual disk
url: "shrink-linux-vm-disk/"
---

I have written about shrinking the virtual disk of an OS X Virtual Machine [here](/blog/2014/04/01/shrinking-the-disk-image-of-an-os-x-vm/) but recently I needed to shrink a Linux virtual machine. The process is almost identical across all of VMware's products you just have to find the ``vmware-vdiskmanager`` tool.

# The process

In most operating systems removing the files from the disk merely alters file tables so the operating system sees the space as free on the disk. For ``vmware-vdiskmanager`` to work, the disk space actually needs to be free which we can accomplish using a processed called zeroing.

The steps below could take quite some time depending on the files being deleted, speed of the disks, and CPU of the virtual machine.

__On the Virtual Machine:__
```bash
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
```

Now that we have successfully zeroed the data use ``vmware-vdiskmanager`` to shrink the virtual disk.

__On the VM Host:__
```bash
"/Applications/VMware Fusion.app/Contents/Library/vmware-vdiskmanager" \
 -k "/path/to/your/vm/disk.vmdk"
```

---

Articles:  
[Growing, thinning and shrinking virtual disks for VMware ESX and ESXi](http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1002019),  
[Shrinking the disk image of an os x vm](/blog/2014/04/01/shrinking-the-disk-image-of-an-os-x-vm/)
