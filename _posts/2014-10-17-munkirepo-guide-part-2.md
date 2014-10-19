---
layout: post
title: "Setup Mandrill on Ubuntu 14.04 - Part 2"
date: 2014-10-19T22:55:49-05:00
modified:
categories: munki ubuntu mandrill
excerpt: Install Mandrill on our munki server. This web front end gives the munkiadmin a flexible and powerful way to update manifests.
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
This is Part 2 of a series on setting up a munki server on Ubuntu 14.04. Read [Part 1 here](/blog/2014/10/06/munkirepo-guide-part-1/). This section goes over setting up [Mandrill](https://github.com/wollardj/Mandrill) so we can edit our repo metadata files, modify manifests, and assign new software to our fleet using a web browser. 

A brief description of Mandrill.

  > Multi-user web front-end for managing a Munki repository. If you're here because of MailChimp, my apologies but this isn't the Mandrill you're looking for. /wavehand  
  > 
  > Mandrill is a NodeJS web application written using the Meteor framework. It supports one database engine: MongoDB. There are no plans to support other engines, but fear not, mandrillctl will install and secure MongoDB for you. If you already have MongoDB running on your server via homebrew, you should probably remove that installation first, or use an alternate server.  
  > --Joe Wollard


#The Install
Lucky for us Joe, the developer, has excellent documentation for installation on Ubuntu. Unfortunately, the documentation is for an older version of Ubuntu and some of the commands need modification to work with 14.04 and this series. Instead of redirecting you back and forth between his guide and this, I decided to include all the commands required below without the descriptions. For more information on what/why you are doing something please reference the wiki [here](https://github.com/wollardj/Mandrill/wiki).

##Creating Users & Groups

{% highlight bash %}
sudo addgroup --system munki
sudo adduser --system _mandrill --ingroup munki --force-badname
{% endhighlight %}

_Note:_ You should receive an error from creating the 'munki' group if you went through [Part 1](/blog/2014/10/06/munkirepo-guide-part-1/). This is fine move along.

##Install build tools
{% highlight bash %}
sudo apt-get install git curl build-essential
{% endhighlight %}

##Install NodeJS

_Extracting the tarbar failed in my testing..._
``sudo apt-get install nodejs``  


{% highlight bash %}
curl -O http://nodejs.org/dist/v0.10.26/node-v0.10.26-linux-x64.tar.gz
sudo tar --strip-components 1 -C /usr/local -zxf node-v0.10.26-linux-x64.tar.gz
rm node-v0.10.26-linux-x64.tar.gz
{% endhighlight %}

##Nginx install

_This might be an extra step that is not needed._
``sudo apt-get install npm``


{% highlight bash %}
sudo apt-get install nginx
sudo npm install pm2 -g --unsafe-perm

# install startup scripts to make sure pm2 and all its daemons
# respawn when the server reboots.
sudo pm2 startup ubuntu
{% endhighlight %}


##Configuring pm2

Be sure to change ROOT_URL and PORT to values appropriate for your environment! If you're running a MongoDB instance on another server, or if your MongoDB instance requires authentication, you should change MONGO_URL as well.

One thing you should not change is instances as Mandrill is not currently aware of other instances of itself and will needlessly consume resources.  

``sudo nano /usr/local/etc/mandrilld.json``


{% highlight bash%}

[{
    "name": "mandrilld",
    "script": "/usr/local/Mandrill/main.js",
    "env": {
        "ROOT_URL": "http://192.168.20.133:3001",
        "PORT": "3001",
        "MONGO_URL": "mongodb://localhost:27017/Mandrill",
        "MANDRILL_MODE": "production"
    },
    "instances": "1",
    "error_file": "/var/log/mandrill/mandrill-err.log",
    "out_file": "/var/log/mandrill/mandrill.log",
    "pid_file": "/var/run/mandrill.pid"
}]
{% endhighlight %}

The log directory must exist before you start mandrilld for the first time.

{% highlight bash%}
sudo mkdir /var/log/mandrill
{% endhighlight %}

##Configuring Nginx

``sudo nano /etc/nginx/sites-enabled/mandrill``

{% highlight bash%}
server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    # Change this to your server's FQDN or ip address
    server_name localhost;

    location / {
      # If you configured pm2 to run Mandrill on another port,
      # use that same port here. Leave 'localhost' though.
        proxy_pass http://localhost:3001/;
    }

    location /mandrill {
        proxy_pass http://localhost:3001/;
    }
}
{% endhighlight %}

nginx -c /etc/nginx/nginx.conf -t


Now lets start nginx.  
``sudo /etc/init.d/nginx start``

##Install Meteor

{% highlight bash%}
# First, install meteor
curl https://install.meteor.com | /bin/sh

# next, install meteorite
sudo npm install -g meteorite
{% endhighlight %}

##Install MongoDB

{% highlight bash%}
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv 7F0CEB10

echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' \
    | sudo tee /etc/apt/sources.list.d/mongodb.list

sudo apt-get update
sudo apt-get install mongodb-10gen
{% endhighlight %}

##Installing Mandrill

{% highlight bash%}
git clone https://github.com/wollardj/Mandrill.git

# If you want the latest source code, you're done. However,
# I suggest sticking with the latest release...
cd Mandrill
git checkout tags/`git tag -l | tail -n 1`

sudo mrt bundle Mandrill.tar.gz

sudo mkdir /usr/local/Mandrill
sudo tar --strip-components 1 -C /usr/local/Mandrill -zxf Mandrill.tar.gz

{% endhighlight %}

Now lets manually start all of the services Mandrill needs so we can check if it works.

{% highlight bash%}
sudo pm2 start /usr/local/etc/mandrilld.json
sudo service mongod start
sudo service nginx start
{% endhighlight %}



---
 

``sudo chown -R _mandrill:munki munki_repo/``

do not use nginx mandrill config file. 


http://munki01:3001


---

Articles:  
[Mandrill Wiki](https://github.com/wollardj/Mandrill/wiki)
