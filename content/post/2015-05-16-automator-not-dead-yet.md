---
categories:
- tech
date: 2015-05-16T00:00:00Z
excerpt: In fact it is as powerful today as it was five years ago.
image:
  credit: Brian Nagel
  creditlink: http://brian-nagel.com/2011/04/15/mac-osx-automator-examples/
  feature: 2015-05-16/automator-workflow.png
modified: 2015-06-01
tags:
- automation
title: Automator is not dead yet
aliases:
  - "automator-not-dead-yet/"
---

# Intro
Automator is unique in its ability of creating "automation" via the usage of a graphical tasked based workflow. Most other tools that I use for automation are command line driven. So what can you do that's so amazing?

* Create applications. No really Automator has the ability to create a ``.app``.
* Create services. The ability to directly apply changes inside of applications.
* It is easy! No advanced computer skills are needed, however scripting languages are a great addition.

# Services
Creating a service is relatively simple. Below is the process of creating a service that removes spaces from files. When working with web servers the space character is encoded as "%20". This annoys me and looks ugly. As such, I remove all spaces and replace them with underscores prior to uploading to a web site.

1. Open Automator.

1. Create a new Service.

	![](/images/2015-05-16/service-new.png)

1. Change the "Service receives selected" to "files or folders" and leave "any application".

	![](/images/2015-05-16/service-received.png)

1. Search for "Rename" in the Library. Drag "Rename Finder Items" into the workflow.

	![](/images/2015-05-16/service-rename.png)

1. If you see the following pop-up select "Don't Add"

	![](/images/2015-05-16/service-popup.png)

1. Modify the workflow to match the following settings. The Find field has a single space character typed.

	![](/images/2015-05-16/service-rename-workflow.png)

1. Save and name your service. This service will live in ``~/Library/Services/``.

To run a service simply right click on a single file or group of files and select the service. This will work on Folders as well.

![](/images/2015-05-16/finder-service.png)

## My Services
Below are the services that I use frequently. To install these simply downloading, unzip, and double click on the ``.workflow`` file. A prompt to install will be be presented.

* [Add_Prefix.workflow](/images/2015-05-16/Add_Prefix.workflow.zip)
* [Print_Selection.workflow](/images/2015-05-16/Print_Selection.workflow.zip)
* [Remove_Prefix.workflow](/images/2015-05-16/Remove_Prefix.workflow.zip)
* [Remove_spaces.workflow](/images/2015-05-16/Remove_spaces.workflow.zip)

# Conclusion
Services are quite powerful and can end up saving quite a bit of time. Services are not only limited to Finder and can be expanded to pretty much all applications.
