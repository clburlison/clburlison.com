---
layout: post
title: "Github Two-factor Authentication with SourceTree"
modified: 2015-04-06
comments: true
published: true
keywords: github, sourcetree, git, two-factor, authentication,
description: Setting up Two-factor Authentication on Github while using SourceTree.
categories: 
- github 
- sourcetree 
- git
redirect_from:
  - /blog/2014/05/14/github-two-factor-authentication/
---
I finally got around to setting up two-factor authentication on my Github account. The process went quite smoothly, until I started to play around with  [SourceTree](http://www.sourcetreeapp.com/) and I found out that I was unable to push commits to a git repo.

---

###SourceTree error
The error message that I was receiving seemed pretty generic at the time. Besides I knew I was typing my Github password correctly, so that could not be the issue. In hindsight not realizing the two-factor authentication (2fa) was the problem immediately was pretty stupid. The solution to this error is to login with a One Time Password (OTP)  token _not_ your normal Github password. If you do use the wrong password you will receive the follow error message.  
{% img /images/2014-05-14/login_error.png SourceTree error %}

<div class="note info">
  <h5>Note</h5>
  <p>If you use the official <a href="https://mac.github.com">GitHub app</a> you will not run into a login error because their app uses the GitHub API for authentication.</p>
</div>

Luckily Github has made creating a OTP quite easy once you know what you are looking for. It is recommended practice to use one token per application. This means if I ever need to reject a token it will only effect the one version of SourceTree on one device.

Below are the steps needed to create your OTP token and re-add your Github account in SourceTree.

###Setting up the OTP
To create the OTP, use the following [link](https://github.com/settings/tokens). Click on "Generate New Token".  
{% img /images/2014-05-14/otp.png Creating an OTP %}

Give your OTP a Token description. Make sure at least the "repo" and "public_repo" options are checked. Click "Generate token".  
{% img /images/2014-05-14/new_token.png Token permissions %}

###Configuration for SourceTree
If you already have SourceTree setup, you will need to edit your account password for GitHub. You can accomplish this by opening the Bookmarks window and clicking on the "Hosted Repositories" button.  
{% img /images/2014-05-14/bookmarks.png Bookmarks Window %}

Now you need to click on "Edit Accounts..." so you can select your Github account and make modifications.  
{% img /images/2014-05-14/hosted_repositories.png Hosted Repositories %}  

Click on "Set Password".  
{% img /images/2014-05-14/github_options.png Github Acct Options %}

In the Authenticate window make sure and use your newly generated OTP token as your password. I recommend saving the password in your keychain.  
{% img /images/2014-05-14/authenticate.png Authenticate Window %}

---

Articles: [atlassian KB](https://confluence.atlassian.com/display/SOURCETREEKB/Two-Factor+Authentication+%282FA%29+with+GitHub+in+SourceTree), 
[Ryan Sechrest](http://ryansechrest.com/2013/12/sourcetree-github-must-specify-two-factor-authentication-otp-code/)  

Updated: May 15th, 2014 - Add KB link from atlassian. Thanks [@kieransenior](https://twitter.com/kieransenior/statuses/466879257864847360).
