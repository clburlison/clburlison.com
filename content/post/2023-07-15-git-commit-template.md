---
title: "Git Commit Template"
date: 2023-07-15T15:11:31-05:00
categories:
  - tech
tags:
  - git
keywords:
  - git
  - git commit template
  - git commit
---

Nine years ago, I started using source control. [GitHub](https://github.com) made it extremely easy to get started, and [git](https://git-scm.com/) has plenty of external documentation on the internet. Using a git commit template was one of the highest quality-of-life features I implemented, but why?

## What is a commit template?

First, let us get started with what a commit template is. After you type `git commit`, a template file you define is displayed in your editor. The concept is pretty basic, but the result is a helpful reminder to:

1. Be descriptive
2. Include a useful summary
3. Be consistent

It is all about organizing your changes, and after practicing for years, that muscle is basically on autopilot for me. It doesn't box you into one style that can never change. It is applying guidelines that are quite useful.

## Why use a commit template?

You aren't writing descriptive messages for the current you. These are for your future self and your teammates. One of the hardest things to review is a large pull request with bad or non-descriptive commit messages. Below is an example of commits I previously wrote for a private project.

{{< figure src="/images/2023-07-15/example_commits.png" alt="Github screenshot of example commit messages" title="Example commit messages" align=center height=700 >}}

On review, it is clear what each commit is changed. After multiple weeks, I can go back and find exactly where specific changes occurred, and this same concept has applied to projects that I have not touched in years.

## My template

The template I use and basic install instructions are from [@adeekshith](https://gist.github.com/adeekshith/cd4c95a064977cdc6c50) on GitHub. It is short, easy to understand, and covers 99% of the commit messages I have written over the years. Highly recommend checking it out if you aren't already using a git commit template!

{{< gist adeekshith cd4c95a064977cdc6c50 ".git-commit-template.txt" >}}
