---
title: Using Masterless Puppet
draft: true
modified:
excerpt: Pros/Cons of using Puppet in a masterless configuration.
tags:
  - puppet
  - osx
---

<!-- toc -->

# Intro
It has been a while since I wrote about Puppet and honestly I still have split opinions on the following workflow as a whole. However the below method is a way to start using Puppet with a relatively low starting pain. I do not consider myself an expert on this topic. The following is meant to help those new to the idea of Configuration Management, specifically Puppet, with a working masterless workflow. More or less a getting started with Puppet for managing Macs.

Puppet can be used in two standard configurations, using a Puppet master and in a masterless setup. Using a Puppet Master simply means you have a server, or cluster of servers, that hold configuration data for your clients. This has many pros and cons that will be slightly touched on later. The other setup is masterless, aka using Puppet without a server. This normally means that any dependencies you have for your configuration data will need to be located on all clients that you manage. However since each client computer has all the pieces of data they need to configure themselves you are no longer reliant on your server being up and functioning.   


# Pros of masterless
* no server overhead
* each client has all needed decencies
* no certificate authority setup
* much easy and cheaper to scale
* all decencies can be hosted in git (Github, BitBucket, Gitlab, internal, etc.)
* after initial cache runs can happen locally without internet connectively

# Cons of masterless
* potentially more moving parts for clients
* easy to lose security
	* using the method descrbited below an admin user could decrypt secure data
*  

# Conclusion


---



##Con
- more moving parts for clients
	* list gems: sqlite, eyaml, etc.
- mention ssl security issue ***HUGE issue*** if users are admin they can decrypt data and have access to files that shouldn't have access to
- need to managed ssl for eyaml data using an alternative method
- reporting is not built in...no puppetdb. Need alternative methods for reporting from clients
- command line tools are required on client machines
- With all the moving parts it can be easy to get lost in the order of everything and harder to troubleshoot. this is more of a puppet con rather than just the masterless workflow.

##Components of the masterless workflow
- a script installs: facter, puppet, & heria plus any required gems
- r10k downloads all git repos
- eyaml secures private data from prying eyes
- client checks in, gets "updates", compiles the delta updates against how the system currently is and modifies only the parts needed to keep the system in compliance.


---

Articles:
