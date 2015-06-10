---
layout: post
title: "Imagr in production"
modified:
categories: 
- imaging
- imagr
excerpt: How better to test something than throwing a bunch of clients at it?
comments: true
published: true
image:
  feature: /2015-06-05/imagr-banner.png
  credit:
  creditlink:
tags: [osx, imagr, imaging, OS X, Mac, Munki]	
---

#Intro
Many have written about Imagr but few have made the claim of dropping their old Imaging solution completely. I made the claim in May ago after extensively testing Imagr with multiple virtual machines however the real test was this week with 90 brand new Macs. That's right the good ol' unboxing, labeling, tagging, and prepping. It is the end of the school year and the Audio Video Department was pretty much done with gear, so what better way to utilize resources than making a time lapse of the entire process. Cue nine hours of footage in 60 seconds. It would have been faster had it not been for those pesky MacBook Airs. 

{% youtube 5ixTdOXNCHo 560 315 %} <br>

#Imagr Workflow
These are brand new computers which mean they already have a perfectly good operating system from Apple. If you are a part of the Munki community you know a recommended approach is to thin image the computer. This means my Imagr workflow had two items to install for all 90 of these computers (or at least that is how it started):

{% highlight xml %}
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
{% endhighlight %}

These two packages together are the essentially make up a normal Firstboot package that many might be familiar with.


#Issues


#Pro Con List
So after even more testing here is my comparison of DeployStudio to Imagr. Both are great products however they are in the Imaging market so it is important to note where things stand.

<center><b><u>Imagr</u></b></center>

Pro | Con
--- | ---
Faster | Plist Configuration
Open Source | 
Smaller NBI | 
OS X not needed | 
Plist Configuration |

#Conclusion
On May 14th I said I dropped DeployStudio. On June 3rd, I have officially disabled the DeployStudio server components and all DeployStudio NBIs. 

---

Articles:  


Graham has his official announcement post, Greg has in regarding testing Imagr, Nick has great documentation on setting up Imagr, Erik has information regarding the transition from DeployStudio to Imagr...