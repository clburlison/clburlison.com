---
categories:
- tech
title: Preview files from terminal
date: 2014-11-10T00:00:00Z
excerpt: Preview files from Terminal.
link: http://krypted.com/mac-security/qlmanage/
aliases:
- /blog/2014/11/10/preview-files-from-terminal/
tags:
- bash
- macos
---

> QuickLook scans file contents before you open those files. Usually this just lets you view a file quickly. But you can also use this same technology from the command line to bring about a change to the Finder without actually opening a file. To access QuickLook from the command line, use qlmanage.
>
> qlmanage -p ~/Desktop/MyTowel42.pdf
>
> ---Charles Edge

---

I highly recommend adding an alias to your either your .bashrc or .bash_profile. This will make accessing the command faster, plus you have the added benefit of not seeing all the debug information in your current terminal session.

Below is the command I use:

```bash
ql () { qlmanage -p "$*" >& /dev/null; }
```

Now you can preview a file from Terminal by using ``ql`` plus the path to a file.
