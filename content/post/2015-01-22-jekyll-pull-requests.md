---
categories:
- tech
comments: true
date: 2015-01-22T00:00:00Z
excerpt: Add a Github pull request feature to your Jekyll website.
aliases:
- /blog/2015/01/22/jekyll-pull-requests/
tags:
- jekyll
title: Jekyll Pull Requests
---


{{% alert danger %}}
**Outdated:** I am no longer using this process nor is the original author that I was linking to. He has an archive of his post [here](https://github.com/brunosan/brunosan.eu/blob/main/_posts/blog/2012-07-01-jekyll-pull-requests.md).
{{% /alert %}}

Github is awesome. Jekyll is awesome. Travis-ci is awesome. Prose.io is awesome. And now...you can be awesome as well. Open Source is a fantastic but it is not without its drawbacks. One of the biggest drawbacks to using a static website like this site is the lack of an easy way to update posts. Sometimes I make a typo or want to add information to a already created post. Unfortunately, this would require me to use my laptop and only my laptop to modify the markdown files, build the website, and upload the new static files of the website to Github.

With some love and lots of error in trial, I was able to modify this site so that I can create changes from any web browser. Mostly thanks to [Saepe](http://brunosan.eu/2012/07/01/jekyll-pull-requests/). In fact **anyone** can send an edit to a post, from there a Github pull request is created, I can review the request and if I agree with the change can directly add your change. That is what the

<a id="pull-request-btn" class="btn btn-danger" href="">Send edit request</a>  button at the bottom of this page does.


{{% alert info %}}
**Note:** Now is a time to state that if you are uncomfortable with the Markdown language you might not understand all the syntax of these posts. Which might make editing the page difficult. If you feel uncomfortable feel free to add a comment below and I can make the change.
{{% /alert %}}

# How to submit a change
1. When you see a post you want to edit, click on “Send edit request” button at the bottom of the page. <a id="pull-request-btn" class="btn btn-danger" href="">Send edit request</a>

2. You need a free [Github](https://github.com) account. If you are a developer you probably have one, so just login. If not, you can create one in a breeze.

	![](/images/2015-01-22/2-signin.png)

3. Once logged in you will need to give Prose permission to use your Github credentials.

	![](/images/2015-01-22/3-prose-permission.png)

4. After login you will land on a page like below. Edit the text. Then click *Save* once your done.

	![](/images/2015-01-22/4-edit-page.png)

5. You will see what you have changed, and you can add a commit message or leave the default message. Then click “Submit Change Request”.

	![](/images/2015-01-22/5-send-pull-request.png)

Done!

# How does it work?
Honestly I am using Saepe's method completely so I will direct you to [here](http://brunosan.eu/2012/07/01/jekyll-pull-requests/).

---

Articles:  
[Issue #1](https://github.com/clburlison/clburlison.github.io/issues/1),  
[Jekyll Pull Requests](http://brunosan.eu/2012/07/01/jekyll-pull-requests/),  
[Martin Fenner](http://blog.martinfenner.org/)
