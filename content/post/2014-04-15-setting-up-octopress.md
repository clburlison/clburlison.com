---
categories:
- tech
date: 2014-04-15T00:00:00Z
description: Go over customizing octopress and installing plugins.
keywords: octopress, markdown, customize, plugins, setup
modified: 2014-04-21
aliases:
- /blog/2014/04/15/setting-up-octopress/
tags:
- octopress
title: Setting up octopress
---

{{% alert info %}}
**Notice:** This site is no created using Octopress. I have since moved to a plain Jekyll setup. Content exists mostly for reference and will not be updated in the future.
{{% /alert %}}


---

Setting up a blog can be a time consuming task. Setting up a blog that is created from static (markdown) files can be much more time consuming. In this post, I list references to most of the custom changes that were made to this site.

---

## This is not a setup guide...
...the internet has many really well outlined guides that do walk you through setting up Octopress. Since that is the case, I will instead list a few of the most helpful resources that I have found while attempting to setup Ocotpress. Please also note that the Octopress [Documentation](http://octopress.org/docs/) is the best source of information but it might not be the easiest to understand at first glance.

**_Disclaimer what works for me might not work for you. At the time of this writing release v3.0.0.rc.7 all of the following references do work. This is definitely not the faint of heart. Something down the line will break and you will have to troubleshoot the error._

### Getting Started
The most important reference, a get started guide that will walk you through the initial installation.  
Article: [Getting Started with Octopress](http://webdesign.tutsplus.com/tutorials/getting-started-with-octopress--webdesign-11442)

### Changing the color
I did not find any themes that I liked so I used this article to change the colors. This article establishes the easiest way to customize Octopress with the main drawback being the least amount of visual change.  
Article: [How to Customize Your Octopress Theme](http://aijazansari.com/2012/08/27/how-to-customize-octopress-theme/index.html)




## Plugins

### Monthly Archive Sidebar
The setup for this plugin is really well done in the help file for the repo so I shall direct you there.  
![Monthly Archives](/images/2014-04-15/monthly_archives.png)  
Article: [Github-Plugin](https://github.com/rcmdnk/monthly-archive)

### Categories
The setup for this plugin is really well done in the help file for the repo so I shall direct you there.
Article: [Github-Plugin](https://github.com/matthiasbeyer/jekyll_group_categories)

### Tag Cloud (sidebar)
The setup for this plugin is really well done in the help file for the repo so I shall direct you there.  
![Tag Cloud](/images/2014-04-15/tag_cloud.png)  
Article: [Github-Plugin](https://github.com/tokkonopapa/octopress-tagcloud)

If you would like your tags to show up in a vertical view visit the following link.  
Article: [Tags vertical view](http://www.narga.net/improve-octopress-advanced-tweaks-tips/)



## Custom 404 Page
I was unable to find much information about 404 Errors for Octopress. After some googling, I found out it is super easy to add a custom 404 page to Octopress. In your config.ru file, you add the following code:
```bash
not_found do
  send_sinatra_file('404.html') {"Sorry, I cannot find #{request.path}"}
end
```
To create the page, make a new file named 404.markdown in your /sources directory. Now, write your own 404 Error Page then deploy your website.  
Article: [Custom 404 Page](http://www.narga.net/improve-octopress-advanced-tweaks-tips/)

---

Resources:
[Markdown Cheat Sheet](http://warpedvisions.org/projects/markdown-cheat-sheet.md) ,
[Octopress Cheat Sheet](http://biancarelli.org/blog/2013/05/14/octopress-cheat-sheet)
