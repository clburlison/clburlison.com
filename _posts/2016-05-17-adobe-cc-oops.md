---
title: Adobe CC Oops
modified:
tags:
 - adobe
---

I ran into the following error earlier this year and have yet to write about it. Adobe has the correct solution in another [knowledge base article](https://helpx.adobe.com/creative-cloud/kb/unknown-server-error-launching-cc.html) however the error messages are different. Since the errors looked to be different I never would have attempted the solution until [Karl](https://twitter.com/Adobe_ITToolkit) gave me a poke.

![]({{ site.url }}{{ site.baseurl }}/images/2016-05-17/adobecc_oops.png)

Basically I would launch Adobe's Creative Cloud Packager (CCP) tool and nothing would work. Luckily the fix is really simple:

```bash
rm -rf ~/Library/Application\ Support/Adobe/OOBE
```

Links:  
[Adobe Unknown Server Error](https://helpx.adobe.com/creative-cloud/kb/unknown-server-error-launching-cc.html)
