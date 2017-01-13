---
categories:
- tech
date: 2015-08-24T00:00:00Z
excerpt: Import Logic Pro X Audio Content packages into your Munki repo.
modified: 2015-11-17
tags:
- munki
- python
title: Import Logic Pro X Audio Content
url: "import-logic-pro-x/"
---

{{% alert info %}}
**Updated for Logic 10.2.0 - September 18th, 2015**

This script has been updated to support Logic Pro 10.2.0. This release included many additional audio libraries for the added Alchemy Plugin. The updated script from Hannes will now download audio content to a "__Downloaded Items" directory and create hard links to Apple's categories.
{{% /alert %}}


Today I needed to import 60 packages (37 GB) of audio content for Logic Pro X into my Munki repo. Hannes Juutilainen did most of the hard work with his [download-logicprox-content.py](https://github.com/hjuutilainen/adminscripts/blob/master/download-logicprox-content.py) script which will download all the packages from Apple.

Then comes the tedious task of importing all 60 packages. I searched GitHub thinking someone else had already done this and found the following [project](https://github.com/portalpie/Logic-Pro-X-Additional-Content-Recipes) by Morgan Daly which uses [AutoPkg](https://github.com/autopkg/autopkg) in order to download and import the packages into Munki -- o_O. This works but is very much overkill as the audio content does not change frequently.

The previous script by Hannes will download the audio packages into many sub-directories like so:

```bash
── Apple Loops
│   ├── Chillwave
│   │   └── MAContent10_AppleLoopsChillwave.pkg
│   ├── Deep House
│   │   └── MAContent10_AppleLoopsDeepHouse.pkg
│   ├── Dubstep
│   │   └── MAContent10_AppleLoopsDubstep.pkg
│   ├── Electro House
│   │   └── MAContent10_AppleLoopsElectroHouse.pkg
│   ├── Hip Hop
│   │   └── MAContent10_AppleLoopsHipHop.pkg
│   ├── Modern R&B
│   │   └── MAContent10_AppleLoopsModernRnB.pkg
│   └── Tech House
│       └── MAContent10_AppleLoopsTechHouse.pkg
├── Bass
│   └── MAContent10_InstrumentsBass.pkg
...

```

As such I needed to recursively search for the ``.pkg`` extension and import those files into Munki. The result is the following python script: [munkiimport_logic_audio.py](https://github.com/clburlison/scripts/tree/master/clburlison_scripts/LogicProX)

<div class="notice--danger">
	<b>10.11 and Logic Audio Content -- November 17th, 2015</b>
  <p>Dave Weale found a nice little bug with this approach. <br><br><u>TL;DR:</u> 10.11 has SIP enabled and Apple is writing Receipts for the audio content to <code>/System/Library/Receipts</code>. When munki imports these packages we are using the package receipts to determine if the content has been installed. When removing the package content Munki is unable to remove the recipe as /System is SIP protected.
    <br><br>
    More info: <a href="https://groups.google.com/forum/#!topic/munki-discuss/TjeSl39zGVw">Logic Pro X assets not installing after removal & attempted reinstall</a>
  </p>
</div>
