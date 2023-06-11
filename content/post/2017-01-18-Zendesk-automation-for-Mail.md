---
categories:
- tech
date: 2017-01-18
excerpt: Utilize Zendesk's mail API with Apple Mail and Automator.
keywords:
- macos
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
- macos
title: Zendesk Automation for Mail
toc: false
---


# Intro

Before I get into the material of this post I want to refer you to an article written last week by Sal Soghoian, [click here](https://www.macstories.net/stories/app-extensions-are-not-a-replacement-for-user-automation/). The information that he provides regarding user automation is exactly what makes the process described in this post possible.

In case you are not aware, Zendesk is a web-based helpdesk application that is cloud hosted and quite popular. They have an email API that allows agents to create a ticket with a simple email. The power behind this API starts to show when you are an agent that happens to get many emails that could be tickets. *cough*.

Now with that out of the way let's look at some automation for Zendesk.

<!---
# Apple Mail Stationary

This was the method I attempted first however it turned out to be a big flop. Mail Stationary can only be applied to new emails.

The Mail Stationary is great for creating new tickets. However what is a use has emailed you the issue directly. The simple solution is, use Zendesk's same email API commands. The only problem is stationary emails are only allowed for new emails in Apple mail.

1. Download stationary
  This step is given because no matter how you create your stationary it won't work. It's actually much easier to just start with this temporary file rather than using Apple's Mail to start the creation process.

  [[ INSERT ZIP DONWLOAD HERE ]]


1. Double click the .mailstationery file to load it into Apple Mail.
1. Close Mail.app if you have it open

Now lets modify the file.

1. Open the stationary directory `~/Library/Containers/com.apple.mail/Data/Library/Application Support/Mail/Stationery/Apple/Contents/Resources/Custom/Contents/Resources`
1. Rename your temp.mailstationery to whatever name you wish your stationery to have (don't include spaces)
1. Right click your stationary and click "Show Package Contents"
1. Go down the directory Contents > Resources and open 'content.html' in a text editor
1. Replace the text with whatever you wish to message to say. Make sure and include the break (`<br>`) tag after every space. Apple's Mail.app is actually reading this file as an html file. However for Zendesk to read your meta-data these must be plain text. Also, make sure and include your email signature here if you wish to do so. Stationary emails will **NOT** include your default signature.
1. Save the file when finished
1. Now modify your 'Description.plist' changing your Display Name, Folder Name, and TO address accordingly.
1. Save your file when finished
1. Open Apple Mail
1. Create a new message
1. Click on the Stationary button (VERIFY this button is enabled by default)
1. Scroll down to 'Custom'
1. Select your template

At this point if you wish to add the stationary to your favorites just drag it up to the favorites folder. This gives you an easy way to create ticket all from your email. Just make sure and modify any of the command tags.
--->

# Automator

Zendesk has a great article on [Updating Ticket Properties from You Inbox](https://support.zendesk.com/hc/en-us/articles/203691006-Updating-ticket-properties-from-your-inbox) that gives an overview of what the mail API does and how it works. This post will extend on the API to help automate the process. We are going to use an Automator service to type all of the metadata fields. It should be noted that this process will work in Outlook and Apple Mail for macOS. An example of the output can be seen below:

{{< image classes="fancybox center clear" src="/images/2017-01-18/mail_api_example_2.png" title="Example metadata for the email API. Image credit Zendesk." >}}


1. You can download a template service from [github.com/clburlison/automator_services](https://github.com/clburlison/automator_services/archive/master.zip).
1. Unzip the archive file and double-click on the `_AssignZendeskTicket.workflow` file.
1. When you see the following popup select "Open in Automator"

    ![automator prompt](/images/2017-01-18/automator_prompt.png)

1. You will see the following AppleScript action:

    ```bash
    on run {input, parameters}
    tell application "System Events"
      keystroke "support@example.zendesk.com"
      keystroke tab
      keystroke tab
      keystroke tab
      keystroke tab
      #keystroke "#requester"
      #keystroke space
      #keystroke return
      keystroke "#assignee jane.doe@example.com"
      keystroke return
      keystroke "#location Some location"
      keystroke return
      keystroke "#group IT Staff"
      keystroke return
      keystroke "#status open"
      keystroke return
      keystroke "#priority normal"
      keystroke return
      keystroke "#type incident"
      keystroke return
      keystroke "#public false"
      keystroke return
      #keystroke return
      #keystroke "Hi ___ENTER_NAME_HERE,"
      #keystroke return
      #keystroke return
      #keystroke "MESSAGE_HERE."
      #keystroke return
      keystroke return
    end tell
    end run
    ```

1. You will want to modify many of the lines to match your location, group, default status, etc.
  * Notice that I have the `#requester` metadata field commented out with a hash (`#`), this is due to a Zendesk setting that we have enabled (you might need to uncomment this)
  * I also have a few additional lines at the end for comments if you want to add to the ticket on creation.
  * Lastly, I have four (4) `keystroke tab` lines this is due to me enabling the "Bcc" field so delete one of the tabs if you don't have this enabled.
1. Once you have made all the changes that you want you will want to save and close the file.
1. Now double click on the `_AssignZendeskTicket.workflow` file once again, this time selecting "Install"

    ![automator prompt](/images/2017-01-18/automator_prompt.png)

After the service has been installed the workflow will be copied to `~/Library/Services/`. In case you need to locate the service to make changes in the future.

To use the service start a new email (or forward an existing email) in Apple Mail or Outlook. Go to the application name in the menu bar » Services » select `AssignZendeskTicket`.

![Assign ticket](/images/2017-01-18/assign_ticket.png)

If you wish to add a keyboard shortcut

1. Open **System Preferences**
1. Go to **Keyboard » Shortcuts » Services**
1. Now assign your service a keyboard shortcut. I used Command + Option + H (⌘ + ⌥ + H)
    ![Services](/images/2017-01-18/services.png)

---


Resources:  
[Updating Ticket Properties from You Inbox](https://support.zendesk.com/hc/en-us/articles/203691006-Updating-ticket-properties-from-your-inbox),  
[Automatically Inserting Text Globally](http://apple.stackexchange.com/a/87989),  
[applescript-simulating-enter-key](http://alvinalexander.com/blog/post/mac-os-x/applescript-simulating-enter-key),  
[Complete list of AppleScript key codes](http://eastmanreference.com/complete-list-of-applescript-key-codes/),  
[OS X Mavericks: Create keyboard shortcuts for apps](https://support.apple.com/kb/PH13916?locale=en_US)
