---
categories:
- tech
date: 2017-03-21T10:21:13-05:00
draft: false
modified: null
tags:
- chef
- ubuntu
title: Chef Grocery Delivery Setup
toc: false
---

# Introduction

[Grocery Delivery](https://github.com/facebook/grocery-delivery) (GD) is a ruby gem that helps keep cookbooks, roles, and data bags in sync between a source control repo and your chef server. This allows administrators to keep their entire chef code in source control with continuous integration, peer reviews, and any other checks they can think of. Once the code has been checked and merged into the `master` branch the `grocery-delivery` binary takes the place of `knife upload`. This can be ran on a cron job, or event based using web-hooks to verify that the latest code is on your chef server. This also means your server is safer from someone accidentally pushing breaking code to production.

So lets get started on setting up GD using a ubuntu 16.04 host that already has the chef server configured. You could technically run this on a separate box but keeping it on the chef server is easier to troubleshoot/maintain in my opinion.

# Requirements

In case it wasn't clear your chef server needs to already be setup, if not go to chef docs on [installing the server](https://docs.chef.io/install_server.html). Plus:

* access to a user key
* access to a validator key
* ssh access to the chef server
* your chef repo in source control

# Setup

If you want a sample chef repo to fork I recommend forking my example repo:

https://github.com/clburlison/example-chef-repo

Run the following commands as root:

    sudo su

Install the following packages so we can build dependencies for GD:

    apt-get update
    apt-get upgrade
    apt-get install cmake pkg-config

Install the GD gem into the chef server ruby path. The path is not a strict requirement but it is nice to have locked version of ruby:

    /opt/opscode/embedded/bin/gem install grocery_delivery

Create the config file for GD using the default path.

{{% alert info %}}
NOTE: you will need to change the git `repo_url` and potentially the `cookbook_paths`, `role_path`, and `databag_path`.
{{% /alert %}}


    vi /etc/gd-config.rb

Paste the following:

    stdout          true
    repo_url        'git@github.com:clburlison/chef-repo.git'
    reponame        'cpe'
    cookbook_paths  ['cookbooks']
    role_path       'roles'
    databag_path    'data_bags'
    rev_checkpoint  'gd_revision'
    knife_config    '/root/.chef/knife.rb'
    knife_bin       '/opt/opscode/bin/knife'
    vcs_type        'git'
    berks           false
    berks_bin       '/opt/opscode/embedded/bin/berks'

Create a hidden chef folder for the root user:

    mkdir /root/.chef

Create the knife config:

    vi /root/.chef/knife.rb

Paste the following:

{{% alert info %}}
NOTE: make sure and update the `node_name`, `client_key`, `validation_client_name`, and `chef_server_url` keys
{{% /alert %}}

    log_level               :info
    log_location            STDOUT
    node_name               'gd'
    client_key              'gd.pem'
    validation_client_name  'clburlison-validator'
    validation_key          'clburlison-validator.pem'
    chef_server_url         'https://chef.example.com/organizations/clburlison'
    cookbook_path [
      '/var/chef/grocery_delivery_work/cpe/cookbooks/',
    ]

Copy the copy the two pem files (`gd.pem` and `clburlison-validator.pem` from my example) from your admin workstation to the chef server under `/root/.chef`.

# SSH deploy key

The following can be ran on your workstation or chef server.

Create a ssh deploy key so the Chef server can access your chef git repo:

    ssh-keygen -t rsa -b 4096 -C "gd-deploy@example.com"

Change the save location if you wish. Full output below:

```bash
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/clburlison/.ssh/id_rsa): /Users/clburlison/.ssh/gd_deploy
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/clburlison/.ssh/gd_deploy.
Your public key has been saved in /Users/clburlison/.ssh/gd_deploy.pub.
The key fingerprint is:
SHA256:4OIJ40Lncc7cwfAGY1UoBtutBDpKLoYwlOQDL8o9GkE chef-admin@clburlison.com
The key's randomart image is:
+---[RSA 4096]----+
|oE.o.  .o.       |
|=o. +oo.         |
|+B...Bo.         |
|Oo= o.B.         |
|=*o=.o.=S        |
|+.=+Boo .        |
|....o+ .         |
| .               |
|                 |
+----[SHA256]-----+
```

Create the .ssh directory for the root user if it doesn't exist:

    mkdir -p /root/.ssh/

Copy the `gd_deploy` private key to your chef server under `/root/.ssh/id_rsa`. Make sure the file permissions are correct:

    chmod 0600 /root/.ssh/id_rsa

Then add the key to your ssh agent:

    eval "$(ssh-agent -s)"
    ssh-add /root/.ssh/id_rsa

Now copy the `gd_deploy.pub` public key to your chef repo deploy key section. For Github the url will be:

https://github.com/USERNAME/example-chef-repo/settings/keys

{{% alert info %}}
NOTE: that this key should *not* have write access to the git repo.
{{% /alert %}}

Make a test connection to github to add the RSA fingerprint.

    ssh -T git@github.com

You should get the following as output:

```bash
root@chef:~$ ssh -T git@github.com
The authenticity of host 'github.com (192.30.253.113)' can't be established.
RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,192.30.253.113' (RSA) to the list of known hosts.
Hi clburlison/example-chef-repo! You've successfully authenticated, but GitHub does not provide shell access.
```

# Run GD

Great now if we did everything correctly the following command should add our code to the chef server:

    /opt/opscode/embedded/bin/grocery-delivery -vv


If all works you'll likely want to run this script on a cron job without the verbose flag:

    vi /etc/cron.d/gd

Paste the following to run every 5 minutes. Obviously modify to taste:

    SHELL=/bin/bash
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    */5 * * * * root /opt/opscode/embedded/bin/grocery-delivery

Cron hates me so lets be safe and force a reload.

    /etc/init.d/cron reload

If you are having cron issues add `&>> /tmp/gd.log` to the end of your command and reload to write debug info to a log file.


# Bonus

If you wish to delete all cookbooks run:

    knife cookbook bulk delete "/*"
