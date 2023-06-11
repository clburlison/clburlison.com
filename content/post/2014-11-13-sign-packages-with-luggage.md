---
categories:
- tech
date: 2014-11-13T00:00:00Z
excerpt: Learn to sign packages with Luggage using your Apple Developer Account.
modified: 2015-04-06
aliases:
- /blog/2014/11/13/sign-packages-with-luggage/
tags:
- luggage
- macos
title: Sign Packages with Luggage
---

# Intro
Are you an Apple Developer? Most of the Apple Admin Community have developer accounts for the simple reason of gaining access to beta releases earlier than the public. This extra times allows us to test for changes that might affect the environments we support before it ends up in the hands of our users. Up until this point that is the only reason I could justify having a Dev account. Recently I found out that being a developer gives you the access to sign packages using a secure certificate from Apple, which I will document below.

As of October 24th, commit [4d270a0](https://github.com/unixorn/luggage/commit/4d270a0dbc5f31bebbf9672d4a2970ad6316c8b4) of the Luggage project, packagemaker is no longer a requirement!! A pretty big deal since packagemaker has not seen an update since the late days of Snow Leopard. This update to Luggage, makes use of Apple's built-in pkgutil command to build native OS X packages. For quite some time you could force Luggage to use pkgutil but this required adding ``PKGBUILD=1`` to the top of every Makefile.

Luggage allows us to create packages that meet the following requirements:

* repeatability
* mobile
* sharable
* easy incremental versioning

# The Setup

The above is fantastic news and it lays the groundwork for Luggage to sign packages. Honestly, pkgutil is doing all of the hardwork behind the scene but I found documentation on using Luggage to sign packages spread all over. The goal below is to document the process of signing a package from start to finish.


{{% alert info %}}
**Note:** Apple recommends requesting a certificate via Xcode and while it is quite possible, and much easier, I found that the certificate generated via Xcode is only valid for 365 days. Doing it the manual method below creates a certificate valid for five (5) years.
{{% /alert %}}

## Obtaining the certificate
Visit the [Apple Developer page](https://developer.apple.com) and login via the Member Center link (top right).

1. Click the on the certificates section.
![](/images/2014-11-13/0-certiicates.png)

1. Click on the Mac certificate section.
![](/images/2014-11-13/0-mac-certs.png)

1. Create a new certificate from the plus (+) button.
![](/images/2014-11-13/0-new-cert.png)

1. Create a new Developer ID.
![](/images/2014-11-13/1-create-dev-id.png)

1. Create an "installer" certificate to use with Luggage.
![](/images/2014-11-13/2-dev-installer.png)

1. The steps on this page explain how to create a certificate signing request (csr). I will detail the steps in following images. For now just open "Keychain Access".
![](/images/2014-11-13/3-create-csr.png)

1. Keychain Access > Certificate Assistant > Request a Certificate from a Certificate Authority...
![](/images/2014-11-13/4-keychain-csr.png)

1. Fill in the Email address and Common Name.  

{{% alert danger %}}
**Note:** Do not fill in the CA Email per Apple's instructions.
{{% /alert %}}

![](/images/2014-11-13/5-creating-the-csr.png)

1. After the CSR is created upload to Apple's website.
![](/images/2014-11-13/6-upload-csr.png)

1. Generate the certificate.
![](/images/2014-11-13/7-generate-cert.png)

1. Download your newly created certificate.
![](/images/2014-11-13/8-dl-cert.png)

1. Double click your cert to install into your keychain. (I choice to install to my login keychain)  
![](/images/2014-11-13/9-install-cert.png)

For reference my certificate looks like the below.
![](/images/2014-11-13/10-sample-cert.png)

## Create a signed package
Great we have a newly created certificate ready for us to use. Now we need to sign a package and what better package to sign then luggage itself.

If you already have the Luggage downloaded simply change directory into the project directory. Else download it with git using the following.

```bash
git clone https://github.com/unixorn/luggage.git /your/luggage/path
cd /your/luggage/path
```

If by some chance you have made it this far without actually installing luggage run the following

```bash
make bootstrap_files
```

Now lets make a non-signed package with luggage, that installs luggage (meta enough for ya), run the following:

```bash
make pkg
```

Rename the package to ``luggage-no-sign.pkg``. We are doing this for comparisons later.

To tell luggage to sign the package you need to add the following line of code inside of the Makefile at the beginning. Make sure to change the information in the double quotes with the name of your certificate (review image 11 above).

```bash
PB_EXTRA_ARGS+= --sign "Developer ID Installer: Clayton Burlison"
```

If you are lost on where to add the code in the Makefile see the sample below:

```bash
<----------------
#
# Sample package that packages luggage.make and prototype.plist

include luggage.make
PB_EXTRA_ARGS+= --sign "Developer ID Installer: Clayton Burlison"

TITLE=luggage
REVERSE_DOMAIN=net.apesseekingknowledge
PAYLOAD=pack-luggage.make pack-prototype.plist \
	pack-usr-local-bin-app2luggage.rb

help::
	@-echo
	@-echo "Installation"
	@-echo
	@-echo "To copy luggage's files to /usr/local/share/luggage: make bootstrap_files"
---------------->
```

Lastly, lets create the signed package.

```bash
make pkg
```

If your login.keychain is locked or you decided to put your cert keys in a separate keychain you will see the following pop-up below. Simply type the password associated with that keychain to allow pkgutil to sign the package.

![](/images/2014-11-13/12-access-to-keychain.png)

Notice below the visual lock on the signed package. This package will be trusted with Gatekeeper using the default settings.
![](/images/2014-11-13/13-sign-vs-nonsign.png)

If you click on the lock while in the installer window you can get details about the certificate used to sign a package.
![](/images/2014-11-13/14-verify-sign-package-cert.png)

## Pkgbuild vs PackageMaker

If you have any Makefiles using ``postflight`` scripts they will need to change the script type to ``postinstall``. This is a requirement from using pkgutil.


# Conclusion
Signing packages might seem like a great idea. Lets sign all the packages....but wait. Think of the reasons you are doing it first. It might make sense to **not** sign packages. For example, if you are creating packages that are only ever going to be ran in Munki, it is not a requirement for that package to be signed. If your certificate expires, you will need to recreate a new package. If however you want to distribute packages to you end-users via the internet it might be company policy or best practice to sign packages. Just wanted to give warnings.


### Random Note
In the update to 10.9.5 - Gatekeeper was re-enabled. Seems Apple is really wanting to beef up their security game.

---

Articles:  
[Productsign](https://groups.google.com/forum/?fromgroups#!topic/the-luggage/9WeNMBcvKjA),  
[Luggage](https://github.com/unixorn/luggage),  
[Pkgbuild vs PackageMaker](https://groups.google.com/forum/?fromgroups#!topic/the-luggage/aCU9nNsMUaE)
