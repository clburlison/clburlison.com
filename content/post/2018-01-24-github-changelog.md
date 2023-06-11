---
title: "Github Changelog"
date: 2018-01-24T17:01:00-06:00
categories:
- tech
tags:
- github
- docker
keywords:
- tech
- github
- changelog
---

I recently ran into a really awesome [ruby project][chlog_project] for
creating Github Changelog files automatically. These files make it very easy
for community members to quickly get up to speed and follow the
development process of a project.
<!--more-->

The best aspect to this is how simple it really is.

```bash
docker run -it --rm -v "$(pwd)":/usr/local/src/your-app \
    clburlison/github-changelog-generator \
    -u clburlison -p pinpoint \
    -t ${CHANGELOG_GITHUB_TOKEN}
```

That is all I run to get a nicely formatted Changelog file for my project. You
can view a full sample in my [clburlison/pinpoint][pinpoint_chlog] repo. If you
create tags, releases, milestones, and properly triage issues with labels the
results will be very useful.

{{< image classes="fancybox center clear" src="/images/2018-01-24/changelog_sample.png" title="Sample Changelog" >}}

# Setup

Before you can use the project you will want to:

1. Install [docker](https://docs.docker.com/engine/installation/)
1. Create a [github token][gh_token]

Then run the above command making sure to change the strings after the
`-u` and `-p` flags. Once all the requests are done a nicely formatted
Changelog file will be written in your current working directory.

# Note

Currently, I'm hosting my own docker container of the
[skywinder/github-changelog-generator][chlog_project] repo while the
maintainers decide what [namespace][chlog_591] they plan on using.

[pinpoint_chlog]: https://github.com/clburlison/pinpoint/blob/master/CHANGELOG.md
[chlog_591]: https://github.com/skywinder/github-changelog-generator/issues/591
[chlog_project]: https://github.com/skywinder/github-changelog-generator/
[gh_token]: https://github.com/skywinder/github-changelog-generator#github-token
