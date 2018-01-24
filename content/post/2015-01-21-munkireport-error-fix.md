---
categories:
- tech
date: 2015-01-21T00:00:00Z
modified: null
aliases:
- /blog/2015/01/21/munkireport-error-fix/
tags:
- munkireport
title: Fix Munkireport Error Request Too Large
url: "munkireport-error-fix/"
---

<!-- toc -->

# Intro
I use [Munkireport-php](https://github.com/munkireport/munkireport-php) as my main reporting system at my work but have recently ran into an error when uploading data from client machines. My setup is using nginx to serve the files.

## Error message
The error message below is what was showing up from a manual munki run with verbose enabled, you can run the command with:

```bash
sudo /usr/local/munki/managedsoftwareupdate -v
```

```bash
...
Starting...
    Running preinstall_script for munkireport...
    BaseURL is http://munki01.example.com/report/
    Retrieving munkireport scripts
    Configuring munkireport
    + Installing ard
    + Installing bluetooth
    + Installing directory_service
    + Installing disk_report
    + Installing displays_info
    + Installing filevault_status
    + Installing installhistory
    + Installing inventory
    + Installing localadmin
    + Installing munkireport
    + Installing network
    + Installing power
    + Installing warranty
    Installation of MunkiReport v2.1.0 complete.
    Running the preflight script for initialization
Installing Munkireport Install and config (1 of 1)...
    Running postinstall_script for munkireport...
Finishing...
    Performing postflight tasks...
    postflight stderr: ERROR: Munkireport: http://munki01.example.com/report/index.php?/report/check_in
ERROR: Munkireport: We failed to reach a server
ERROR: Munkireport: Reason: Request Entity Too Large
Done.
```

After some digging around, this error is an http Error 413 which is normally caused by:

* uploading a large file from a visitor or client machine to the web server
* too much POST data being sent by the client

This can be easily fixed by modifying your nginx configuration to increasing the size allowed on upload. Which will allow the run to complete successfully.

# The Fix

We can fix this HTTP request issue at three different levels of the nginx config: the **http** block, the **server** block or the **location** block.

Open your nginx configuration:

```bash
sudo nano /etc/nginx/nginx.conf
```

The following example increased the file size upload to 10 MB which solved the error for me. Your milage may vary and you might need to increase the max size if this doesn't solve your error.

```bash
http {
	client_max_body_size 10M; # allows file uploads up to 10 megabytes
	...
}
```

After changing the server configuration run the following command to reload your Nginx service.

```bash
sudo service nginx restart
```

# Anything else?
In addition to the change above, it might be necessary to modify PHP settings on your server. Open your PHP configuration file:

```bash
sudo nano /etc/php5/fpm/php.ini
```

Look for the following two values and increase if needed:

* **upload_max_filesize:** Maximum allowed size for uploaded files (default: 2 megabytes). You need to increase this value if you expect files over 2 megabytes in size.
* **post_max_size:** Maximum size of POST data that PHP will accept (default: 8 megabytes). Files are sent via POST data, so you need to increase this value if you are expecting files over 8 megabytes.

If you make any changes your will need to reload Nginx (above) and PHP-FPM (below):

```bash
sudo restart php5-fpm
```

_Note_: Modifying my PHP was not necessary for my setup but I will leave it here in case it helps you.


---

Articles:  
[Nginx error 413](http://cnedelcu.blogspot.com/2013/09/nginx-error-413-request-entity-too-large.html),  
[Munkireport Wiki](https://github.com/munkireport/munkireport-php/),  
