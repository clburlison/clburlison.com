---
layout: post
title: Import Logic Pro X Audio Content 
modified: 
categories: 
  - munki
excerpt: Import Logic Pro X Audio Content packages into your Munki repo.
comments: true
published: true
image: 
  feature: null
  credit: null
  creditlink: null
tags: 
  - python
  - script
  - logic pro x
  - audio
  - package
  - munki
  - os x
---


<div class="note info">
  <h5>Updated for Logic 10.2.0</h5>
	<b>September 18th, 2015</b>
  <p>This script has been updated to support Logic Pro 10.2.0. This release included many additional audio libraries for the added Alchemy Plugin. The updated script from Hannes will now download audio content to a "__Downloaded Items" directory and create hard links to Apple's categories.</p>
</div>

Today I needed to import 60 packages (37 GB) of audio content for Logic Pro X into my Munki repo. Hannes Juutilainen did most of the hard work with his [download-logicprox-content.py](https://github.com/hjuutilainen/adminscripts/blob/master/download-logicprox-content.py) script which will download all the packages from Apple. 

Then comes the tedious task of importing all 60 packages. I searched GitHub thinking someone else had already done this and found the following [project](https://github.com/portalpie/Logic-Pro-X-Additional-Content-Recipes) by Morgan Daly which uses [AutoPkg](https://github.com/autopkg/autopkg) in order to download and import the packages into Munki -- o_O. This works but is very much overkill as the audio content does not change frequently.

The previous script by Hannes will download the audio packages into many sub-directories like so:

{% highlight bash %}
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

{% endhighlight %}

As such I needed to recursively search for the ``.pkg`` extension and import those files into Munki. The result is the following python script: [munkiimport_logic_audio.py](https://github.com/clburlison/scripts/tree/master/clburlison_scripts/LogicProX)
