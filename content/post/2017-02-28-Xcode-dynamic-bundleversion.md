---
categories:
- tech
date: 2017-02-28
title: Xcode Dynamic BundleVersion
modified:
keywords:
- Xcode
- Swift
- git
- CFBundleVersion
tags:
- xcode
- swift
toc: false
---

So lets start with I'm not a developer. I won't pretend to be one but I do find development work quite interesting. One thing I'm trying to get into is Swift but even the small steps lead me to realize how large the Apple ecosystem is. Cocoa, Swift, Xcode, System frameworks, finding the right documentation, etc. The process of connecting the dots takes a bit of time as you might imagine.

One of the first tasks I wanted to do was auto update the CFBundleVersion whenever I added a commit via git. This is a [solved problem](http://tgoode.com/2014/06/05/sensible-way-increment-bundle-version-cfbundleversion-xcode/) but I didn't see any videos covering this topic so I thought I'd make one. Hat tip to [Tim Sutton](https://twitter.com/tvsutton) as I stole his script that he added to [Imagr](https://github.com/grahamgilbert/imagr/pull/26/files).

{{< youtube nDKtiHfBlYA >}}

<br>
The script:

```bash
# based on http://tgoode.com/2014/06/05/sensible-way-increment-bundle-version-cfbundleversion-xcode
if git rev-parse --is-inside-work-tree 2> /dev/null > /dev/null; then
echo "Setting CFBundleVersion to Git rev-list --count"
build_number=$(git rev-list HEAD --count)
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $build_number" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
else
echo "Not in a Git repo, not setting CFBundleVersion"
fi
```


# Articles:
* http://tgoode.com/2014/06/05/sensible-way-increment-bundle-version-cfbundleversion-xcode/
* https://github.com/grahamgilbert/imagr/pull/26/files
