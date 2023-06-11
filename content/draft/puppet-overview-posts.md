---
title: "Masterless Puppet Articles"
draft: true
modified:
tags: [osx]
---

Masterless Puppet Articles
===

#Part 1 - Configuration management
- what is it?
- why you should use it?
- alternatives to puppet
- old method personally - AKA lots of packages, scripts, and firstboot scripts for each operating system. It works...so why change it
- Munki /= configuration management but it can work
	* creates a lot of edge cases and preflight scripts to "determine" if this client requires action
	* so let munki do what it does best...package management
- Using puppet


#Part 2 - Why go masterless
* what is a masterless setup? Definition time.

##Pro
- no server overhead
- everything is hosted on Github therefore it can be accessed anywhere
- Each client is self contained: each agent has all the parts needed to configure and manage itself

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

#Part 3 - Getting started with Puppet
## Puppet Run script
- credit to Graham Gilbert, Google for delay option
- how the script works (quick overview)

## More puppet details
- puppet.conf : what do all these settings do/mean (in depth line by line)
- Terminology what do all these repos have to mean?
	* puppet-environment
	* puppet-hiera
	* puppet-profile
	* puppet-roles (I'm not using)
- link/credit to garylarizza.com for more info
- initial settings site.pp

#Part 4 - Initial setup
- modules - your friend. managedmac
- default hiera values
- hiera.yaml
	* eyaml setup
	* how the hierarchy is setup
- creating a user (admin & standard)
	* using eyaml to encrypt important strings
- packaging puppet_run.pkg using Luggage to test settings
- using managedmac to set loginwindow info
