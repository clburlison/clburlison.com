---
categories:
- tech
date: 2014-04-24T00:00:00Z
description: Lessons learned while setting up boxen for personal usage.
keywords: boxen, puppet, github, automation
modified: null
aliases:
- /blog/2014/04/24/things-learned-from-boxen/
tags:
- puppet
title: Things learned from boxen
---

## What is boxen?
So odds are if you have landed on this page you have probably already heard of boxen. For those who have not heard yet, boxen is an open source project created by the good people at [github.com](http://github.com) as a way to quickly setup a Macintosh computer. Boxen can also be used as a way to keep certain settings managed between two or more devices. Think for a second, your laptop goes with you everywhere and along with that you have all of your custom shell scripts, shell alias, ssh keys, etc. With boxen you can systematically take all those settings that you love and move them to every computer you use.

---

## First lesson learned
Starting out I found out how few of my settings I had documented. The problem that plagues every IT department, documentation. With a mult-user network, this is a pretty big deal since it can cause confusion in the future along with creating ample down time when you are trying to troubleshoot a system that you setup, customized, and did not document. We all know the pit falls of doing this in a mult-user environment but my laptop is a single-user environment and except for extremely rare cases, I am the only one that uses it. Why do I need to document settings for my laptop you might ask?

Well hopefully, this never happens but what do you do when your hard drive crashes, or you accidentally ran a remove command in the wrong directory tree? Gone are the days where you could shut the door and start rebuilding from scratch...sure you could restore from a backup but boxen tackles a task like this a little differently. Boxen is not a backup solution it is used to manage a system. With boxen, I have a complete history of all the changes I have made to my system. Might not seem like a big deal, but it makes life much easier when trying to find out how you set AirDrop to work over Ethernet connections. Hint: [Previous Article](/blog/2014/04/18/enable-airdrop-on-ethernet/), or [my config file](https://raw.githubusercontent.com/clburlison/my-boxen/master/modules/people/manifests/clburlison/config.pp).

Hopefully you can see the power of this. I was late to the party but finally got around to using boxen and now cannot imagine making changes without documenting it this way. Sure having text files stored on a file-share is a solution, but this is a living git repo that allows me to document everything, plus I have a built-in file versioning with commits.

### How you can get started?
Now is a good time to note, I am not completely up to speed with puppet aka the backend of boxen. I was however able to hack around until I got the stuff to work. Start small with configuring the installation of say Firefox. Once you get that working keep looking around on [github.com/boxen](http://github.com/boxen) and see if there are other applications you can add easily. If not move on to what I like to call "borrowing code from those smarter than me". You too can participate in this act by downloading other's boxen repos. Looking inside their configurations files and copying and pasting code.

At first, you might not know what you're doing and that is fine. It is a learning experience after all but over time you will begin to understand the structure of the code. Odds are, if you are trying to automate some part of your Mac someone else wants to do it as well or already has. Do not attempt to reinvent the wheel.

So which repo's do I recommend you looking at the most? [Gary Larizza](https://github.com/glarizza/my-boxen), [Graham Gilbert](https://github.com/grahamgilbert/my-boxen), and [mine](https://github.com/clburlison/my-boxen) are full of useful code. You will still want to learn puppet but hopefully the comments in the repos listed above help guide you through starting out.

### Dropbox usage
One of the issues I ran into while looking at boxen was storing personal information in a public github repo. You could make your boxen repo private but that was not the method I wanted to take. I could also just copy all my private information after the initial boxen setup but does that not defeat the main purpose of boxen? Luckily Graham had already found out a solution which is to use Dropbox for everything that should not be shared with others. Before I continue on let me put a disclaimer that if you plan on storing ssh keys, license files, or really personal information you really need to enable two-step verification. Attached [here](https://www.dropbox.com/help/363/en) is the setup guide as this is very important for you to do.

You setup 2fa for Drobox, right? If you have not what are you waiting for? Now that your Dropbox is secure or at least more secure, I would create a directory structure that matches OS X. This might make for long paths while creating settings in puppet code but having a logical file-management system that actually matches where the files are actually being placed by boxen will help. Below is a screenshot of my directory structure as of this writing.  
![dropbox-config](/images/2014-04-24/Dropbox-config.png)

### No really how can I get started?
* Well Gary has the best write up though it is a bit dated [Puppet + Github = Laptop Love](http://garylarizza.com/blog/2013/02/15/puppet-plus-github-equals-laptop-love/)
* Easy step-by-step setup [Coffee Cup Blog](http://coffeecupblog.com/blog/2013/03/24/automate-your-mac-provisioning-with-boxen-first-steps/)
* Another easy let's get started [Thomas Riboulet](https://coderwall.com/p/kppokq)

## Summary
Boxen is free to use. Allows you to configure existing computers, bootstrap new computers, and keep an online documentation detailed of all the custom settings that you love about your computer. Boxen is also a great way to get started with puppet.
