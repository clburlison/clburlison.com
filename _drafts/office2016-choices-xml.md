---
layout: post
title: "Office 2016 Choices XML"
modified:
categories: 
  - microsoft
  - bash
excerpt: Microsoft Office 2016 and using your choices to make the installer obey you, the admin.
comments: true
published: true
image:
  feature:
  credit: 
  creditlink:
tags: [office2016, choices.xml, microsoft, installer, command line, munki]
---

#Intro




 compare the un-choiced output versus the choiced output?

installer -pkg /Volumes/Microsoft\ Office\ 2011/Office\ Installer.mpkg/ -showChoicesAfterApplyingChangesXML ~/office_ccxml.plist -target / > ~/office_with_choices.plist


---

Links:  
[Munki ChoiceChangesXML Wiki](https://github.com/munki/munki/wiki/ChoiceChangesXML),  
[Office 2011 Choices Explained](https://jamfnation.jamfsoftware.com/discussion.html?id=13946#responseChild84049),  
[foigus MacAdmin Slack](https://macadmins.slack.com/archives/munki/p1449507566003215)