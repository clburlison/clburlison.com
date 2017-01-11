---
categories:
- tech
date: 2016-05-17T00:00:00Z
modified: null
tags:
- adobe
title: Adobe CC Oops
---

I ran into the following error earlier this year and have yet to write about it. Adobe has the correct solution in another [knowledge base article](https://helpx.adobe.com/creative-cloud/kb/unknown-server-error-launching-cc.html) however the error messages are different. Since the errors looked to be different I never would have attempted the solution until [Karl](https://twitter.com/Adobe_ITToolkit) gave me a poke.

![](/images/2016-05-17/adobecc_oops.png)

Basically I would launch Adobe's Creative Cloud Packager (CCP) tool and nothing would work. Luckily the fix is really simple:

```bash
rm -rf ~/Library/Application\ Support/Adobe/OOBE
```

Links:  
[Adobe Unknown Server Error](https://helpx.adobe.com/creative-cloud/kb/unknown-server-error-launching-cc.html)
