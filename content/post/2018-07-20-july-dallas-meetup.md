---
title: "2018 Dallas Apple Meetup"
date: 2018-07-20
categories:
- tech
tags:
- macOS
keywords:
- profiles
- profilecreator
- preferences
---

For the July Dallas Apple Meetup I did a talk on macOS preferences and
profiles. My slide deck, scripts, and reference links to all the tools
I used in the talk can be found below:
<!--more-->

## Links

* [Slides](/talks/20180819-PreferencesPreso.pdf)
* [Greg Neagle's FancyDefaults](https://gist.github.com/gregneagle/010b369e86410a2f279ff8e980585c68)
* [Armin Briegel's PrefsTool](https://github.com/scriptingosx/PrefsTool)
* [clburlison's sample repo of profiles](https://github.com/clburlison/profiles)
* [ProfileCreator](https://github.com/erikberglund/ProfileCreator)
* [ProfileManifests](https://github.com/erikberglund/ProfileManifests)


## CFPreferences one liner

One liner for checking preference value via python CFPreferences

```bash
/usr/bin/python -c "from Foundation import CFPreferencesCopyAppValue; print CFPreferencesCopyAppValue('HowToCheck', 'com.microsoft.autoupdate2')"
```

## Scripts from the talk

All scripts can be viewed/downloaded from the following gist:
[scripts](https://gist.github.com/clburlison/e482d5b1d48da651bb2615056c4da974)

### Running the Go sample

For anyone wanting to play with the go example:

1. Download go `brew install go` or [https://golang.org/dl](https://golang.org/dl)
1. Copy the `main.go` file from the gist above
1. Compile the file with `go build main.go`
1. Run the go binary with `./main`

## MAU ProfileCreator manifest

During the talk we mentioned a manifest for Microsoft AutoUpdate (MAU). The
pull request with the contents of that manifest can be found:
[ProfileManifests #3](https://github.com/erikberglund/ProfileManifests/pull/3)
