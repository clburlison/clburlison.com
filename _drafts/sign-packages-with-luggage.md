---
layout: post
title: "Sign Packages with Luggage"
modified:
excerpt: Learn to sign packages with Luggage using your Apple Developer Account.
comments: true
published: true
categories:
- luggage
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

The above is fantastic news and it lays the groundwork for Luggage to sign packages. Honestly, pkgutil is doing all of the hardwork behind the scene but I found documentation on using Luggage to sign packages lacking.

_Note:_  Apple recommends requesting a certificate via Xcode and while it is quite possible, and much easier, I found that the certificate generated via Xcode is only valid for 365 days. Doing it the manual, method, below creates a certificate valid for five (5) years.

{% img /images/draft/1-create-dev-id.png %}

{% img /images/draft/2-dev-installer.png %}

{% img /images/draft/3-create-csr.png %}

{% img /images/draft/4-keychain-csr.png %}

{% img /images/draft/5-creating-the-csr.png %}

{% img /images/draft/6-upload-csr.png %}

{% img /images/draft/7-generate-cert.png %}

{% img /images/draft/8-dl-cert.png %}

{% img /images/draft/9-install-cert.png %}

{% img /images/draft/10-sample-cert.png %}

{% img /images/draft/11-makefile-additional-options.png %}


##Pkgbuild vs PackageMaker

makefiles using postflight scripts now must be changed to postinstall! This is a strict requirement from using the pkgutil.

Note: 10.9.5 - Gatekeeper was re-enabled. Seems Apple is really wanting to beef up their security game. We as Administrotrs can help

---

Articles:  
[Productsign](https://groups.google.com/forum/?fromgroups#!topic/the-luggage/9WeNMBcvKjA),  
[Luggage](https://github.com/unixorn/luggage),  
[Pkgbuild vs PackageMaker](https://groups.google.com/forum/?fromgroups#!topic/the-luggage/aCU9nNsMUaE)
