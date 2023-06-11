---
categories:
- guides
- tech
date: 2014-10-23T00:00:00Z
excerpt: Install Munkireport-php on our munki server to give us a powerful reporting console for munki clients.
image:
  credit: null
  creditlink: null
  feature: null
modified: 2016-07-25
aliases:
- /blog/2014/10/23/munkirepo-guide-part-3/
tags:
- munki
- ubuntu
- munkireport
title: Setup Munkireport on Ubuntu 14.04 - Part 3
url: /munkirepo-guide-part-3/
---

<!-- toc -->

{{% alert info %}}
**Ubuntu 16.04/ PHP 7:** Lucas Hall has created an updated guide based off of this one that uses Ubuntu 16.04 with PHP 7, which can be viewed [here](https://lucasjhall.com/2016/08/06/munkireport-ubuntu-sql/).
{{% /alert %}}

# Intro
Welcome to the third part in our munki server setup series. In this section, we will download and configure [Munkireport-php](https://github.com/munkireport/munkireport-php) on our munki server.

Before we get to far you might want to head over to [Part 1 - Setting up the munki repo](/munkirepo-guide-part-1/) or [Part 2 - Setting up mandrill](/munkirepo-guide-part-2/). Parts 1 and 2 are not technically required for MunkiReport by you will want to have an understanding of how the other components of your munki server work before setting up the reporting server.

![](/images/2014-10-23/mr.png)

# The Install
Munkireport is a web application written in php that displays useful stats about your munki fleet. The resources taken up by MunkiReport are quite small but like all web apps if you client base grows very large you will want to make sure the database can keep up. With that you can install MunkiReport on any compatible web-server (IIS, apache, or nginx) for this guide we will be using our munki server from Parts 1 & 2 as our reporting server.

Part of this installation includes setting up MySQL as our database backend. SQLite is the default database but I highly recommend setting my MySQL since the [performance](https://github.com/munkireport/munkireport-php/wiki/Performance) gains are high and setup only takes a few more steps, not to mention SQLite will start to choke when higher volumes of clients start to check-in with the reporting server.

It is also important to note, I like MunkiReport to be hosted on a sub-directory. This means when connecting to MuniReport you will type [http://yourserver.example.com/report/]() to access the site. If you want a different setup, you will need to make the necessary changes.


## Installing Required Software

```bash
sudo apt-get update
sudo apt-get -y install nginx git php5-fpm php5-mysql php5-ldap
```


{{% alert info %}}
**Note:** The <code>php5-ldap</code> package is only needed if you are planning on connecting to an Active Directory or LDAP directory for authenticating to MunkiReport.
{{% /alert %}}

## Setup MySQL

Lets install MySQL

```bash
sudo apt-get install mysql-client mysql-server
```

__This will prompt you to create the root mysql database account. Do not forget the password you set.__


Now, we need to tell MySQL to generate the directory structure it needs to store its databases and information. We can do this by typing:

```bash
sudo mysql_install_db
```

Next, you can optionally run a simple security script that will prompt you to modify some insecure defaults (this is highly recommended on production servers). Begin the script by typing:

```bash
sudo mysql_secure_installation
```

You will need to enter the MySQL root password that you selected during installation.

During the secure installation script it will ask if you want to change the root password. If you are happy with your MySQL root password, type "N" for no and hit "ENTER". Afterwards, you will be prompted to remove some test users and databases. You should choice "Y" and hit "enter" through these prompts to remove the "unsafe" defaults from installation.

Once the script has been run, MySQL is ready to go.

### Creating the database

Lets create our MunkiReport database with the name of ``munkireport``. We will also create a database user and password. Change _USERNAME_ and _PASSWORD_ to your preference. Note the database username that is created below is what you will enter into your config.php in the following steps. It is bad practice to use the root account for database entry.

```bash

echo "CREATE DATABASE munkireport CHARACTER SET utf8 COLLATE utf8_bin;" | mysql -u root -p
echo "CREATE USER 'USERNAME'@'localhost' IDENTIFIED BY 'PASSWORD';" | mysql -u root -p
echo "GRANT ALL PRIVILEGES ON munkireport.* TO 'USERNAME'@'localhost' IDENTIFIED BY 'PASSWORD';" | mysql -u root -p
echo "FLUSH PRIVILEGES;" | mysql -u root -p

```

## Configure php
Lets make one small change to the default php configuration.

```bash
sudo nano /etc/php5/fpm/php.ini
```

Find the line, __cgi.fix_pathinfo=1__, and change the __1 to 0__. Also, uncomment this line to enable this security setting. The file should now look like the below excerpt:

```bash
<---------------

; cgi.fix_pathinfo provides *real* PATH_INFO/PATH_TRANSLATED support for CGI.  PHP's
; previous behaviour was to set PATH_TRANSLATED to SCRIPT_FILENAME, and to not grok
; what PATH_INFO is.  For more information on PATH_INFO, see the cgi specs.  Setting
; this to 1 will cause PHP CGI to fix its paths to conform to the spec.  A setting
; of zero causes PHP to behave as before.  Default is 1.  You should fix your scripts
; to use SCRIPT_FILENAME rather than PATH_TRANSLATED.
; http://php.net/cgi.fix-pathinfo
cgi.fix_pathinfo=0

--------------->
```


If this number is kept as 1, the php interpreter will do its best to process the file that is as near to the requested file as possible. This is a possible security risk. If this number is set to 0, conversely, the interpreter will only process the exact file path—a much safer alternative. Save and Exit.

Now, restart php-fpm for the change to take affect:

```bash
sudo service php5-fpm restart
```

## Downloading MunkiReport

We are finally to the point that we can start getting MunkiReport setup.

```bash
sudo git clone https://github.com/munkireport/munkireport-php /usr/share/nginx/html/report
```

At this point, lets create a link to our report folder for our local Ubuntu admin, this allows us to make modifications easier in the future.

```bash
sudo ln -s /usr/share/nginx/html/report ~/report
```

MunkiReport requires a config.php, this is your settings for MunkiReport. Below are some defaults that I think most users will want. For a full list of options please visit [here](https://github.com/munkireport/munkireport-php/blob/master/config_default.php).

You will want to change  the following in your config.php file:

* sitename = change Company to something useful
* allow_migrations = you will want to change this to true for MunkiReport updates
* debug = change this to false if you don't need debugging
* timezone = for your [timezone](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
* ssh = change _ladmin_ to your company local mac admin account
* locale = change to location
* lang = change to your language



The root account is created for you, for testing purposes. You will want to create your own admin account by visiting [http://yourserver.example.com/report/index.php?/auth/generate](http://yourserver.example.com/report/index.php?/auth/generate).

Let's create a new `config.php` file that stores our settings.

```bash
sudo nano /usr/share/nginx/html/report/config.php
```

You'll want to copy/paste the entire section below, making changes where necessary. The last section of the config file deals with our MySQL database. You will want to change the username and password to match what you created in the previous step.

```php
<?php if ( ! defined( 'KISS' ) ) exit;

$conf['index_page'] = 'index.php?';
$conf['sitename'] = 'Company - MunkiReport';
$conf['allow_migrations'] = FALSE;
$conf['debug'] = TRUE;
$conf['timezone'] = @date_default_timezone_get(America/Chicago);
$conf['vnc_link'] = "vnc://%s:5900";
$conf['ssh_link'] = "ssh://ladmin@%s";
ini_set('session.cookie_lifetime', 43200);
$conf['locale'] = 'en_US';
$conf['lang'] = 'en';
$conf['keep_previous_displays'] = TRUE;

/*
|===============================================
| Authorized Users of Munki Report
|===============================================
| Visit http://yourserver.example.com/report/index.php?/auth/generate to generate additional local values
*/
$auth_config['root'] = '$P$BUqxGuzR2VfbSvOtjxlwsHTLIMTmuw0'; // Password is root

/*
|===============================================
| PDO Datasource
|===============================================
*/
$conf['pdo_dsn'] = 'mysql:host=localhost;dbname=munkireport';
$conf['pdo_user'] = 'munki';
$conf['pdo_pass'] = 'munki';
$conf['pdo_opts'] = array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8');
```



We are an Active Directory shop at my work place and for that reason I really like the ability for MunkiReport to pull an AD group and give access (remember the php5-ldap package we installed earlier). Unfortunately, in my current testing this function is slightly broken at the moment. When attempting to login to MunkiReport using AD Group Authorization you will be presented a white screen. A refresh on the blank screen along with a "Resend form data" will get you to the dashboard. This is a pretty annoying inconvenience, so at this moment I have simply added our report administrators into the 'allowed_users' line in my config.php.  

Below are the additional settings need to make Active Directory work with MunkiReport:

```bash

// Below are the options for Active Directory user authorization
$conf['auth']['auth_AD']['account_suffix'] = '@example.com';
$conf['auth']['auth_AD']['base_dn'] = 'dc=example,dc=come'; //set to NULL to auto-detect
$conf['auth']['auth_AD']['domain_controllers'] = array('server1.example.com','server2.example.com'); //can be an array of servers
$conf['auth']['auth_AD']['admin_username'] = 'admin'; //if needed to perform the search
$conf['auth']['auth_AD']['admin_password'] = 'munki_is_cool'; //if needed to perform the search
$conf['auth']['auth_AD']['mr_allowed_users'] = array('userA','userB','userC');
$conf['auth']['auth_AD']['mr_allowed_groups'] = array('MunkiReportAdmins'); //case sensitive

```

## Configure nginx for MunkiReport

Lets configure nginx to use [http://yourserver.example.com/report](http://yourserver.example.com/report)


```bash
sudo nano /etc/nginx/sites-enabled/default
```  


{{% alert info %}}
**Note:** Make sure and change your <code>server_name</code>. This file also takes care of our munki_repo from <a href="/munkirepo-guide-part-1/">Part 1</a>.
{{% /alert %}}

```bash
server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    root /usr/share/nginx/html;
    index index.php index.html index.htm;

    server_name munki;

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    location /report {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }

    location /munki_repo/ {
      alias /usr/local/munki_repo/;
      autoindex off;
      auth_basic "Restricted";
      auth_basic_user_file /etc/nginx/.htpasswd;
  }
}
```

We must change our nginx default settings for php to work.

```bash
sudo nano /etc/nginx/nginx.conf
```

Look for ``default_type  application/octet-stream;`` and comment this line out. Check out the below excerpt:


```bash
<---------------

# server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        #default_type application/octet-stream; //comment me out for MunkiReport to work

        ##
        # Logging Settings
        ##

--------------->
```

To test your nginx configuration run the following command. This will make sure that you have no errors.

```bash
sudo nginx -c /etc/nginx/nginx.conf -t
```


Restart Nginx to make the necessary changes:

```bash
sudo service nginx restart
```


# Conclusion
You should now have a basic MunkiReport configuration up and running. Double check that everything is working by visiting [http://youserver.example.com/report/](http://youserver.example.com/report/). Remember the default username and password, ``root``. For more settings and additional information please visit the Wiki for [MunkiReport](https://github.com/munkireport/munkireport-php/wiki).

As always feel free to drop a comment below or on Twitter. Feedback is always appreciated.


{{% alert info %}}
**Congrats!** You made it this far. Unfortunately you're not done yet. You will likely run into an issue with request size on your munki clients as such please go read [this](https://clburlison.com/munkireport-error-fix/).
{{% /alert %}}

---

# Apendium 1 - connecting a client to MunkiReport
If you would like to connect a single munki client to MunkiReport you can use the following command:

```bash
sudo /bin/bash -c "$(curl -s http://yourserver.example.com/report/index.php?/install)"
```

# Apendium 2 - adding MunkiReport to your munki_repo
To add multiple Munki clients to MunkiReport we should use munki. To get a generated plist file that you can drop into your _munki_repo/pkginfo_ directory run the following command.

```bash
curl -s https://yourserver.example.com/report/index.php?/install/plist -o \
~/Desktop/MunkiReport.plist
```

The output file will end up on your Desktop for easy transfer to your repo.

---

Articles:  
[Install LEMP stack on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-14-04),  
[Munkireport Wiki](https://github.com/munkireport/munkireport-php/wiki),  
[nbalonso Munkireport-php](http://www.nbalonso.com/new-munkireport-php-2/),  
