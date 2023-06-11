---
categories:
- guides
- tech
date: 2014-10-02T00:00:00Z
excerpt: A setup guide for Reposado and Margarita using Apache on Ubuntu 14.04 with
  notes on securing Margarita.
modified: 2015-11-26
aliases:
- /blog/2014/10/02/reposado-guide/
tags:
- reposado
- ubuntu
title: Setup Reposado + Margarita on Ubuntu 14.04
url: /reposado-guide/
---

<!-- toc -->

# Intro
Why on earth are you creating another guide? Why not use Puppet or Docker? Well the short answer is I could not find anything that covered all the criteria that I needed. I might go back later and puppetize this or use docker but needed a working solution. Plus the first step to automating something is to document how to do it manually, so below is the process to get Reposado and Margarita with Authorization (optional) setup on a clean install of Ubuntu 14.04 using Apache. The only pre-requirement is having an administrator account on the Ubuntu box already setup.


{{% alert info %}}
**Note:** I have added <a href="./#addendum-4-using-nginx">Addendum 4</a> if you would like to serve files using nginx instead of apache. In my testing, it has been much faster at serving html requests. Also, a little easier to setup the redirect rules.
{{% /alert %}}


# The software
If you have not heard of [reposado](https://github.com/wdas/reposado). It is a set of tools that replicate the key functionality of Mac OS X Server's Software Update Service.

> * It doesn’t need to run on a Mac.
> * It can provide updates to any OS X version, whereas Apple’s Mac OS X server can only provide updates (not strictly true, but not easily!) to its current version or below e.g. your OS X 10.6 server can only provide to OS X 10.6 or below – it can’t cater for your OS X 10.7 or OS X 10.8 clients. Reposado doesn’t have this pitfall, it caters for all!  
>   -- [Jerome](http://jerome.co.za/) _orginal article has been removed_

Plus, with reposado you can create multiple releases aka Production and Testing catalogs.

[Margarita](https://github.com/jessepeterson/margarita) is an add-on to reposado that gives you a web GUI!

>Margarita is a web interface to reposado the Apple Software Update replication and catalog management tool. While the reposado command line administration tools work great for folks who are comfortable in that environment something a little more accesible might be desired.
>
>   -- jessepeterson

---

# The Install

As a matter of good practice, we are going to make sure our Ubuntu server is fully patched before we start. Then we will install _mod_wsgi, git, apache tools, python setuptools, curl, pip, and apache2_. Since Margarita runs on _Flask_, we will need to install that as well.


## Installing Required Software

```bash

sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install apache2-utils libapache2-mod-wsgi git python-setuptools python curl python-pip apache2
sudo easy_install flask

```

You can install Reposado and Margarita anywhere you would like, but I am going to use _/usr/local/asus_ (which stands for Apple Software Update Server) just to keep things organized. The following commands will create the reposado, margarita, www and meta directories within _/usr/local/asus_. The _www_ directory will be the location from which reposado’s catalogs and downloads will be served, and you can think of the _meta_ directory as reposado’s work area. A link to the asus directory will also be created in your home directory for faster access.

### Clone the code and setup the directories:
```bash

sudo mkdir /usr/local/asus
ln -s /usr/local/asus/ ~/
cd /usr/local/asus
sudo chown $USER:$USER .
git clone https://github.com/wdas/reposado.git
git clone https://github.com/jessepeterson/margarita.git
mkdir www meta

```

You will notice that I had you chown the directory so that you own it. This is not required, but it eliminates a bunch of extra ‘sudo’ calls for the rest of the steps.

Next we will need to configure Reposado and let it sync, and I am going to do so without replication. If you want replication so your clients will download updates from your server instead of Apple’s, you will need to enter your host’s FQDN for the answer to the last prompt, e.g. [http://su.example.com]()

### Configure Reposado:

```bash

./reposado/code/repoutil --configure
Filesystem path to store replicated catalogs and updates [None]: /usr/local/asus/www
Filesystem path to store Reposado metadata [None]: /usr/local/asus/meta
Base URL for your local Software Update Service
(Example: http://su.your.org -- leave empty if you are not replicating updates) [None]:


./reposado/code/repo_sync # This will take a while

```


{{% alert info %}}
**Note:** The repo_sync command will download Apple catalogs + updates (if enabled). Grab a coffee, this could be upwards of 170GB. Time obviously depends on connection speed.
{{% /alert %}}


You now have Reposado fully installed and configured! Now we need to serve those files over http so clients can do something with the downloads.

Lets move on to setting up your Margarita front-end. We will start things off by borrowing from Jesse’s instructions, just to make sure things have been properly installed. Since Margarita and Reposado are both written in Python and share common tasks, it only makes sense that code is reused where possible; that is exactly what Jesse has done. So in order for Margarita to use Reposado’s code, it needs to be able to find it. We will need to create a few symbolic links to do this.

### Let Margarita access Reposado’s shared resources:
```bash

ln -s /usr/local/asus/reposado/code/reposadolib margarita/reposadolib
ln -s /usr/local/asus/reposado/code/preferences.plist margarita/preferences.plist

```

At this point, Margarita should be completely installed and configured. To test, run the following command and then point your favorite browser to [http://example.com:8089]() (do not worry, port 8089 is just for this test). If all goes well, Margarita should load but without showing any updates. To see the updates, uncheck the “Hide commonly listed updates” button at the top of the page. If you still do not see any updates, you have encountered a problem and should look at the output in your terminal window to start troubleshooting.

**Testing Margarita:**
```bash

python margarita/margarita.py

```

## Setting up Apache
So far we have properly configured both Reposado and Margarita. Now all we want to do is make sure the web interface will automatically come back to life when the server is rebooted. We could write a custom service that uses Python to launch the margarita.py script as we have done in the above test, but we already have Apache running to serve the software updates, so why not use that to serve the Margarita web interface as well?

### Creating Our Very Own .wsgi Script
A .wsgi script gives mod_wsgi the information it needs to launch the python web app, but Margarita does not come with one. Fortunately, these files are pretty easy to make. Using your favorite text editor (*cough* nano *cough*), create the file _/usr/local/asus/margarita/margarita.wsgi_ with the following contents:

``sudo nano /usr/local/asus/margarita/margarita.wsgi``

```bash

import sys
EXTRA_DIR = "/usr/local/asus/margarita"
if EXTRA_DIR not in sys.path:
    sys.path.append(EXTRA_DIR)

from margarita import app as application

```


### Configuring Apache

Before we go about configuring Apache, we need to make sure it has the proper filesystem permissions.

```bash
sudo chown -R www-data:www-data /usr/local/asus
sudo chmod -R g+r /usr/local/asus
```

I have apache sharing the reposado files via port 8088 (the Apple default) and margarita on port 8089 (default). You should be able to copy and paste the following snippets of my apache config files, and see everything working properly.

Enable the mod_rewrite engine:  
``sudo a2enmod rewrite``

Lets initialize apache with the following command:  
 ``sudo service apache2 restart``

Now we need to add ports 8088 and 8089 to apache's listening ports.  
``sudo nano /etc/apache2/ports.conf``

```html

# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 8088
Listen 8089

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>

```

Once done your files should look like the above.

**Now, lets get reposado and margarita configured with apache:**

``sudo nano /etc/apache2/sites-enabled/reposado.conf``

```html

<VirtualHost *:8088>
    ServerAdmin webmaster@localhost
    DocumentRoot /usr/local/asus/www

    Alias /content /usr/local/asus/www/content
    <Directory />
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>

    # Logging
    ErrorLog ${APACHE_LOG_DIR}/asus-error.log
    LogLevel warn
    CustomLog ${APACHE_LOG_DIR}/asus-access.log combined
</VirtualHost>

```


``sudo nano /etc/apache2/sites-enabled/margarita.conf``

```html

<VirtualHost *:8089>
    ServerAdmin webmaster@localhost
    DocumentRoot /usr/local/asus/www

    # Base cofiguration
    <Directory />
        Options FollowSymLinks
        AllowOverride None
    </Directory>

    # Margarita
    Alias /static /usr/local/asus/margarita/static
    WSGIDaemonProcess margarita home=/usr/local/asus/margarita user=www-data group=www-data threads=5
    WSGIScriptAlias / /usr/local/asus/margarita/margarita.wsgi
    <Directory />
        WSGIProcessGroup margarita
        WSGIApplicationGroup %{GLOBAL}
        Require all granted
    </Directory>

    # Logging
    ErrorLog ${APACHE_LOG_DIR}/asus-error.log
    LogLevel warn
    CustomLog ${APACHE_LOG_DIR}/asus-access.log combined
</VirtualHost>

```

### Rewrite Rules

To allow Apple Clients to use pretty configuration URLs like [http://su.example.com:8088]() lets enable Rewrite Rules for the www directory.

``nano /usr/local/asus/www/.htaccess``

```html

RewriteEngine On
Options FollowSymLinks
RewriteBase  /
RewriteCond %{HTTP_USER_AGENT} Darwin/8
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/index$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/9
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/10
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-leopard-snowleopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/11
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-lion-snowleopard-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/12
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/13
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/14
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/15
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/16
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog [L]

```

Now we need to make sure the web service has permissions to the file we will re-run the following commands.

```bash
sudo chown -R www-data:www-data /usr/local/asus
sudo chmod -R g+r /usr/local/asus
```

Lastly, restart apache for the changes to take place.  
``sudo service apache2 restart``

## Done.
Well, that is the plan anyway. If you are still having trouble getting things working, here are a few resources to get you started down the troubleshooting path:

* [https://github.com/jessepeterson/margarita]()
* [http://groups.google.com/group/reposado]()
* [https://github.com/wdas/reposado/wiki/_pages]()
* [http://flask.pocoo.org/docs/deploying/mod_wsgi/]()

---

# Addendum 1: Scheduling repo_sync
Out of the box, reposado will not run the repo_sync command without your direct invocation. If you want your new SUS server to look for any new updates released by Apple on its own, leaving you to simply approve them, you can setup a simple cron job. Since it is probably sane for most environments to simply run this script once per day, fire up a sudo nano session and…

``sudo nano /etc/cron.daily/repo_sync``

```bash
#!/bin/bash
/usr/local/asus/reposado/code/repo_sync
/bin/chgrp -R www-data /usr/local/asus/www
/bin/chmod -R g+rX /usr/local/asus/www
```

…and of course, make sure the script is executable with

``sudo chmod +x /etc/cron.daily/repo_sync``

For more information on creating a cron job [click here](https://www.digitalocean.com/community/tutorials/how-to-use-cron-to-automate-tasks-on-a-vps).  

# Addendum 2: Keeping Up To Date

Every once in a while, Apple will throw a curveball at Reposado which requires a code modification. When that happens, you can easily upgrade both Reposado and Margarita via the git command.

```bash
cd /usr/local/asus/reposado
git pull
cd /usr/local/asus/margarita
git pull
sudo apachectl restart
```

# Addendum 3: Securing Margarita

Margarita by default is open to everyone. To secure the site using basic http authentication make the following changes.

First, lets create a basic authentication user with the following.

```bash
htpasswd -c /usr/local/asus/users admin
# The following is output.enter a secure password!
New password: **********
Re-type new password: **********
Adding password for user admin
```

For security reasons make it so root is the only user that can edit the file.
```bash
sudo chown root.nogroup /usr/local/asus/users
sudo chmod 640 /usr/local/asus/users
```

Now modify the apache configuration file for Margarita. Add the following "Authentication" section in-between the "Margarita" and "logging" sections.  
``sudo nano /etc/apache2/sites-enabled/margarita.conf``

```bash

       <---Require all granted
    </Directory>

    # Authentication    
    <Location />
      AuthType Basic
      AuthName "Authentication Required"
      AuthUserFile "/usr/local/asus/users"
      Require valid-user
    </Location>

    # Logging
        ErrorLog ${APACHE_LOG_DIR}/asus-error.log
        LogLevel warn
--->

```

Modify permissions, one last time.

```bash
sudo chown -R www-data:www-data /usr/local/asus
sudo chmod -R g+r /usr/local/asus
```

Lastly, restart apache for the changes to take place.  
``sudo service apache2 restart``

# Addendum 4: Using nginx

Nginx offers a few benefits over using apache, with the key benefit being lighter. This results in faster transfers from the web server to clients. With that said, Nginx does not offer as wide of a selection of modules as Apache. For that reason, I am currently running Margarita over apache while serving reposado (Apple client updates) via nginx.


{{% alert info %}}
**Note:** This section should be used in replace of using the <code>/etc/apache2/sites-enabled/reposado.conf</code> file not in addition. Bad things will happen if you try to share the reposado downloaded updates via both apache and nginx.
{{% /alert %}}


Firstly, we must install nginx on our server so we can use it.

```bash
sudo apt-get -y install nginx
```


Now we need to modify our apache ports file so nginx has access our desired ports. You can pick the port yourself just make sure and be consistent when you modify your ``reposado.conf`` file. Remove both port 80 & 8088 from the file below.  
``sudo nano /etc/apache2/ports.conf``  

```html

# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

#Listen 80
#Listen 8088
Listen 8089

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>

```

Restart apache to free ports 80 and 8088 for nginx.   
``sudo service apache2 restart``

We need to setup nginx with the following config file. Modify your listening port to your preference.  

``sudo nano /etc/nginx/sites-enabled/reposado.conf``

```bash
server {
  listen 8088;
  server_name reposado01;
  root /usr/local/asus/www;
  autoindex off;
  ## 10.4.x - Tiger
  if ( $http_user_agent ~ "Darwin/8" ){
    rewrite ^/index(.*)\.sucatalog$ /content/catalogs/index$1.sucatalog last;
  }
  ## 10.5.x - Leopard
  if ( $http_user_agent ~ "Darwin/9" ){
    rewrite ^/index(.*)\.sucatalog$ /content/catalogs/others/index-leopard.merged-1$1.sucatalog last;
  }
  ## 10.6.x - Snow Leopard
  if ( $http_user_agent ~ "Darwin/10" ){
    rewrite ^/index(.*)\.sucatalog$ /content/catalogs/others/index-leopard-snowleopard.merged-1$1.sucatalog last;
  }
  ## 10.7.x - Lion
  if ( $http_user_agent ~ "Darwin/11" ){
    rewrite ^/index(.*)\.sucatalog$ /content/catalogs/others/index-lion-snowleopard-leopard.merged-1$1.sucatalog last;
  }
  ## 10.8.x - Mountain Lion
  if ( $http_user_agent ~ "Darwin/12" ){
    rewrite ^/index(.*)\.sucatalog$ /content/catalogs/others/index-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog last;
  }
  ## 10.9.x - Mavericks
  if ( $http_user_agent ~ "Darwin/13" ){
    rewrite ^/index(.*)\.sucatalog$ /content/catalogs/others/index-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog last;
  }
  ## 10.10.x - Yosemite
  if ( $http_user_agent ~ "Darwin/14" ){
    rewrite ^/index(.*)\.sucatalog$ /content/catalogs/others/index-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog last;
  }
  ## 10.11.x - El Capitan
  if ( $http_user_agent ~ "Darwin/15" ){
    rewrite ^/index(.*)\.sucatalog$ /content/catalogs/others/index-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog last;
  }

  ## 10.12.x - Sierra
  if ( $http_user_agent ~ "Darwin/16" ){
    rewrite ^/index(.*)\.sucatalog$
    /content/catalogs/others/index-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog last;
  }
}
```

Lastly, start the nginx service to start serving your files.  
``sudo /etc/init.d/nginx start``



---

# Credits
Need to truly thank both Joe Wollard & Jerome for their excellent documentation. This page is strongly based off of their work.

Thanks Owen Pragel for reporting [issue #42](https://github.com/clburlison/clburlison.github.io/issues/42).

---

Links:  
[Apache authentication](http://www.webreference.com/programming/apache_authentication/index.html),  
[Configure reposado with Rewrite Rules](http://www.iotopia.com/configure-reposado-on-an-ubuntu-oneric-server-so-deploy-studio-can-use-it/),  
[Creating a Cron task](https://www.digitalocean.com/community/tutorials/how-to-use-cron-to-automate-tasks-on-a-vps),  
[Reposado - Apple Software Update Server](http://jerome.co.za/reposado-a-custom-apple-software-update-server/),  
[Running Margarita in apache](http://denisonmac.wordpress.com/2013/02/28/running-margarita-in-apache/),  
[Issue #42](https://github.com/clburlison/clburlison.github.io/issues/42),  
