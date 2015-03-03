---
layout: page
title: "gifs & random images"
date: 
modified:
excerpt:
tags: []
image:
  feature:
permalink: /gifs/
---


{% directory path: g %}
  <a href="{{ file.url }}" > {{ file.slug }} </a>{% unless forloop.last %}, {% endunless %}
{% enddirectory %}