---
layout: post
title: "Setup Mandrill Ubuntu 14.04 - Part 2"
date: 2014-10-08T22:55:49-05:00
modified:
categories: munki ubuntu mandrill
excerpt: Install Mandrill 
comments: true
published: false
tags: []
image:
  feature:
  credit: 
  creditlink:
---

<section id="table-of-contents" class="toc">
  <header>
    <h3>Overview</h3>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->






#Intro


#The Install




##Installing Required Software

{% highlight bash %}

sudo apt-get install nginx npm # install npm just incase
sudo npm install pm2 -g --unsafe-perm # change from the wiki. the unsafe perm is needed to make sure it runs via root

{% endhighlight %}

Install MongoDB

``sudo apt-get install -y mongodb-org``
``sudo service mongod start``

``sudo chown -R _mandrill:munki munki_repo/``

do not use nginx mandrill config file. 


http://munki01:3001


---

Articles:  
[Mandrill Wiki](https://github.com/wollardj/Mandrill/wiki)
