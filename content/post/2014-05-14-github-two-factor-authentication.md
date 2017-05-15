---
categories:
- tech
date: 2014-05-14T00:00:00Z
description: Setting up Two-factor Authentication on Github while using SourceTree.
keywords: github, sourcetree, git, two-factor, authentication,
modified: 2015-04-06
aliases:
- /blog/2014/05/14/github-two-factor-authentication/
tags:
- git
title: Github Two-factor Authentication with SourceTree
url: "github-two-factor-authentication/"
---

I finally got around to setting up two-factor authentication on my Github account. The process went quite smoothly, until I started to play around with  [SourceTree](http://www.sourcetreeapp.com/) and I found out that I was unable to push commits to a git repo.

---

### SourceTree error
The error message that I was receiving seemed pretty generic at the time. Besides I knew I was typing my Github password correctly, so that could not be the issue. In hindsight not realizing the two-factor authentication (2fa) was the problem immediately was pretty stupid. The solution to this error is to login with a One Time Password (OTP)  token _not_ your normal Github password. If you do use the wrong password you will receive the follow error message.  
![Error](/images/2014-05-14/login_error.png)



{{% alert info %}}
**Note:** If you use the official <a href="https://mac.github.com">GitHub app</a> you will not run into a login error because their app uses the GitHub API for authentication.
{{% /alert %}}


Luckily Github has made creating a OTP quite easy once you know what you are looking for. It is recommended practice to use one token per application. This means if I ever need to reject a token it will only effect the one version of SourceTree on one device.

Below are the steps needed to create your OTP token and re-add your Github account in SourceTree.

### Setting up the OTP
To create the OTP, use the following [link](https://github.com/settings/tokens). Click on "Generate New Token".  
![Creating an OTP](/images/2014-05-14/otp.png)

Give your OTP a Token description. Make sure at least the "repo" and "public_repo" options are checked. Click "Generate token".  
![Token permissions](/images/2014-05-14/new_token.png)

### Configuration for SourceTree
If you already have SourceTree setup, you will need to edit your account password for GitHub. You can accomplish this by opening the Bookmarks window and clicking on the "Hosted Repositories" button.  
![Bookmarks Window](/images/2014-05-14/bookmarks.png)

Now you need to click on "Edit Accounts..." so you can select your Github account and make modifications.  
![Hosted Repositories](/images/2014-05-14/hosted_repositories.png)

Click on "Set Password".  
![Github Acct Options](/images/2014-05-14/github_options.png)

In the Authenticate window make sure and use your newly generated OTP token as your password. I recommend saving the password in your keychain.  
![Authenticate Window](/images/2014-05-14/authenticate.png)

---

Articles: [atlassian KB](https://confluence.atlassian.com/display/SOURCETREEKB/Two-Factor+Authentication+%282FA%29+with+GitHub+in+SourceTree),
[Ryan Sechrest](http://ryansechrest.com/2013/12/sourcetree-github-must-specify-two-factor-authentication-otp-code/)  

Updated: May 15th, 2014 - Add KB link from atlassian. Per {{< tweet 466879257864847360 >}}
