---
categories:
- tech
date: 2014-09-29T00:00:00Z
excerpt: Everything you need to know about Shellshock for OS X in English.
header:
  caption: 'Photo credit: [**nghenhinvietnam**](http://nghenhinvietnam.vn/tin-tuc/shellshock-bash-loi-bao-mat-gay-tac-hai-lon-hon-heartbleed-988.html)'
  image: 2014-09-29/shellshock3.jpg
modified: 2014-10-2
aliases:
- /blog/2014/09/29/shellshock/
tags:
- bash
title: Shellshock
---

On September 24, 2014, a security vulnerability was publicly announced that affects a large percentage of Internet connected devices. This vulnerability, known as Shellshock, affects the Unix command shell Bash. Bash, the bourne again shell, is one of the most common applications on Unix based systems. Many devices running Mac OS X or Linux are affected by this serious exploit.

It is important to understand that this vulnerability could allow unauthorized access of your computer. Although this exploit has been around for over two decades do not underestimate the seriousness, immediate patching should be deployed when possible.

## Patch

__OS X bash Update 1.0 may be obtained from the following webpages:__  
[http://support.apple.com/kb/DL1767](http://support.apple.com/kb/DL1767) – OS X Lion  
[http://support.apple.com/kb/DL1768](http://support.apple.com/kb/DL1768) – OS X Mountain Lion  
[http://support.apple.com/kb/DL1769](http://support.apple.com/kb/DL1769) – OS X Mavericks  

_released:_ September 29th, 2014

## Future
So if you install the patch you might think, "Great I'm done", crisis adverted. False! Since the original Shellshock exploit (CVE-2014-6271) at least four additional exploits have been found. If you would like to test your Mac to see if you are vulnerable you can use the following [script](https://github.com/hannob/bashcheck) to help identify exploits that you are susceptible to.

Additional bugs related to Shellshock:

* CVE-2014-6271 (original shellshock)
* CVE-2014-7169 (taviso bug)
* CVE-2014-7186 (redir_stack bug)
* CVE-2014-7187 (nested loops off by one)
* CVE-2014-6277 (lcamtuf bug)

You can use the following website if you would like to see the official reports [here](https://cve.mitre.org).

At this point, the worst might be behind us. Pay attention to Apple updates, as future issues are reported, another patch for Bash will be most likely be released by Apple.

---

Articles:  
[Apple Stack Exchange](http://apple.stackexchange.com/questions/146849/how-do-i-recompile-bash-to-avoid-shellshock-the-remote-exploit-cve-2014-6271-an/146851#146851),  
[Apple working to protect OS X against shellshock](http://www.imore.com/apple-working-quickly-protect-os-x-against-shellshock-exploit),  
[Bash fix not in SUS](https://twitter.com/harryfike/status/516767315636285440),  
[Github bashcheck script](https://github.com/hannob/bashcheck),  
[Remote exploit vulnerability in bash](https://groups.google.com/forum/?fromgroups#!topic/macenterprise/o26UYKc2JvM),  
[What is Shellshock](http://www.pcworld.com/article/2688672/two-scenarios-that-would-make-os-x-vulnerable-to-the-shellshock-bug.html),  
