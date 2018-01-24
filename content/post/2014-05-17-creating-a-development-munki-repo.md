---
categories:
- tech
date: 2014-05-17T00:00:00Z
description: Use vagrant along with virtualbox to create a fully functional munki_repo
  for testing on your localhost.
keywords: munki, vagrant, development, testing, munki_repo,
modified: 2014-05-18
aliases:
- /blog/2014/05/17/creating-a-development-munki-repo/
tags:
- munki
title: Creating a development munki_repo
url: "creating-a-development-munki-repo/"
---

<!-- toc -->

{{% alert danger %}}
**Outdated:** These instructions are no longer current and are considered deprecated. This document remains for historical reasons only. Faster and easier methods exist for creating development environments.
{{% /alert %}}

I created a vagrant box that allows you create a completely self contained munki_repo for testing purposes. With the usage of [PuPHPet](https://puphpet.com) the process was quite easy.

This article describes basic usage and setup for the project **munki.dev**.

---

# Purpose

Setting up and maintaining a web server can be a pretty complex job. Apache is great at actually serving files but the initial setup can be tedious. Thanks to the many resources that are available on the internet this can become less tedious. Which brings me to the true purpose of the post...a way to setup a web server so I can test software patches using Munki.

In case you are unaware, Munki is a popular way to manage software installs on Mac OSX created by Greg Neagle. Learning Munki can be a time consuming process due to the many layers of the management system. One of the more important layers is the munki_repo, which is what this project is dedicated at helping with. This will allow you to setup a development environment which is self-contained on your administrative machine. Once the initial setup has been made you will be able to test changes locally without the need for a second machine.  
_Disclaimer_: this vagrant box is not designed for usage in production.

# Required software

To use this project you will need to make sure you have the following software installed on your machine. All of these products can be obtained for free from the links provided. Below the prerequisites, each of the individual pieces of software have a short description explaining what they do. If you have some or any experience with the software needed for this you will likely want to skip past to the [Installation](./#installation).

## Software prerequisites for munki.dev

* Vagrant  http://www.vagrantup.com
* VirtualBox  https://www.virtualbox.org
* Git  http://sourceforge.net/projects/git-osx-installer/
* Munkitools https://github.com/munki/munki/releases  


### Vagrant
This is the backbone of this project. Vagrant's job is to interface directly with Virtualbox to create the virtual machine, download a ubuntu box, configure the box with puppet (plus other magic), and finally make any final changes needed for the munki.dev environment to work as intended. If this is the first project that are using Vagrant let me go ahead and say do not freak out. You do not actually have to know how to use Vagrant to take advantage of this project.

### Virtualbox
A virtualization product created by Oracle that is free to use. At the time of this writing, I am using version 4.3.8, though munki.dev and Vagrant should not have issues with other versions so long as no incompatibilities arise from future releases of the software.

### Git
Git is a way to store files and the changes that go along with those files in a logical manner. For this project, Git is the tool that will be used to download munki.dev and potentially a test munki_repo from from GitHub.
If you would like to learn more, I recommend reading this [Git Basics](http://git-scm.com/book/en/Getting-Started-Git-Basics) page.

### Munkitools
This is the client software needed for Munki to work on Macintosh Clients created by Greg Neagle. This technically is not a requirement for the administrative machine but will make your life easier when making changes to the munki_repo. For that reason alone it is strongly recommended. Any clients that you wish to connect to this local webshare will require munkitools to be installed.

# Installation
Installing is quite straight forward once you have the required software. Simply issue the following commands in Terminal. You will want to ``cd`` to a directory of your choosing. I will pick ``~/src/mine``. This will download the project from github.

```bash
mkdir -p ~/src/mine/
cd ~/src/mine/
git clone https://github.com/clburlison/munki.dev.git munki.dev
cd munki.dev
```

This will pull down all the necessary files from Github.

## Adding the hostname
One change you will want to make is adding munki.dev to your ``/etc/hosts`` file. This allows you to connect to the web share as munki.dev instead of the IP address (default 192.168.56.150).

```bash
sudo nano /etc/hosts
```

Add the following line to the bottom of your file.

```bash
192.168.56.150  munki.dev
```

Save with Control + X.

**Note**: at this current time there a known bug that prevents usage of the hostname from working when using an alias folder, aka Option 2 of the ``bootstrap.sh``. Until this is fixed, please use the IP address for testing purposes instead of the hostname. Follow the issue [here](https://github.com/clburlison/munki.dev/issues/1).

## munki_repo Modifications
Make these changes in the ``bootstrap.sh`` file.

You can point this virtual machine to a munki_repo that exists on your local admin machine. This means theoretically you could have a complete copy of your production munki_repo on your localhost or an external hard drive. This would allow you to point to that folder and start testing/development immediately.

This will default to downloading a the testing munki_repo since this will allow new users to get started with the least amount of work. To get the virtual machine started run the following command.

```bash
./bootstrap
```

# Client Settings
At this point, the munki_repo should be up and running. You will want to setup a client computer to connect to the munki_repo. To do this you will need to run the following command on a client computer.

```bash
sudo defaults write /Library/Preferences/ManagedInstalls SoftwareRepoURL "http://192.168.56.150/munki_repo"
sudo defaults write /Library/Preferences/ManagedInstalls ClientIdentifier testing
```

Now you should ready to test away. Open up ``/Applications/Managed Software Center.app`` if you are testing Munkitools v2 or ``/Applications/Utilities/Managed Software Update.app`` if you are testing Munkitools v1.

# Ending notes
If you have any problems please create an [Issue](https://github.com/clburlison/munki.dev/issues) on Github. Let me know what you think on Twitter, Email, etc.

Also, go check out [MunkiAdmin](https://github.com/hjuutilainen/munkiadmin) for a GUI to modify your munki_repo. Another great resource is [Mandrill](https://github.com/wollardj/Mandrill), a web front end for managing you munki_repo. Lastly, check out the [Getting Started with Munki](https://github.com/munki/munki/wiki) guide if you have any questions about munki.  
