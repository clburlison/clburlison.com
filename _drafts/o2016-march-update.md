
*** THIS IS A WORK IN PROGRESS ***


O2016 - March Admin Update


An update for Mac admins by a Mac admin. 

# Summary
Not much has changed since January. Not actually true, lots of updates have been made. Many bugs have been fixed. However at this point most issues are end-user related. Both a good and bad thing depending on how you look at it. On the positive side my job is mostly done. 


# The future of Office for Mac:
Current, O365 and the Retail version of Office 2016 are pretty similar. In the future this will change, new features will be added to O365 based license that retail


> I guess I should comment on the VL licensing (and btw - it says nothing about my pay grade!). As mentioned several times before here, we use runtime licensing, so although we’ll keep pushing the same physical update packages to all users every month, at some point you’ll find that some fancy new feature is only available if you’ve activated with an O365 subscription. i.e. the code path will be dark for VL/Retail. This exists today on a pretty small scale, but you’ll start to see more divergence as the year goes on. It’s very true that Mac Office is still playing catch-up with Windows Office, and we’re trying to bring the feature-set closer together - however, those catch-up features may only be available if you’re an O365 subscriber. At some point in the future, you ​*may*​ see us take all the existing O365 features and make them available in a VL/Retail build called Office 2018. I say ‘may’ because it really hasn’t been decided - it’ll all depend on what the market does over the next couple of years. However, either way, we have to keep pushing updates monthly to stay fresh and relevant.
> 
> https://macadmins.slack.com/archives/microsoft-office/p1454020539000959

# AutoPkg

# VL Serializer 2.0

The changes and enhancements are as follows:
1.    VL Serializer 2.0 is now a meta package that bundles both the Microsoft Office Setup Assistant and Licensing Helper. This enables a volume license plist to be created prior to installing any of the Office 2016 apps.
2.    VL Serializer 2.0 removes any existing retail plist before attempting to create a new file. This allows the tool to always create a ‘correct’ copy of the license plist regardless of what was previously installed.
3.    VL Serializer 2.0 creates version-independent non-transferrable volume license keys that cannot be copied and used on other machines.
4.    VL Serializer 2.0 writes a version identifier into the licensing plist for easy administrator identification.


https://macadmins.slack.com/archives/microsoft-office/p1455832462000887


# Template Files
For corps that use template files here is where to store them:

From the folks at Microsoft: Where to store system-wide Office 2016 Template files.

From any user's home folder, copy...

~/Library/Group Containers/UBF8T346G9.Office/User Content.localized (file extension is hidden)

into...

/Library/Application Support/Microsoft/Office365/

Add template files here and they should appear for all Office 2016 users using File > New From Template.


Bill
https://macadmins.slack.com/archives/microsoft-office/p1446663948002207


---

# Personal thoughts
People keep asking for these however I've yet to understand why. Anyways not much has changed in terms of deployment since my last post in January. From an administration point of view I still disable MAU auto-checking for updates using a profile. I still deploy the latest SKUless installer package via munki. Then followup with the VL Serializer package as an `update_for`.    

Wait a minute you said you disabled the installation of MAU with a choice xml. Yeah that use to happen...until I simply stopped caring.

### Delta update
They are now out in full production. For management with Munki, I see no fit when using one of the full installers. The use case is just too messy. However, if you do manage to install each application using one of the standalone installers delta updates can be use. They still require some admin work though. 

From my tests they work a little like this:
1. Install Word, Excel, Outlook: all version 15.18.0
1. When version 15.19.1 was released instead of using a combo update or the full standalone installer you send out the three delta updates. You make them `update_for` the standalone package.
1. When 15.20 comes out same process however you set as a update for with a requirement of 15.19.1. This currently will only "save" you a few megabytes. However in the future it Microsoft could make these delta updates even smaller.

^^ With all of that said. From a management standpoint I can't recommend them. There are way easier ways to push updates to your fleet. Even those will small WAN pipes would be better off looking into local management repos. Casper has this built in and Munki can be extended to do so pretty easy.

