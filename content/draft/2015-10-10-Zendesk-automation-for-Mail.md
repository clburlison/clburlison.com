---
date: 2015-10-10T00:00:00Z
draft: true
excerpt: Utilize Zendesk's mail API with Apple Mail and Automator.
keywords:
- osx
- Apple
- Mail
- Zendesk
- automation
- api
- automator
- helpdesk
- support
modified:
tags:
- automation
- osx
title: Zendesk Automation for Mail
aliases:
- /2015/10/10/Zendesk-automation-for-Mail/
---

# Intro

I should write something here... ¯\_(ツ)_/¯


# Apple Mail Stationary

1) Download stationary

  This step is given because no matter how you create your stationary it won't work. It's actually much easier to just start with this temporary file rather than using Apple's Mail to start the creation process.

  [[ INSERT ZIP DONWLOAD HERE ]]


1) Double click the .mailstationery file to load it into Apple Mail.
1) Close Mail.app if you have it open

Now lets modify the file.
1) Open the stationary directory
  ~/Library/Containers/com.apple.mail/Data/Library/Application Support/Mail/Stationery/Apple/Contents/Resources/Custom/Contents/Resources
1) Rename your temp.mailstationery to whatever name you wish your stationery to have (don't include spaces)
1) Right click your stationary and click "Show Package Contents"
1) Go down the directory Contents > Resources and open 'content.html' in a text editor
1) Replace the text with whatever you wish to message to say. Make sure and include the break ('<br>') tag after every space. Apple's Mail.app is actually reading this file as an html file. However for Zendesk to read your meta-data these must be plain text. Also, make sure and include your email signature here if you wish to do so. Stationary emails will **NOT** include your default signature.
1) Save the file when finished
1) Now modify your 'Description.plist' changing your Display Name, Folder Name, and TO address accordingly.
1) Save your file when finished
1) Open Apple Mail
1) Create a new message
1) Click on the Stationary button (VERIFY this button is enabled by default)
1) Scroll down to 'Custom'
1) Select your template


At this point if you wish to add the stationary to your favorites just drag it up to the favorites folder. This gives you an easy way to create ticket all from your email. Just make sure and modify any of the command tags.

The above is great for creating new tickets. However what is a use has emailed you the issue directly. The simple solution is, use Zendesk's same email API commands. The only problem is stationary emails are only allowed for new emails in Apple mail. Which brings us to solution two.

# Automator

These servies are stored at ~/Library/Services/


[[ INSERT ZIP DONWLOAD HERE ]]

1) Now assign your service a keyboard shortcut. I used Command + Option + H (⌘ + ⌥ + H)

NOTE: I have the bcc field enabled in Apple Mail. If you don't you will need to remove one of the tabs

# Extra

>To your second question: If the custom field is a drop down, use the tag associated with the selection you want to set. Once you add the tag and submit the ticket update, it will automatically make the corresponding selection from the drop-down. Other custom fields such as regex, numbers and text are not settable via the mail API.
>
> [Comment by Emily - 3/4 page down](https://support.zendesk.com/hc/en-us/articles/203691006-Updating-ticket-properties-from-your-inbox?page=4&preview%5Btheme_id%5D=-1%29)

Resources: [Updating Ticket Properties from You Inbox](https://support.zendesk.com/hc/en-us/articles/203691006-Updating-ticket-properties-from-your-inbox),  
[Automatically Inserting Text Globally](http://apple.stackexchange.com/a/87989),  
[applescript-simulating-enter-key](http://alvinalexander.com/blog/post/mac-os-x/applescript-simulating-enter-key),  
[Complete list of AppleScript key codes](http://eastmanreference.com/complete-list-of-applescript-key-codes/),  
[OS X Mavericks: Create keyboard shortcuts for apps](https://support.apple.com/kb/PH13916?locale=en_US)



[How do I assign a keyboard shortcut to a service in OS X?](http://apple.stackexchange.com/a/44001),  (DELETE before publish)
