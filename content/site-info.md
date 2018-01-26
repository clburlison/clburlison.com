---
title: Site Information
modified: "01-26-2018"
aliases:
- /about/site-info/
comments:       false
showMeta:       false
showActions:    false
showPagination: false
showSocial:     false
showDate:       false
---

Odds are if you have ended up on this site you found something interesting
or helpful. The following information gives insight on the tools and
technologies used on this site.

# Nerd facts

<article>

<details>
  <summary>This website is built using <u><a target="_blank" href="https://gohugo.io/">Hugo</a></u>.</summary>
  <p>Hugo is the backbone of this site. It is a powerful engine that allows me to write plain text files. Hugo then handles converting all the css, code blocks, html snippets, etc. into a pretty static web site. Since this site is static it allows me to quickly modify sections. Also, it is quite fast to serve static pages so response time should always be pretty good. Prior to Hugo I was using the static generator <a target="_blank" href="https://jekyllrb.com/">Jekyll</a>. </p>
</details>
<details>
  <summary>All content is written in <u><a target="_blank" href="http://en.wikipedia.org/wiki/Markdown">Markdown</a></u>.</summary>
  <p>If you are not familiar with markdown it allows me to write plain text in such a way that an engine will be able to transform that text into a rich format like html. All this means I can write using any text editor I want (even vim if I so please) and create content without having to write all those dirty html tags. How many times have you forgotten to add that forward slash on a end tag resulting in a malformed page? </p>
</details>
<details>
  <summary>Hosting for this website is by <u><a target="_blank" href="https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html">AWS S3</a></u>.</summary>
  <p>AWS S3 allows me to dumb a bunch of files into a bucket and easily share the static website. Github pages makes hosting a website easy. Hosting a website via Apache, Nginx, or IIS isn't rocket science however by using AWS it's dirt cheap and no server cost. </p>
</details>
<details>
  <summary>Site code can be found in the follow repo <u><a target="_blank" href="https://github.com/clburlison/clburlison.com">clburlison.com</a></u>.</summary>
  <p>I <3 Github. Git is such a nice version control system to work with. All content is publicly accessible for two reasons: 1) I want others to be able to see how this site was created. 2) Sharing this code means if you find something you like you are able to copy/paste working code. With that said please don't blatantly steal written work of mine without crediting me. </p>
</details>
<details>
  <summary>Content delivery network provided by <u><a target="_blank" href="https://aws.amazon.com/cloudfront/">CloudFront</a></u>.</summary>
  <p>CloudFront connects into the rest of the AWS ecosystem really easily. This keeps the cost of this website down since everyone will hit the cached content instead of the S3 bucket directly, which also helps with scale. It also means you get a nice and fast response time. </p>
</details>
<details>
  <summary>Content ideas are tracked via <u><a target="_blank" href="https://github.com/clburlison/clburlison.com/issues">Github Issues</a></u> and <u><a target="_blank" href="https://waffle.io/clburlison/clburlison.com">Waffle.io</a></u>.</summary>
    <p><a href="https://waffle.io/clburlison/clburlison.com"><img src="https://badge.waffle.io/clburlison/clburlison.com.svg?columns=all" alt="Waffle.io status badge"></a><br>
    At any given time I might have 20 plus ideas or topics that I wish to write about. To keep track of these various ideas I create a Github issue. This allows me to add links or any notes that might be needed for me to understand what I wanted to write about. That means some of my issues might not make sense to you. Waffle.io just gives me a visual to keep me working on one or two topics at a time. The "Ready" tag is for content I am planning on writing about soon. The "In Progress" tag is for content ideas I'm working on right now.<br><br> With that said if you ever have any questions or would like for me to write about a specific topic feel free to create an issue and I will certainly think about it.  </p>
</details>
<details>
  <summary>The theme for this website was created by <u><a target="_blank" href="https://github.com/kakawait">Thibaud Lepretre</a></u>.</summary>
  <p>The theme <a target="_blank" href="https://github.com/kakawait/hugo-tranquilpeak-theme/">tranquilpeak</a> is a gorgeous responsive theme for Hugo blog framework.</p>
</details>
<details>
  <summary>CircleCI builds my website <u><a target="_blank" href="https://circleci.com/gh/clburlison/clburlison.com">Build History</a></u>.</summary>
  <p><a href="https://circleci.com/gh/clburlison/clburlison.com"><img src="https://circleci.com/gh/clburlison/clburlison.com.svg?style=svg" alt="Build Status"></a> <br>
    CircleCI is a continuous integration application that pulls the contents of my Github repo on every commit I submit to the source branch. The purpose of using CircleCI to build my Hugo site is so I no longer have to manually manage any of the master branch, which is where all of the html files are stored. Other benefits to using CircleCI include the ability to have a running record of all my builds. This allows me to know at any given point in time when I broke something. In the past this site used Travis CI however CircleCI is way faster.</p>
</details>
<details>
  <summary>User tracking is enabled and provided by <u><a target="_blank" href="https://www.google.com/analytics/">Google Analytics</a></u>.</summary>
  <p>Google rules the world. I do enable user tracking simply for the purpose of knowing viewership. Knowing which articles are the most popular help me when deciding what content I want to write about next.</p>
</details>
<details>
  <summary>Site comments are provided by <u><a target="_blank" href="https://disqus.com">Disqus</a></u>.</summary>
  <p>Disqus is a free service. It is widely used. It also allows users to login via different social media sites. What is not to like?</p>
</details>

</article>

<br>

# Why Static?
I really dislike CMS websites. When I see blogs that have code snippets that are a pain to view I cry a little. Sure Hugo and Jekyll are harder to get the way you want. Customizing it can be very time consuming and confusing. However, the payoff is full control and ultimate flexibility. Also, the extra overhead on my plate to create this website the way I have is both fun and I believe provides the best experience. But what do I know...I just fix Macs.

I have tried both Blogger and Wordpress prior to finally getting latched onto Jekyll (now Hugo). You won't find those sites...
