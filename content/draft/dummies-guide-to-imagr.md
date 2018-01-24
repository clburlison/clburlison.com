---
title: "Dummies Guide to Imagr (w/ Videos)"
draft: true
modified:
tags:
  - imaging
  - imagr
  - ubuntu
  - docker
excerpt: Setup a fully functional Imagr server with netboot, reporting, smb, and web share on Ubuntu.
keywords: [osx, imagr, imaging, OS X, Mac, ubuntu]
---

<!-- toc -->

# Introduction
This is the zero to hero walkthrough on setting up Imagr using all the hottest technologies available. With the added bonus of running on Linux (all of you OS X Server haters can rejoice). I will be using Ubuntu 14.04 in a virtual machine however since most of the setup is using Docker so any distro should be compatible.

Before I get too far - Imagr is a python application that can restore a disk image, install packages, and run scripts all from a NetInstall environment. All of that said many community members are pushed away or confused by some of the requirements so hopefully this guide helps clear up some of the confusion.

The following technologies will be used:

* [Docker](https://www.docker.com/)
* [AutoNBI](https://bitbucket.org/bruienne/autonbi)
* [BSDPy](https://bitbucket.org/bruienne/bsdpy)
* [Redis](http://redis.io/)
* [Imagr](https://github.com/grahamgilbert/imagr)
* [Imagr Server](https://github.com/grahamgilbert/imagr_server)


# Server Setup
Prior to even downloading Imagr we want to setup the server requirements. I will be making the assumption that you want to run all services on a single box. In production, depending on load, it might be required to separate services or add additional hardware to meet your ideal performance. The only step I will not be detailing is installing Ubuntu and creating your admin account. If however you are truly lost the following [video](https://www.youtube.com/watch?v=klntfV5ZoOI) should get you pointed in the right direction. The only differing information I would say is download the 64 bit version and don't install any services at initial install, they can be installed later.

# Installing Docker
To reduce the time of setup, many of these services we will be using Docker. This allows us to startup complex apps easily and reliable. Log into your docker host using ssh.

VIDEO HERE

Update your system:

{% highlight bash %}

sudo apt-get update
sudo apt-get upgrade

{% endhighlight %}

Install wget:

{% highlight bash %}

sudo apt-get install wget

{% endhighlight %}

Now install Docker:

{% highlight bash %}

wget -qO- https://get.docker.com/ | sh

{% endhighlight %}

Make sure any type your password when prompted.


## Setup Docker
I will be "borrowing" [Graham's setup](http://grahamgilbert.com/blog/2015/04/22/getting-started-with-bsdpy-on-docker/) on using Docker. This make it easier to update containers in the future along with debugging when issues occur. We will store our permanent data at ``/usr/local/docker``.

VIDEO HERE

{% highlight bash %}

sudo -i
mkdir -p /usr/local/docker/{imagr-postgres,imagr,nbi}
chmod -R 777 /usr/local/docker/{imagr,nbi}

{% endhighlight %}

Now we will create a script that starts all of our Docker containers.

{% highlight bash %}

nano /usr/local/docker/startup.sh

{% endhighlight %}



**Git clone Imagr web and samba from Github.**
**the imagr-web needs to include the nbi dir from https://github.com/macadmins/netboot-httpd**
**Add redis to the docker container**



Paste the following code into your ``startup.sh`` and save.

{% highlight bash %}

#!/bin/bash
IP=`ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`
echo $IP

# Pull new images
cd /usr/local/docker/docker-imagr
docker build -t web .

docker pull clburlison/smb-protected:imagr_bsdpy
docker pull grahamgilbert/imagr-server
docker pull grahamgilbert/postgres

# Stop and delete all existing containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
sleep 5

# Start all containers
docker run -d \
  --restart="always" \
  --name web \
  -v /usr/local/docker/imagr:/repo \
  -p 80:80 \
  web

docker run -d \
  --restart="always" \
  --name smb \
  -v /usr/local/docker/imagr:/imagr \
  -v /usr/local/docker/nbi:/nbi \
  -p 445:445 \
  clburlison/smb-protected:imagr_bsdpy

docker run -d \
  --name="postgres-imagr" \
  -v /usr/local/docker/imagr-postgres:/var/lib/postgresql/data \
  -e DB_NAME=imagr \
  -e DB_USER=admin \
  -e DB_PASS="database_password_SuperSecret" \
  --restart="always" \
  grahamgilbert/postgres

docker run -d \
  --name="imagr-report"\
  -p 8000:8000 \
  --link postgres-imagr:db \
  -e ADMIN_PASS="imagr" \
  -e DB_NAME=imagr \
  -e DB_USER=admin \
  -e DB_PASS=database_password_SuperSecret \
  -e DOCKER_IMAGR_TZ="America/Chicago" \
  -e DOCKER_IMAGR_LANG="en_US" \
  -e DOCKER_IMAGR_DISPLAY_NAME="Imagr" \
  grahamgilbert/imagr-server

docker run -d \
  -p 0.0.0.0:69:69/udp \
  -v /usr/local/docker/nbi:/nbi \
  --name tftpd \
  --restart=always \
  macadmins/tftpd

docker run -d \
  -p 0.0.0.0:67:67/udp \
  -v /usr/local/docker/nbi:/nbi \
  -e BSDPY_IFACE=eth0 \
  -e BSDPY_NBI_URL=http://$IP \
  -e BSDPY_IP=$IP \
  --name bsdpy \
  --restart=always \
  bruienne/bsdpy:1.0  

{% endhighlight %}

The above script creates six, essentially disposable, docker containers:

* web - is a Nginx container on port 80 that will be used to distribute images, packages, and the Imagr configuration file to clients.
* smb-protected - is a samba file share that has a single user for uploading files to the web share.
* postgres-imagr - is a database for the Imagr reporting server.
* imagr-report - is the Imagr server running on port 8000 that stores POST data messages from clients.
* tftpd, bsdpy - these containers are used for the core services of Netbooting

This biggest pro to this approach is that all that is required to backup this system is copying the ``/usr/local/docker`` directory and startup script. Disaster recovery then becomes restore directory and run your startup script.


# Setup Imagr



# Build NetInstall

# Upload NBI to server

re-run the startup script. This will give BSDPy a chance to locate the new NBI image.

# Configuing a workflow

# AutoDMG / createOSXinstallPKG

# Conclusion
If you have gotten this far congratulations.

---

Articles:  
[We Are Imagr (And So Can You)](https://osxdominion.wordpress.com/2015/05/12/we-are-imagr-and-so-can-you/),  
[Imagr Wiki](https://github.com/grahamgilbert/imagr/wiki/Getting-Started),  
[BSDpy Redis Caching](http://enterprisemac.bruienne.com/2015/06/03/bsdpy-redis-caching/),  
[Getting Started with BSDPy on Docker](http://grahamgilbert.com/blog/2015/04/22/getting-started-with-bsdpy-on-docker/)
[Bind multiple domains](https://www.digitalocean.com/community/questions/how-to-bind-multiple-domains-ports-80-and-443-to-docker-contained-applications)
