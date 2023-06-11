---
categories:
- tech
date: 2014-04-04T00:00:00Z
description: Setting up a puppetmaster on osx Mavericks.
keywords: puppet, mavericks, osx, install, puppetmaster
modified: 2014-05-22
aliases:
- /blog/2014/04/04/setting-up-a-puppetmaster-on-mavericks/
tags:
- puppet
- macos
title: Setting up a puppetmaster on Mavericks
---

For various reasons I decided to set up my puppetmaster on an OS X install of Mavericks instead of what I would consider the norm, being a linux distro. Here are the results. This documentation is strongly based on the article by Nate Walck on afp548.com.

---


{{% alert info %}}
**Notice:** I do not use these instructions any longer. The setup of a puppetmaster on OS X Server was just for testing purposes.
{{% /alert %}}

### Introduction to puppet
Puppet is a service that is normally ran in a client/server setup that helps manage and configure devices. Since I am an OS X administrator, this article will be coving the installation and configuration on an OS X platform. While many sysadmins will prefer server installation on a linux distro I simply did not want to mess with getting a Virtual Machine approved in my environment. Below are the steps that I took to set up a puppetmaster on an OS X Mavericks install.  

### Pre-steps
Setting up dns, creating a CNAME record, verifying dns records, etc. Aka all the things I should have done but did not. I will go ahead and mention now that if you are doing this for production taking a moment to do this correctly the first time will save you hours of headache down the road. Since I do not have control over network settings at work, I skipped these steps and decided to use the server hostnames in my case. Please refer to the [article](http://www.afp548.com/2013/02/26/setting-up-a-basic-3-1-x-puppet-master-on-os-x-10-8/) by Nate if you want to do things the approved way.

### Install the software
Next, we must install Puppet on our master.  The Reference Manual has a section specifically for OS X regarding the puppet install. For Mavericks, you will want at least **Puppet version 3.2.X** or higher. You will also want to install **Facter, and Hiera**.

Each of these pieces of software can be obtained from [here](http://downloads.puppetlabs.com/mac/). (After downloading, you will want to install each of the three packages. A control click might be needed if you have Gatekeeper enabled.)

The puppet service account should be created automatically. It is good practice to double checking this by running. Check for Puppet user:
```bashid puppet```  

The command above should list the puppet user’s uid, gid and groups.  If you get ‘id: puppet: no such user’ instead, then you will need to create the user manually.  Create the service account and puppet group using the following two commands (As per the Reference Manual):

```bash
sudo puppet resource group puppet ensure=present
sudo puppet resource user puppet ensure=present gid=puppet shell='/sbin/nologin'
```

You also do not want this puppet user to appear at the login window (since it is a service account), so run the following command to hide it (or you can set it via MCX, Profile, etc):

```bash
sudo defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -boolean YES
```

### Settings up our puppetmaster
Now we will make changes to the default puppet configuration for our server. This can be done with **sudo nano /etc/puppet/puppet.conf** then enter the following text. Save with "Ctrl + X"

```bash
# Default Puppet Settings
server = server_host_name_here # default is 'puppet'
report = true
pluginsync = true
certname = server.company.com (The FQDN of the machine that is running puppet)
```

Also, since pluginsync is enabled by default, create the modules folder and make sure the puppet user owns it. We can create our manifests directory while we are at it. The latter command will create the default *site.pp* file:

```bash
sudo mkdir /etc/puppet/modules
sudo chown puppet /etc/puppet/modules
sudo mkdir /etc/puppet/manifests
sudo touch /etc/puppet/manifests/site.pp
sudo chown puppet /etc/puppet/manifests/site.pp
```

Lastly, run puppet as a master for the first time using the following command:

```bash
sudo puppet master --debug --verbose --no-daemonize
```

Because we are running puppet as a master, it will generate a CA (Certificate Authority) so it can securely talk to clients and create other folder structure that the master needs to function.

#### LaunchDaemon setup
Puppet is now fully configured as a basic master, but we are missing one key component: a service to make sure that Puppet is running.  Since we are setting this up on OS X, we will use a launchd job.  The Puppet documentation on setting up the launchd item can be found [here](http://docs.puppetlabs.com/guides/installation.html#with-launchd).  In this documentation, Puppet Labs has provided us with a launchd item that can take care of starting our puppet master for us.  You can view the original plist [here](http://docs.puppetlabs.com/guides/installation.html#mac-os-x) or copy it from the box.


```bash
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>EnvironmentVariables</key>
        <dict>
                <key>PATH</key>
                <string>/sbin:/usr/sbin:/bin:/usr/bin</string>
                <key>RUBYLIB</key>
                <string>/usr/lib/ruby/site_ruby/1.8/</string>
        </dict>
        <key>Label</key>
        <string>com.puppetlabs.puppetmaster</string>
        <key>OnDemand</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
                <string>/usr/bin/puppet</string>
                <string>master</string>
                <string>--verbose</string>
                <string>--no-daemonize</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>ServiceDescription</key>
        <string>Puppetmaster Daemon</string>
        <key>ServiceIPC</key>
        <false/>
        <key>StandardErrorPath</key>
        <string>/var/log/puppet/puppetmaster.err</string>
        <key>StandardOutPath</key>
        <string>/var/log/puppet/puppetmaster.out</string>
</dict>
</plist>
```

Save the contents of this file into **/Library/LaunchDaemons/com.puppetlabs.puppetmaster.plist** . Also, make sure the permissions are correct on the file:

```bash
sudo chown root:wheel /Library/LaunchDaemons/com.puppetlabs.puppetmaster.plist  
sudo chmod 644 /Library/LaunchDaemons/com.puppetlabs.puppetmaster.plist
```

Lastly, load the launchd using launchctl:

```bash
sudo launchctl load -w /Library/LaunchDaemons/com.puppetlabs.puppetmaster.plist
```

We should now have a fully functional puppetmaster running on OS X Mavericks. Note that this is running with the default WEBrick server that comes with puppet. While this should be okay for development it is not suitable for production. Methods for scaling Puppet can be found on the [Scaling Puppet](http://docs.puppetlabs.com/guides/scaling.html) page.

More information about puppet will be published in the future. I am going through beta testing with Puppet at the time of this writing.

---

Articles: [afp548.com](http://www.afp548.com/2013/02/26/setting-up-a-basic-3-1-x-puppet-master-on-os-x-10-8/), [Puppetlabs Offical Documentation](http://docs.puppetlabs.com/guides/installation.html#mac-os-x)
