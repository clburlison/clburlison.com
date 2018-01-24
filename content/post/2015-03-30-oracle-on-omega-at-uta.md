---
categories:
- personal
date: 2015-03-30T00:00:00Z
excerpt: Guide for using the Omega server and Oracle application for UTA students.
modified: 2015-04-30
tags:
- oracle
- database
- college
title: Oracle on Omega at UTA
---

<!-- toc -->

# Intro
The University of Texas at Arlington (UTA) has some articles that are quite outdated regarding using their Oracle database server. On top of that no information is given to users that have Macintosh computers. If you happen to be taking an Information System class like Database Management Systems (INSY 3304) then good luck when it comes to remotely connecting to the Oracle server. To make-up for the lack of documentation I am creating the following guide.

All information should be up-to-date at the time of writing. I however cannot ensure that years or even months from now that UTA's system will be the same. This is mostly targeted at classmates in my current section that expressed an overall sound of confusion when my professor attempted to demonstrate the process in class using a Windows computer.

# Requirements
Before you are able to connect to the Oracle application. You need to make sure you have the following:

* A Oracle Database account
* A active connection at UTA or a VPN connection
* Access to the Omega server

# Setup Instructions
Since each section below is heavily reliant on the setup from the previous section being complete please do not skip any steps. Sorry if you hear background noise during any of the videos below. I was slightly rushed to get the videos created so the volume of my voice might also be a little low.

## Oracle account
This was the most time consuming step as it seems like a UTA helpdesk staff member has to manually create the account for each request. If you have homework due in the future please do _not_ wait on getting your account created.

> Oracle accounts are available to everyone with a current Omega account. You can request an Oracle account by emailing Help Desk at [helpdesk@uta.edu](mailto:helpdesk@uta.edu). Additionally, instructors may request Oracle accounts for all students in a particular session.
>
> -- [Using Oracle on Omega](http://www.uta.edu/oit/cs/unix/applications/oracle/Using-Oracle-on-Omega.php)

As of the 2015 Fall semester my Omega account was created automatically. To get my Oracle account created I sent an email to the helpdesk. Make sure and include that you need an "Oracle database account created on the Omega server".

In short, Omega is a server that UTA maintains. On that server they have Oracle's Database application installed. You as a student need access to both Omega (should use your NetID username/password) and an Oracle account which will have the same username as your NetID but the password will be sent to you via the Helpdesk once an account has been created.

## VPN connection
Since most students will want to work on their homework while at home I highly recommend setting up the VPN connection now. This VPN connection is needed to access the Omega server. The setup should be very similar on Windows.


{{% alert info %}}
**Note:** If you are currently on the UTA campus the VPN connection does not need to be active.
{{% /alert %}}


You will need to download and install the Cisco AnyConnect application from [https://vpn.uta.edu](https://vpn.uta.edu).

The server address for the VPN application is: **vpn.uta.edu**

{{< youtube y5Tj9-oMJuI >}}



## Cyberduck
I highly recommend using Cyberduck to copy files from your computer to the Omega server. The graphical interface is much easier to use for individuals that are new the command line.

Download Cyberduck from [https://cyberduck.io](https://cyberduck.io).


{{< youtube U2te9s3zkZI >}}


## SSH setup

Make sure you are still connected to the UTA VPN for the following.

Run the following commands on your Mac:

```bash
mkdir -p ~/.ssh
nano ~/.ssh/config
```


**~/.ssh/config** file contents:  
Change the ``User`` field to your UTA NetID.

```bash
Host omega
    User clb4596
    HostName omega.uta.edu
    Port 22
```

{{< youtube PQPaXi7mZGA >}}

## Sqlplus


Type the following commands when connected to the Omega Server:

```bash
sqlplus
```

```bash
@PERFECTPETS.SQL
```

List all tables owned by you:
```bash
SELECT * FROM cat;
```


Clear screen in SQLPlus
```bash
SQL > host clear
```

Exit Prompt
```bash
SQL > exit
```


{{< youtube MNEvtmSJj6Y >}}


The UTA helpdesk does provide some useful documentation at this point on using the Oracle database. I highly recommend changing your default password using the following instructions:

> To change your Oracle password. In sqlplus, type:
>
> SQL> ALTER USER username IDENTIFIED BY newpassword;
>
> Replace username with your NetID.
>
> Replace newpassword with the new password that want to create.
>
> -- [Using Oracle on Omega](http://www.uta.edu/oit/cs/unix/applications/oracle/Using-Oracle-on-Omega.php)

# Conclusion
Hopefully these instructions help clear up any confusion on using the Omega server and Oracle application provided by UTA.

As always feel free to drop a comment below or on Twitter. Feedback is always appreciated.

---

Articles:  
[UTA VPN](http://www.uta.edu/oit/cs/software/vpn/),  
[SSH application for Windows](http://www.uta.edu/oit/cs/software/ssh/ssh-secure-shell-for-workstations-3/index.php),  
[Using Oracle on Omega](http://www.uta.edu/oit/cs/unix/applications/oracle/Using-Oracle-on-Omega.php),  
[More Oracle tips](http://crystal.uta.edu/~elmasri/db2/usingOracleOnOmega.html)
