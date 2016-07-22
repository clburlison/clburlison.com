---
title: "AutoWake"
modified:
tags:
  - osx
excerpt: "Dive into Apple's Energy Saver options with a focus on scheduling."
categories:
  - draft
---


Apple has some pretty impressive energy savings options built into macOS. Most of these options are tucked nicely inside of the Energy Saver pane of System Preferences.

![Energy Saver Panel]({{ site.url }}{{ site.baseurl }}/images/2016-07-12/EnergySaver.png)

However System Preferences actually limits some of your choices and does not scale. As such lets look at managing the scheduling in a manner that does scale. We can script the `pmset` tool which is great for one off cases while our other option is to use a profile. You can _technically_ manage the `/Library/Preferences/SystemConfiguration/com.apple.AutoWake` preference file however that is strongly frowned upon as better method exist.




```

Weekdays values

    1 - Monday
    2 - Tuesday
    4 - Wednesday
    8 - Thursday
    16 - Friday
    32 - Saturday
    64 - Sunday

Time values - is minutes after 00:00 as seconds


    60 x 4 = 240 min (4 hours)
    240 min = 4:00am


defaults read /Library/Preferences/SystemConfiguration/com.apple.AutoWake
{
    RepeatingPowerOff =     {
        eventtype = {restart, sleep, shutdown};
        time = 90;
        weekdays = 127;
    };
    RepeatingPowerOn =     {
        eventtype = wakepoweron;
        time = 60;
        weekdays = 127;
    };
}
```

---

Links:  
[OS X Yosemite: Schedule a time for your Mac to turn on or off or go to sleep](https://support.apple.com/kb/PH18583),  
[OS X: Setting a startup or shut down time](https://support.apple.com/en-us/HT201988),  
