---
categories:
- tech
date: 2017-04-11
draft: false
modified: 2017-04-13
tags:
- microsoft
title: Office 2016 admin candy
---

<!-- toc -->

Office 2016 has had a few updates since my [last post](/demystify-office2016/) on the topic however most of these simply don't apply to me as an admin of the mac platform. Many of these updates have been bug and feature related which is great...I just do not see them as I am not a user. Honestly, since I finished college in December I have not used a Microsoft product on my mac except for Microsoft Remote Desktop.

Anyways without further ado...

# Training Videos

[![office4mac](/images/2017-04-11/office4mac.png)](http://www.office4mac.com)

[Paul Bowden](https://twitter.com/mrexchange) has been hard at work once again and has created a few fantastic Mac IT training videos. You can view the first video for free while the second course currently has a nominal fee that helps cover the site costs. I have gone through both videos at this time and highly recommend them. You can sign up and take a look at [http://www.office4mac.com](http://www.office4mac.com).

# Suite-Wide Pref Support

Another highly requested feature from macadmins, suite wide preferences is now available with the drop of 15.33. When Office 2016 for Mac was released it was found very early that the preferences back-end had moved from CFPreferences (Apple native) to a sqlite database. I remember hearing about this change at [PSU MacAdmins Conference](http://macadmins.psu.edu/conference/) in 2015 from [William Smith](https://twitter.com/meck) and thought it was a silly move.

However this change allowed Office developers to:

1. Share code between all the platforms that office runs on: macOS, Window, iOS, etc.
1. Solved a performance limitation that the team was hitting with CFPreferences due to how many preferences the Office apps have

The above rational is great but it came as major disappointment from the community since we now had much less control over the applications. Now with 15.33+ we get some of this control back. At this time, not all keys are manageable via this method but the foundation is now built, meaning Microsoft can add additional keys as needed. [Eric Holtam](https://twitter.com/eholtam) has a sample profile location [here](https://gist.github.com/poundbangbash/58ec77648d3903c40332493bf260d901) if you would like to view it. While the above MGMT200 training video from Paul goes into additional details.


# MAU 3.9

Microsoft AutoUpdate (MAU) has had two new features added. A quick history recap might be useful:

* MAU 3.6, released in August 2016, added the ability for users to update apps without needing admin privileges
* MAU 3.8, released in October 2016, added controls over Caching, Manifest, and the ability to automatically download and install updates in the background

Now MAU 3.9, released in April 2017, has added:

* the ability to update MAU itself with the same admin privileges and silent update behavior
* new logic in MAU to apply suite delta updates (more below).


# Office Suite Delta Updates

{{% alert info %}}
2017-04-12: An incorrect statement regarding the suite deltas has now been corrected.
{{% /alert %}}

This one is my **absolute** favorite update as it means we now have another upgrade option (not sarcasm actually super cool). I have been a big fan of using the full SKULess installer package for both initial installs and updates on my fleet since my finds in January in 2016.

This might look like a minor quality of life but it took quite a bit of engineering to get this released. Now instead of doing file based diffs for each of the applications individually, the team is able to do a complete diff of the entire suite. This method allows the team to wrap all updates, PowerPoint, Word, Excel, Outlook, and OneNote[^1], into a single ~280 MB update package for the entire suite. This will allow users to go from something like 15.33 to 15.34 with a single package that is almost a 1 GB smaller than the SKULess installer and almost 350 MB smaller than the five individual delta updates. Please note all of this is over the wire data and on disk space is not being changed.

A few warnings, before you start dropping this package into your management system, it should be noted that you will need to verify that the package is "safe" to install yourself. If you are using MAU to deliver your updates this will be an automatic change that will happen in the future. [MAUCacheAdmin](https://github.com/pbowden-msft/MAUCacheAdmin) has already been updated to support this new package so you will need to update your script if you are using a Caching Server. However Munki/Casper admins that plan on using this package will need to verify the following criteria is met:

* The existing apps on disk are exactly the **same version** and **build-date**


This feature isn't released to the production channel yet so your fleet will not start benefiting quite yet but I do recommend admins start testing now. The requirements for testing are meet the above criteria and the following, at least until this feature gets pushed to production:

* be on the Insider Fast channel
* have MAU 3.9 installed currently
* be on a build of 15.33 or higher


# Links
The macadmins.slack.com links require you to sign up for the team at [http://macadmins.org](http://macadmins.org).


* https://macadmins.slack.com/archives/C07UZ1X7B/p1490041743377690
* https://macadmins.slack.com/archives/C07UZ1X7B/p1490359089265776
* https://macadmins.slack.com/archives/C07UZ1X7B/p1491232403403708A
* https://macadmins.slack.com/archives/C07UZ1X7B/p1491427395346723

[^1]: OneNote is special and might not apply if you are installing from the Mac Apple Store
