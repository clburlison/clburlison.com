---
categories:
- tech
date: 2015-06-05T00:00:00Z
excerpt: How better to test something than throwing a bunch of clients at it?
header:
  image: 2015-06-05/imagr-banner.png
modified: null
tags:
- imagr
title: Imagr in production
---

# Intro
Many have written about Imagr but few have made the claim of dropping their old imaging solution completely. I made the claim in May after extensively testing Imagr with virtual machines however the real test was this week with 90 brand new Macs. That's right the good ol' unboxing, labeling, tagging, and prepping. It is the end of the school year and the Audio Video Department was pretty much done with gear, so I made a time lapse of the entire process. Cue nine hours of footage in 60 seconds. It would have been faster had it not been for those pesky MacBook Airs.

{{< youtube 5ixTdOXNCHo >}}


# Imagr Workflow
These were brand new computers so they already had a perfectly good operating system from Apple. If you are a part of the Munki community you know a recommended approach is to thin image the computer. This means my Imagr workflow had two items to install for all 90 of these computers (or at least that is how it started):

```xml
<dict>
  <key>name</key>
  <string>Puppet thin image</string>
  <key>restart_action</key>
  <string>restart</string>
  <key>description</key>
  <string>Thin image a computer.</string>
  <key>components</key>
  <array>
    <dict>
        <key>type</key>
        <string>package</string>
        <key>url</key>
        <string>http://imagrServer/puppet/puppet_run-20150408.pkg</string>
    </dict>
    <dict>
        <key>type</key>
        <string>package</string>
        <key>url</key>
        <string>http://imagrServer/puppet/puppet_bootstrap-20150603.pkg</string>
    </dict>
  </array>
</dict>
```

These two packages together essentially make up a normal [Firstboot](https://github.com/rtrouton/rtrouton_scripts/tree/master/rtrouton_scripts/first_boot) script that many might be familiar with. Not related to Imagr my bootstrap package installs a few Ruby Gems which sometimes would work and other times not so much. To resolve that issue I created a third package of Ruby Gems which allowed me to move along with my no-image setup.

# Issues
I prepped all 40 iMacs with only a small visual bug. When the computers would boot I would login to the Imagr applicaiton but the target disk would be blank. This only happened on a handful of computers and Imagr itself kept working. This issue has been logged on Github ([#84](https://github.com/grahamgilbert/imagr/issues/84)) and I plan to do more troubleshooting next week. My first guess it that is has something to do with the Fusion drives but I want to see if I can reproduce the issue.

The MacBook Airs (MBA) came around and I was really halted. MBA's don't have true ethernet ports so I was using Apple's Thunderbolt Adapters. They would work fine in the NetInstall environment but I would get to the Apple Setup Wizard and no network connectivity. If you click continue on the first setup screen connectivity would work. My initial solution was to install the following script by [Allen](https://github.com/golbiga/Scripts/blob/master/enable_external_network_adapter/enable_external_network_adapter.sh) however when I did my copy/paste failed me. The followup (bandaid) was to install a dummy user account and remove the Setup Wizard. This would get the laptop to the login window were network connectivity started to work. Later that evening [Joseph Chilcote](https://twitter.com/chilcote) reported a similar issue on twitter.

{{< tweet 606233511968808960 >}}

Then the following [pull-request](https://github.com/grahamgilbert/imagr/pull/86) fixed the issue.

Take-away: It is really nice when you are able to see the code...

# Conclusion
On May 14th, I dropped DeployStudio. On June 3rd, I have officially disabled the DeployStudio server components and all DeployStudio NBIs. Imagr honestly takes less time to setup than DeployStudio however it is not an all-in-one GUI application that is going to do everything for you. Imagr works really well, even though the above process was detailing a no-image workflow the imaging component works. If you want to get started go check out the [Imagr Wiki](https://github.com/grahamgilbert/imagr/wiki/Getting-Started).
