---
layout: post
title: Configuration Management
modified: null
categories: 
  - automation
  - puppet
excerpt: 
comments: true
published: true
image: 
  feature: null
  credit: null
  creditlink: null
tags: 
  - puppet
  - apple
  - os x
  - automation
  - configuration management
---

# Intro
This is part one in a four part series on using Configuration Management on OS X.

For the last five months, I have been seriously questioning my deployment process. Even with additions to Munki, mobileconfig support among others, it still seemed like I was using a jackhammer in place of a saw. Managing settings on Mac computers is puts sysadmins in a tricky place of:


* What settings are required for me to manage?
* What settings should I default to assist in using the platform?
* What settings should I leave 100% up to the user? 

Many sysadmins have the approach of settings as a user level choice however in education that is not really a fair comparison to private corporations. Students should have an easy process of using a platform. If that means I add all the "Program specific" applications to the dock, then so be it I will add them all. This is were I started to run into a major road block with Munki. It was designed to be a package management system. Even though I can package specific settings to work for 18+ different classrooms it becomes a royal pain to manage.

In comes Configuration Management to the rescue.

> Configuration management (CM) is a systems engineering process for establishing and maintaining consistency of a product's performance, functional and physical attributes with its requirements, design and operational information throughout its life.
> 
> [Wikipedia](en.wikipedia.org/wiki/Configuration_management)


# How to use CM?
As you could guess from my timeline above I am still relatively new to using configuration management. However I have been working a functional approach that fills the gap for me. I personally think one should only use CM to management files. After all most settings on a Mac are a file be it text file, plist, or some vendor specific. Package management however are better handled with Munki.


# Pain before CM
Before using CM I was required to maintain many different scripts for prod, testing, classroomA, classroomB, classroomC, etc. Oh don't forget to multiple that for different applications. Also, the awesomeness and hate that is firstboot scripts. They are great in getting a system setup however after that all settings go the way of the [Dodo bird](http://en.wikipedia.org/wiki/Dodo). Configuration Management allows one to apply settings to entire fleet, sub sections of the fleet, and effectively say "Be this way until I say otherwise." It's great but a huge change in the way of thinking if you are use to the "Apply this now" mentality.


# Puppet
After looking around at the many options for CM I decided on using Puppet. But don't let me stop you from checking out the [competition](http://en.wikipedia.org/wiki/Comparison_of_open-source_configuration_management_software):

* Ansible
* Salt
* Chef
* Puppet

I had already used Puppet personally but had always hated the idea of yet another server to maintain for yet another service. Puppet had the ability to use masterless, no puppet server via ``puppet apply``, however the setup and usage of a masterless setup always seemed even more unlikely for me. After revising the issues again in February of 2015 using this solution finally started to seem more useable. 

Puppet takes a huge change in thinking. Puppet defines a state that you want clients to be in...not how to be in that state. This will be touched on later but I wanted to plant that seed prior to getting into the full setup later. I found getting started with Puppet was relatively easy however starting to manage specific parts of the OS X client leaves tons of room for issues to arise. With the assistance mainly the [managedmac](https://github.com/dayglojesus/managedmac) module from Brian Warsing it becomes much easier to work with OS X.


# Conclusion
Although using CM is not needed it can become quite handy addition to have in your arsenal. Using check scripts and creating multiple packages for very closely related settings can be time consuming plus they are prone to error. In using Puppet I am able to apply settings for multiple different groups. The bonus is when I need to change the code to apply the setting I only have to change it one time instead of 18+ for each slightly different variation of the setting being applied.

In following posts I will describe the setup process and specifics on how to use Puppet in a masterless workflow.