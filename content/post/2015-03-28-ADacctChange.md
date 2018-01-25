---
categories:
- tech
date: 2015-03-28T00:00:00Z
excerpt: Change the account name of Cached User Accounts in an Active Directory environment
  on OS X.
modified: 2015-04-24
tags:
- active-directory
- bash
title: AD Account Change
---

<!-- toc -->

# Intro
Changing user account logons in a deployed environment can cause some issues. Doing so with OS X clients that are bound to Active Directory can cause even more issues. Below is how I overcame some of the pitfalls of the built-in OS X Active Directory plugin. This article expands on the basic project Readme instructions located [here](https://github.com/clburlison/scripts/tree/master/clburlison_scripts/ADacctChange).


![acct](/images/2015-03-28/opening_header.png)


{{% alert info %}}
**Note:** The above picture is for reference purposes only. All data has been modified.
{{% /alert %}}


# Why would you do that?
We had two differing username structures for active employees:

1. An older format of first initial followed by last name _(cburlison)_
2. A newer format of employee ID number _(12345)_

Both of these structures have pros and cons but our goal was to use one structure with all employees both current and future.

We decided on a new structure of "b" followed by employee ID number _(b12345)_. At the time, this was found to be the most compatible structure for our organization.

![acct](/images/2015-03-28/ad_acct_structure.png)

## Down-side
Unfortunately, when you change the "User Logon Name" in Active Directory funky things start to happen to Cached Mobile Accounts on OS X clients.

Most notably:

* unable to login with the updated name structure (10.7 & 10.9)
* broken Kerberos for the affected Cached Accounts
	 - broken Single-Sign-On
	 - manually change the OS X ``shortname`` when connecting to file-shares
	 - likely more issues I did not find
* unable to sign-in from the loginwindow (only affects 10.10)

We needed to find a solution that allowed our Domain Administrators to move forward with the Account Policy change while allowing users to still __use__ their Macintosh computers.


{{% alert info %}}
**Note:** On Windows a simple reboot of the client computer will allow users to login with the new name structure. Windows has the polices in place to deal with this type of change. Good job Microsoft!
{{% /alert %}}


# Solution
To solve the issues described above you can delete the Cached Accounts from any affected OS X computer. This will of course allow the employee to log in using their newly structured account name with the one minor set-back of having all their files deleted (or located in the old path). It does fix all the Kerberos issues. I however had no intentions of copying files for hundreds of employees throughout my organization.

What I needed to do was modify the Cached User Accounts already present on our OS X computers. It also needed to meet the following requirements:

1. Don't run until we intact the new user account structure. (Default: April 6th, 2015 at 6am)
2. Only affect Cached Accounts that have their AD User Logon Name changed. Our student accounts were not being modified.
3. Don't modify any Local account present.
4. Display text for our end users if they are present while the change is taking place. We have a reboot at the end.



## The Code
Below is a walk-through of the important lines of the [ADacctChange.sh](https://github.com/clburlison/scripts/blob/master/clburlison_scripts/ADacctChange/ADacctChange.sh) script, along with a description. The purpose is to have additional information that does not really "belong" in the code comments.


[Variables L55-58](https://github.com/clburlison/scripts/blob/master/clburlison_scripts/ADacctChange/ADacctChange.sh#L55-58)  
These should be the only lines that need modification if you wish to adapt this script for a different environment. Variables named appropriately.

```bash
DCSERVER="bisd.k12"
DOMAIN="BISD"
setTime=1504060600
msg="Currently applying a Critical patch. The system will reboot when finished."
```


[Run script as root L73-84](https://github.com/clburlison/scripts/blob/master/clburlison_scripts/ADacctChange/ADacctChange.sh#L73-84)  
We are making system level changes which require root access. The following lines will prompt you for authentication if running the ``ADacctChange.sh`` manually without elevated permissions.

```bash
RunAsRoot()
{
        ## Pass in the full path to the executable as $1
        if [[ "${USER}" != "root" ]] ; then
echo
echo "*** This application must be run as root. Please authenticate below. ***"
                echo
sudo "${1}" && exit 0
        fi
}

RunAsRoot "${0}"
```


[Check Data/Time L92-103](https://github.com/clburlison/scripts/blob/master/clburlison_scripts/ADacctChange/ADacctChange.sh#L92-103)  
The following lines were to solve a very specific need of my environment. We needed to install a LaunchDaemon along with the ADacctChange script to client computers early. Since the Account Policy change was going to be automated and ran over the weekend, I needed a way for computers to know "when" to start checking for changes to Active Directory Accounts. This date check solves that issue. Essentically checks the current system time and compares it to the ``setTime`` variable from above.

```bash
curTime=`date +%y%m%d%H%M`
if [ "$setTime" -gt "$curTime" ]
    then
        echo "It is not time to run this script. Now exiting."
        exit 0
elif [ "$setTime" -lt "$curTime" ]
    then
        echo "It is time to change the Active Directory Cached User Accounts on this system."
else
        echo "Date/Time value is invalid. Now exiting."
        exit 0
fi
```


[Check if computer is bound to AD L112-118](https://github.com/clburlison/scripts/blob/master/clburlison_scripts/ADacctChange/ADacctChange.sh#L112-118)  
A simple check to make sure the client computer is bound to Active Directory. Sometimes computers are kicked off the domain, or never joined for special use cases. If this script is ran on one of those computers we will delete the script and LaunchDeamon.

```bash
# If the machine is not bound to AD, then there's no purpose going any further.
check4AD=`/usr/bin/dscl localhost -list . | grep "Active Directory"`
if [ "${check4AD}" != "Active Directory" ]; then
	echo "This machine is not bound to Active Directory.\nPlease bind to AD first. ";
    /bin/rm /Library/LaunchDaemons/com.github.clburlison.ADacctChange.plist
    /bin/rm $0
fi
```


[Check for active network connection L120-140](https://github.com/clburlison/scripts/blob/master/clburlison_scripts/ADacctChange/ADacctChange.sh#L120-140)  
This check step is to make sure that an active network connection is present. When this script is launched via a LaunchDaemon we need to give the system time to talk with DNS and DHCP. This in theory can create an infinite loop if a connection is never made. The logic is not perfect so edge cases be warned.

```bash
# Determine if the network is up by looking for any non-loopback internet network interfaces.
CheckForNetwork()
{
	local test
	if [ -z "${NETWORKUP:=}" ]; then
		test=$(ifconfig -a inet 2>/dev/null | sed -n -e '/127.0.0.1/d' -e '/0.0.0.0/d' -e '/inet/p' | wc -l)
		if [ "${test}" -gt 0 ]; then
			NETWORKUP="-YES-"
		else
			NETWORKUP="-NO-"
		fi
	fi
}

# If the network never becomes active this could run indefinitely
while [ "${NETWORKUP}" != "-YES-" ]
do
        sleep 5
        NETWORKUP=
        CheckForNetwork
done
```


[Check for connection to an Active Directory Server L142-152](https://github.com/clburlison/scripts/blob/master/clburlison_scripts/ADacctChange/ADacctChange.sh#L142-152)  
Another networking check to make sure the client computer is able to ping an Active Directory server, using the ``DCSERVER`` variable.

```bash
# abort if we're not able to contact a configured directory server
ping -c 1 -t 1 $DCSERVER  > /dev/null 2>&1
if [ $? -eq 0 ]; then
 		ONLOCALNETWORK=YES
	echo "Computer is on the network: $ONLOCALNETWORK"
else
 		ONLOCALNETWORK=NO
	echo "Computer is on the network: $ONLOCALNETWORK"
	echo "Exiting. We cannot talk to the domain controller."
	exit 1
fi
```


[Check for BigHonkingText L162-165](https://github.com/clburlison/scripts/blob/master/clburlison_scripts/ADacctChange/ADacctChange.sh#L162-165)  
The ``BigHonkingText`` binary is present if you use luggage to create a package for deployment. However, if running this script without ``BigHonkingText`` this check will skipping outputting text for the end user.

```bash
if [ -e "/usr/local/bin/BigHonkingText" ]; then
  echo "BigHonkingText is on this system."
  /usr/local/bin/BigHonkingText -w 90% -h 20% -m -p 120 $msg >>/dev/null 2>&1 &
fi
```


[Check for Cached Accounts and modify if needed L175-222](https://github.com/clburlison/scripts/blob/master/clburlison_scripts/ADacctChange/ADacctChange.sh#L175-222)  
This is the meat of the script. This searches through /Users/ for all accounts. Then loops through each account to check for the following:

1. Don't modify the /Users/Shared folder.
2. Don't modify local accounts. We do this by looking for accounts present on the computer between uid 500 and 1000. This makes an assumption that all local accounts use Apple's Default uid range.
3. ``uniqueIDAD`` does a search against the domain for each user in /Users/ to see what the Active Directory UniqueID is. All accounts that have not changed will output some string number. All accounts that have been changed will output an error message since the User Logon Name has changed and can no longer be found in Active Directory. This error results in the ``uniqueIDAD`` variable being null and displaying the following error:

		<dscl_cmd> DS Error: -14136 (eDSRecordNotFound)

4. We then search for the new account name using the Cached Accounts UniqueID (these values should be the same).
5. Once we have the new account name we move the old user account plist to a new user account plist modifying the ``RecordName`` and ``NFSHomeDirectory`` values.
6. Lastly, we move the old home directory to the new home directory path.

The ``sleep`` commands slow the loop to make sure requests from computers do not slam a domain server all at one time.  

```bash
USERLIST=`find /Users -type d -maxdepth 1 -mindepth 1 -not -name "."`
for a in $USERLIST ; do
    [[ "$a" == "/Users/Shared" ]] && continue # Do not modify the Shared Folder

    # Do not modify any local account with UID between 500-1000
    prefix="/Users/"
    old=${a#$prefix}
    OldID=`id -u $old`
    [ "$OldID" -ge 500 -a "$OldID" -le 1000 ] && continue

    uniqueIDAD=`/usr/bin/dscl /Active\ Directory/$DOMAIN/All\ Domains -read $a UniqueID | awk '{ print $2 }'`
    if [ "$uniqueIDAD" == "source" ]; then
        echo "We have received bad data from dscl. Now exiting."
        exit 0
    elif [ -z "$uniqueIDAD" ]; then
        # The varraible is null. We need to modify the current Cached User:
        # the following will be changed "Account Name" and "Home Directory".
        echo "Old username is: " $old
        CachedUID=`/usr/bin/id -u $old`
        echo "Cached UID is: " $CachedUID

        # Get new username as a variable from the Domain
        new=`/usr/bin/dscl /Active\ Directory/$DOMAIN/All\ Domains -search /Users UniqueID $CachedUID | awk 'NR==1{print $1; exit}'`
        echo "New username is: " $new

        # Move the old AD account to the new Account name. Essentially creating a new user account.
        /bin/mv /var/db/dslocal/nodes/Default/users/$old.plist /var/db/dslocal/nodes/Default/users/$new.plist
        /usr/bin/killall opendirectoryd
        sleep 10

        # edit new user attributes, using same passwd hash
        /usr/bin/dscl . -change /Users/$old RecordName $old $new
        sleep 3
        /usr/bin/dscl . -change /Users/$new NFSHomeDirectory /Users/$old /Users/$new
        sleep 3
        /usr/bin/killall opendirectoryd

        # Move Home Directory. Check if there's a home folder there already, if there is, exit before we wipe it
        if [ -f /Users/$new ]; then
            echo "Oops, theres a home folder there already for $new.\nIf you don't want that one, delete it in the Finder first,\nthen run this script again."
        else
            /bin/mv /Users/$old /Users/$new
            /usr/sbin/chown -R ${new} /Users/$new
            #/usr/bin/dscl . -append /Users/$new RecordName $old
            echo "Home for $new now located at /Users/$new"
        fi
    fi
done
```


[Cleanup and reboot L231-234](https://github.com/clburlison/scripts/blob/master/clburlison_scripts/ADacctChange/ADacctChange.sh#L231-234)  
This preforms a cleanup of files, deleting the LaunchDaemon and script. The reboot is to force users to obtain a new Kerberos ticket when they login with the new Username structure.

```bash
/bin/rm /Library/LaunchDaemons/com.github.clburlison.ADacctChange.plist
/bin/rm $0

/sbin/reboot
```



# Special thanks
The following individuals had valuable code that I used while putting this project together.

* Rich Trouton - [https://derflounder.wordpress.com/](https://derflounder.wordpress.com/)
* Charles Edge - [http://krypted.com/](http://krypted.com/)
* Jeff Kelley - [http://blog.slaunchaman.com/](http://blog.slaunchaman.com/)


# Conclusion

The result was a package that is installable via [Luggage](https://github.com/unixorn/luggage) and hosted on Github [here](https://github.com/clburlison/scripts/tree/master/clburlison_scripts/ADacctChange).


As always feel free to drop a comment below or on Twitter. Feedback is always appreciated.


# Aftermath
For the most part our migration went smoothly in my environment. We installed this package a week prior to our Active Directory change and instructed our Mac users to reboot the morning after the change took place. For some users that did not reboot like we asked this script took over and forced a reboot. They had plenty of prior knowledge and at least received a nice popup using BigHonkingText explaining the reboot.  


{{% alert danger %}}
**Note:** If you are using Dropbox in your environment this process will mess up Dropbox settings. Inside of <code>/Users/$HOME/.dropbox</code> there is a setting that is hard coded to the users home directory path. I found the easiest solution is to run a <code>rm ~/.dropbox</code> on the affected users profile. Followed by having the user re-sign in via the Dropbox application. Obviously this solution does not scale very well.
{{% /alert %}}


---

Articles:  
[ADacctChange on Github](https://github.com/clburlison/scripts/tree/master/clburlison_scripts/ADacctChange)
