---
categories:
- tech
date: 2015-05-27T00:00:00Z
excerpt: My ramblings on puppet as a configuration management tool on OS X.
modified: 2015-06-01
tags:
- automation
- puppet
title: Configuration Management
---

<!-- toc -->

# Intro
This is part one in a four part series on using Puppet on OS X. However to understand my move to Puppet I wanted to share my thoughts on Configuration Management (CM) in general.

For the last five months, I have been seriously questioning my deployment/management process. Even with Munki's native support for configuration profiles in [v2.2.4](https://github.com/munki/munki/releases/tag/v2.2.4), it has always seemed like I was creating extra work for myself. This extra work is mainly related to how we need to manage settings on OS X, it is quite the balancing act:

* What settings are required for me to manage?
* What settings should I apply defaults?
* What settings should I leave alone?

Many sysadmins have the idea of "settings" as a user level choice however in education that is not really a fair comparison to private corporations. Students and teachers should have an easy transition to using the OS X platform. If that means I add all the "Program specific" applications to the dock, then so be it I will add them all. This is were I started to run into a major road block with Munki. It was designed to manage software installs. Even though I can package specific settings to work for 18+ different classrooms it is error prone  and quite a royal pain to manage.

In comes Configuration Management to the rescue. Obligatory CM definition below.

> Configuration management (CM) is a systems engineering process for establishing and maintaining consistency of a product's performance, functional and physical attributes with its requirements, design and operational information throughout its life.
>
> [Wikipedia](en.wikipedia.org/wiki/Configuration_management)

# Pain prior to CM
Before using CM, I was required to maintain many different scripts for prod, testing, classroomA, classroomB, classroomC, etc. In conjunction add on firstboot scripts as those [rarely change](https://github.com/rtrouton/rtrouton_scripts/tree/master/rtrouton_scripts/first_boot) *{sarcasm}*. Firstboot scripts are great in getting a system setup however after initial setup everything goes the way of the Dodo bird. Configuration Management allows one to apply settings to their entire fleet, sub sections of the fleet, and effectively say "Be this way until I say otherwise." It's great but a huge change in the way of thinking if you are use to the "Apply this now" mentality which is effectively how many use Munki (myself included).

But doesn't Munki have check a ``installcheck_script``? Yes, that feature is available but it does not replace the services that many CM products provide.

Tim Sutton explained this recently on the munki-dev googlegroup. A relevant quote is below however the specific thread is of value related to this idea of CM and Munki.

> More and more of these CM 'tasks' are best handled using Configuration  
> Profiles, and Munki actually has good built-in support for these. I've  
> been able to get by using Munki as my "configuration management"  
> system instead of implementing another tool, just because the things I  
> would use Puppet for only account for about 5% of the items in my  
> repository - the rest are installers for software, updates,  
> configuration profiles and supporting LaunchAgents/LaunchDaemons.  
>
> [Tim Sutton](https://twitter.com/tvsutton) - [source](https://groups.google.com/d/msg/munki-dev/l_T_aZM9TGU/yb-CWZAv7UQJ)

What Tim says above is absolutely true. However when that 5% is the most time consuming to "manage" and update you might want to look into a different solution. I have gotten away with using Munki as an all-in-one solution for over three years however when you need something custom...you have to write something custom. Also, don't forget to verify that custom something you just wrote works on all machines, with the logic in place to work with older operating systems.

# How to use CM?
I am still relatively new to using configuration management. However I have been working on a functional approach that fills the gap for me. The best advice I can give is to use CM for settings. Use a software solution, like Munki, for all packages. When you start making your CM product install software things can get complicated very quickly.

For a list of items I believe a CM product excels at managing:

* Admin account
* All profiles (Wi-fi, Safari, Finder, Office2011, Chrome, iCloud, LoginWindow, etc.)
* Management scripts (dockutil, BigHonkingText, Exchange Setup, etc.)
* Remote Management settings
* Remote Login
* Sudoers file
* etc.

# Puppet
After looking around at the many options for CM I decided on using Puppet. But don't let me stop you from checking out the [competition](http://en.wikipedia.org/wiki/Comparison_of_open-source_configuration_management_software).

I had already used Puppet personally but had always hated the idea of yet another server to maintain for yet another service. Puppet has had the ability to use a masterless setup, via ``puppet apply``, however usage of a masterless setup always seemed even more unlikely for me. After revisiting the issues again in February of 2015 using this solution finally started to seem more feasible.

Puppet takes a huge change in thinking. Puppet code defines a state that you want clients to be in...not how to be in that state. This will be touched on later but I wanted to plant that seed prior to getting into the full setup later. I found getting started with Puppet was relatively easy however starting to manage specific parts of the OS X client leaves tons of room for issues to arise. With the assistance mainly the [managedmac](https://github.com/dayglojesus/managedmac) module from Brian Warsing it becomes much easier to work with OS X clients using puppet.


## Example code
The hiera code below is used to create a local admin account and make sure that account is always present:

```yaml
managedmac::users::accounts:
  ladmin:
    uid: 999
    gid: 80
    ensure: present
    iterations: 36630
    password: 92d2d837084ac329006a16d67f8c87fdba141b6665c2d4910aee72e3ce777bd58cc7170fe266201ddc8bfc79ca78ab6ba85824019429e8f37072dc0cc26cf7b726d78f8d7543eb72c7be2db6483c3027d77e0eb8146d6dc03e10e5650d7c2560a97b86b287e945dbcf112edde5f3c61b07ee80615e0ada5ac11278651f9eef4b
    salt: 2562f7a1bde6eac36352ec1a4621ee945e663a2180bb90fab0f9cdd98b202d3e
```

*Note:* the above password is ``temp``.


To allow that admin account to have ssh and remote management access:

```yaml
managedmac::remotemanagement::enable: true
managedmac::remotemanagement::users:
  techsupport: -1073741569

managedmac::sshd::enable: true
managedmac::sshd::users:
   - techsupport
```

The syntax is easy to read. Even without knowing anything about Puppet or how Hiera works the above lines should make sense. Unfortunately, the above code on its own does nothing. The computer needs to know how to use that code which I will detail in a later post.

# Conclusion
Although using CM is not needed everywhere it can become quite handy. Using check scripts and creating multiple packages for closely related settings can be time consuming plus they are prone to error. In using Puppet, I am able to apply settings for multiple different groups however I only write the code once. The main advantage is when change is needed all 18+ versions look to one "master code" allowing me to make my updated change once.

In following posts I will describe the setup process and specifics on how to use Puppet in a masterless workflow.

---

Articles:
[Tim's comment on googlegroups/munki-dev](https://groups.google.com/d/msg/munki-dev/l_T_aZM9TGU/yb-CWZAv7UQJ)
