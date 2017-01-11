---
categories:
- personal
- tech
comments: true
date: 2014-09-09T00:00:00Z
excerpt: A quick update regarding a few of the things I have been up to the last few
  weeks.
modified: 2015-04-06
published: true
aliases:
- /blog/2014/09/09/java-coreos-docker-and-more/
title: Java, CoreOS, Docker, & More
url: "java-coreos-docker-and-more/"
---

# Quick Update
Firstly, the new semester has started up and my previous goal of one post per month might become a little more difficult to keep up with. For that reason I will be making this post mostly personal opinions and ideas rather than technical writing.

It has certainly been a busy start to this school year getting multiple labs ready, updating computers, installing new software, and plenty of other daily tasks that are quite difficult to stay on top of. Hopefully, I can better prepare next summer...this year was quite different.

## Java
I have been in college for a grand total of four (4) years now. Going part time has given me an amazing opportunity to work and obtain real-world experience but has also delayed me from getting into my upper level courses and even now I am just now starting to take courses related to the IT field.

Experience with the command line and scripting at work has prepared farther than I could have imagined. The first class I am taking regarding my degree plan is "Object Oriented Programming" using Java (INSY 3300). All the code that I have seen while looking through open source projects has been quite beneficial since the ideas of variables, comments, tabbing/spacing, and even to an extent the idea of OS X packages has some relationship to Java code. I am still in the introduction of Java but it is quite fun to finally get the time to learn a programming language.

## CoreOS
CoreOS is pretty new to me but the whole idea behind it is quite fascinating.

> CoreOS is a new Linux distribution that has been rearchitected to provide features needed to run modern infrastructure stacks. The strategies and architectures that influence CoreOS allow companies like Google, Facebook and Twitter to run their services at scale with high resilience. --[CoreOS](https://coreos.com/)

Think really really tiny virtual machine that uses linux, has the ability to automatically update, is heavily scalable, and automatable. This is still in the learning mode for me, much like Java, and I have not had a chance to dig very deep into the usability of CoreOS. If you wish to play around with CoreOS I highly recommend using Digital Ocean since the setup is quite painless and allows you to test things on a cloud platform. Below is a link if you want to sign up and receive $10 free credit.  

[Click here to receive $10 credit with Digital Ocean](https://www.digitalocean.com/?refcode=b50b2cfc8144)

{{% alert info %}}
**Note:** The referral above also earns me credit.
{{% /alert %}}

## Docker
Docker is related to CoreOS but only since Core heavily relies on the foundation of [Docker](https://www.docker.com/). However, Docker does not rely on CoreOS and can be ran on any operating system. Without using the terminology created by Docker it is kind of hard to understand what Docker actually does. In the simplest terms, Docker is ran at the lowest level of the computer interacting with the operating system.

For example, to setup a simple website, instead of directly modifying the apache service to serve the website. Docker will interact with apache for you, almost like sandboxing. Docker will then manage apache which will serve the web files for the website like normal.

So you have a slight idea about Docker, but what does it do? It will allow you quickly setup services automatically with minimal to no manual labor. Below are a few cool Docker projects hosted on Github to get ideas flowing.

* [overshard/docker-teamspeak](https://github.com/overshard/docker-teamspeak)
* [macadmins/sal](https://github.com/macadmins/sal)
* [macadmins/munkireport-php](https://github.com/macadmins/munkireport-php)
* [arcus-io/docker-puppetmaster](https://github.com/arcus-io/docker-puppetmaster)

Docker is _not_ another application to virtualize operating systems. It allows you to have "containers" that maintain a certain service and can easily be modified on one server or 1,000's of servers.

## More
Currently, I have a running list of topics I would like to share using this blog. It is simply taking much longer for me to get around to them than I anticipated. There are so many awesome technologies being developed everyday. I am just lucky I get to experience it first hand.

Let me know what you think in the comments below!

---

Resources:  
[Digital Ocean Supports CoreOS](https://coreos.com/blog/digital-ocean-supports-coreos/)  
[CoreOS Docs](https://coreos.com/docs/)  
[Docker Docs](http://docs.docker.com/)
