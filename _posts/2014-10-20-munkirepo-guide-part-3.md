---
layout: post
title: "Setup Munkireport on Ubuntu 14.04 - Part 3"
date: 2014-10-20T22:55:49-05:00
modified:
categories: munki ubuntu munkireport
excerpt: Install Munkireport-php on our munki server to give us a powerful reporting console for munki clients. 
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
Welcome to the third part in our munki repo setup series. In this section, we will download and configure [Munkireport-php](https://github.com/munkireport/munkireport-php) on our munki server. Part of this installation includes setting up MySQL as our database backend, since the default SQLite backend will start to chock when higher volumes of clients start to check-in with the reporting server. 

Before we get to far you might want to head over to [Part 1 - Setting up the munki repo]() or [Part 2 - Setting up mandrill](). Parts 1 and 2 are not technically required for this guide you will want to have an understanding of how the munki repo works before setting up the reporting server. You could host your reporting server on a separate server I highly recommend understanding those before moving on to this guide. 


#The Install




##Installing Required Software

sudo apt-get update
sudo apt-get -y install nginx git php5-fpm php5-mysql php5-ldap

A nice feature in Ubuntu 14.04 is that Nginx is configured to start running upon installation. So after this install

##Setup mySQL

Lets install mysql

``sudo apt-get install mysql-client mysql-server``

* This will prompt you to create the root mysql database account


First, we need to tell MySQL to generate the directory structure it needs to store its databases and information. We can do this by typing:

``sudo mysql_install_db``

Next, you can optionally run a simple security script that will prompt you to modify some insecure defaults (this is highly recommended on production servers). Begin the script by typing:

``sudo mysql_secure_installation``

You will need to enter the MySQL root password that you selected during installation.

Next, it will ask if you want to change that password. If you are happy with your MySQL root password, type "N" for no and hit "ENTER". Afterwards, you will be prompted to remove some test users and databases. You should just hit "ENTER" through these prompts to remove the unsafe default settings.

Once the script has been run, MySQL is ready to go.

###Creating the database

	echo "CREATE DATABASE munkireport CHARACTER SET utf8 COLLATE utf8_bin;" | mysql -u root -p
	echo "CREATE USER 'munki'@'localhost' IDENTIFIED BY 'yellowbreadMAN';" | mysql -u root -p
	echo "GRANT ALL PRIVILEGES ON munkireport.* TO 'munki'@'localhost' IDENTIFIED BY 'yellowbreadMAN';" | mysql -u root -p
	echo "FLUSH PRIVILEGES;" | mysql -u root -p
  
  
##Configure php
We need to make one small change in the php configuration.Open up php.ini:

``sudo nano /etc/php5/fpm/php.ini``

Find the line, cgi.fix_pathinfo=1, and change the 1 to 0. Also, uncomment this line to enable this security setting.

``cgi.fix_pathinfo=0``

If this number is kept as 1, the php interpreter will do its best to process the file that is as near to the requested file as possible. This is a possible security risk. If this number is set to 0, conversely, the interpreter will only process the exact file path—a much safer alternative. Save and Exit. We need to make another small change in the php5-fpm configuration.Open up www.conf:

Save and Exit.  

Restart php-fpm:

``sudo service php5-fpm restart``

##Downloading Munkireport

``sudo git clone https://github.com/munkireport/munkireport-php /usr/share/nginx/html/report``

At this point, lets create a link to our report folder in our admin users home folder. 

``sudo ln -s /usr/share/nginx/html/report ~/report``

To get up and running create a config.php..

``sudo nano /usr/share/nginx/html/report/config.php``



<-- Insert a config.php example here with munkireport mysql database-->


We are an Active Directory shop at my work place and for that reason I really like the ability for munkireport to pull an AD group and give access. Unfortunately in my current testing this function is slightly broken at the moment. The issue is during login munkireport will authenticate the user but does not go to the dashboard. A refresh on the blank screen along with a "Resend form data" will get you to the dashboard. This is a pretty annoying inconvenience so at this moment I have simply added our report administrators to the Users line in my Config.php file. See below:

<-- Insert section of config.php with AD authentication settings-->



##Configure nginx for munkireport

Lets configure nginx to use [](http://servername/report)

``sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bkup``

``sudo nano /etc/nginx/sites-available/default``




server {
	listen 80 default_server;
	listen [::]:80 default_server ipv6only=on;

	root /usr/share/nginx/html;
	index index.php index.html index.htm;

	# Make site accessible from http://localhost/
	server_name munki;

	location / {
		try_files $uri $uri/ =404;
	}
    
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }

}


We must change our nginx default type to all php to work 

``sudo nano /etc/nginx/nginx.conf``

Look for ``default_type  application/octet-stream;`` and comment this line out.

To test your nginx configuration run the following command. This will make sure that you have no errors.

``sudo nginx -c /etc/nginx/nginx.conf -t``


Restart Nginx to make the necessary changes:

``sudo service nginx restart``


---

#Apendium 1 - connecting a client to munkireport

#Apendium 2 - adding munkireport to your munki_repo

#Apendium 3 - connecting to your database using sequel pro


---

Articles:  
[Install LEMP stack on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-14-04),  
