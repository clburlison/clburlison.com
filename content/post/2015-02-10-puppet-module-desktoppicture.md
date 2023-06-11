---
categories:
- tech
date: 2015-02-10T00:00:00Z
excerpt: My first real puppet module designed to help you modify the desktop picture
  on OS X.
aliases:
- /blog/2015/02/10/puppet-module-desktoppicture/
tags:
- puppet
- automation
title: Puppet Module desktop picture
url: "puppet-module-desktoppicture/"
---

# Intro
I have been using puppet in one way or another since April of 2014. My first introduction to puppet was [boxen](https://boxen.github.com/) but up until recently I have only focused on how puppet can apply to me personally. With this module and a few ideas I have for the future this is going to change the way clients are configured at ``$work_place``.

Now this technically is not my first module it is the first module that I have created the logic and wrote entirely myself. The predecessor to this module [puppet-outset](https://github.com/clburlison/puppet-outset) was basically a few line changes from a module that Graham Gilbert [made](https://github.com/grahamgilbert/puppet-scriptrunner). With this project my eyes have been really opened into how powerful puppet is.

## What does it do?
This module handles dynamically creating scripts that will change the wallpaper on Mac OS X. It has been testing with 10.7 through 10.10. Works great with hiera and validates your data if you input bad entries. This module is in a way an add-on to my [puppet-outset](https://github.com/clburlison/puppet-outset) module.

![](/images/2015-02-10/puppet-module.png)

[Check it out](https://github.com/clburlison/puppet-desktoppicture).

If you are familiar with puppet code and the standard practices the documentation I have included within the classes should make this module self-explanatory. Also, if you have any issues please let me know on [Github](https://github.com/clburlison/puppet-desktoppicture/issues).

# More
In the next few months expect a few more posts on puppet from the OS X Administration perspective.

---

Articles:  
[desktoppicture on GitHub](https://github.com/clburlison/puppet-desktoppicture),  
