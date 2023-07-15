---
title: "macOS Wifi Scanning"
date: 2018-03-09
categories:
  - tech
tags:
  - macOS
  - python
keywords:
  - tech
  - python
  - pyobjc
  - apple
  - wireless
  - CoreWLAN
  - CWInterface
showtoc: true
---

Have you ever just wanted to see all the wireless networks around you? Apple
provides quite a few tools to help do this out of the box including a really
nice command line tool called `airport`. But what if there was more...

<!--more-->

# Airport

A common utility known by many mac users is `airport`. If you have never heard
of `airport` you can find the binary at:

```bash
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport
```

and if you check the help page you can see:

```bash
Supported arguments:
 -c[<arg>] --channel=[<arg>]    Set arbitrary channel on the card
 -z        --disassociate       Disassociate from any network
 -I        --getinfo            Print current wireless status, e.g. signal info, BSSID, port type etc.
 -s[<arg>] --scan=[<arg>]       Perform a wireless broadcast scan.
				   Will perform a directed scan if the optional <arg> is provided
 -x        --xml                Print info as XML
 -P        --psk                Create PSK from specified pass phrase and SSID.
				   The following additional arguments must be specified with this command:
                                  --password=<arg>  Specify a WPA password
                                  --ssid=<arg>      Specify SSID when creating a PSK
 -h        --help               Show this help
```

One of the useful flags is `--scan` to look for current wireless networks
around you. In addition you can add the `--xml` flag to output machine
parsable xml data.

```bash
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -s --xml
```

This will output ~120 lines of data per wireless network in the local vicinity.
In most cases, you will not care about all of the data returned but it is
nice to know you can access it programmatically if the need came up.

# Airport Bug

Recently, I ran into a nice [bug] with `airport` on macOS 10.13 (this might
affect older OS's I did not test).

When you run `airport` with the `--xml` flag the command would fail to output
properly formatted xml data. I did not spend a bunch of time trying to find
the root issue since I wanted a working solution now and knew any potential
bug fixes would take 3-18 months. One idea is that HP printers are
broadcasting a SSID with unsafe characters, or maybe the `airport` command
chokes when scanning in a highly saturated area.

You can see the result of a failed run below, without proper ending tags:

```xml
<dict>
    <!-- removed for brevity-->
    <key>SSID_STR</key>
    <string>DIRECT-54-HP ENVY 4520 series</string>
    <key>WPS_PROB_RESP_IE</key>
    <dict>
        <key>IE_KEY_WPS_AP_SETUP_LOCKED</key>
        <true/>
        <key>IE_KEY_WPS_CFG_METHODS</key>
        <integer>0</integer>
        <key>IE_KEY_WPS_DEV_NAME</key>
        <string>DIRECT-54-HP ENVY 4520 series</string>
        <key>IE_KEY_WPS_DEV_NAME_DATA</key>
        <data>
        RElSRUNULTU0LUhQIEVOVlkgNDUyMCBzZXJpZXM=
        </data>
        <key>IE_KEY_WPS_MANUFACTURER</key>
        <string>HP</string>
        <key>IE_KEY_WPS_MODEL_NAME</key>
        <string>ENVY 4520 series
```

# CoreWLAN

Since `airport` was no longer doing what I needed I started to wonder how
else I could get this data. macOS apps like [WiFi Explorer] and [NetSpot] are
able to obtain this wireless data so I was hopeful Apple exposed this via a
framework. Luckily they do and it is call [CoreWLAN]. A topic of the
CoreWLAN framework is [CWInterface] which included a scan method that was just
want I needed.

Looking up the [declaration] for the scan function you will see:

```objectivec
- (NSSet<CWNetwork *> *)scanForNetworksWithName:(NSString *)networkName
                                  includeHidden:(BOOL)includeHidden
                                          error:(out NSError * _Nullable *)error;
```

So now I just needed to convert that to python for my use case.

```python
import objc

bundle_path = '/System/Library/Frameworks/CoreWLAN.framework'
objc.loadBundle('CoreWLAN',
                bundle_path=bundle_path,
                module_globals=globals())

iface = CWInterface.interface()
iface.scanForNetworksWithName_includeHidden_error_(None, True, None)
```

and a sample output from the above code:

```python
({(
    <CWNetwork: 0x7f927850e8e0> [ssid=ATT555g6d6, bssid=XX:XX:XX:XX:XX:XX, security=WPA2 Personal, rssi=-87, channel=<CWChannel: 0x7f927b45d100> [channelNumber=1(2GHz), channelWidth={20MHz}], ibss=0],
    <CWNetwork: 0x7f927850ed00> [ssid=Homer-Guest, bssid=XX:XX:XX:XX:XX:XX, security=Open, rssi=-50, channel=<CWChannel: 0x7f927b473790> [channelNumber=6(2GHz), channelWidth={20MHz}], ibss=0],
    <CWNetwork: 0x7f927b440730> [ssid=MW-HM1, bssid=XX:XX:XX:XX:XX:XX, security=WPA2 Personal, rssi=-85, channel=<CWChannel: 0x7f927b442660> [channelNumber=11(2GHz), channelWidth={20MHz}], ibss=0],
<!-- removed for brevity-->
)}, None)
```

So maybe not quite as pretty as the xml output from `airport` but it gives us
many of the important values we would normally want: SSID, BSSID, Security,
and RSSI. Not as obvious but that CWChannel also contains a bunch of
potentially useful data. An added benefit it does not fail when trying
to output the data.

# Converting to PyOjbC

In the above section I skipped over converting the Objective-C code to Python.
However in the past multiple community members have helped me with this. I
figured here I would break down how I made the conversion, knowing that most
people reading this are Mac Admins and some might not have experience with
Objective-C and the PyObjC bridge.

At this point, I recommend launching an interactive `/usr/bin/python` session
and pasting these commands as we go. Each section from here on out is additive
and requires the code above it to run. This way you can see the output of each
step as we progress. No seriously this section is designed for user interaction
open up your shell!

{{% alert info %}}
First tip: Always make sure you are viewing Apple documentation under the
'objective-c' language if you are planing on using PyObjC.
{{% /alert %}}

## Import

Lets start with the base import code of the CoreWLAN framework. Honestly, I
learned this from years of looking at sample code from [Frogor]. If you wanted
to replicate this yourself you would need to review the [PyObjC] documentation.

```python
import objc

bundle_path = '/System/Library/Frameworks/CoreWLAN.framework'
objc.loadBundle('CoreWLAN',
                bundle_path=bundle_path,
                module_globals=globals())
```

The `objc` module ships with [PyObjC] so as long as you use the stock system
python located at `/usr/bin/python` you can use this code on any mac right
out of the box.

At this point, we have direct access to all of the classes in the [CoreWLAN]
Framework.

## Help

Go ahead and view the help:

```python
help(CWInterface)
```

Go ahead and scroll through the help menu using `j` & `k`. Here you can see all
the methods that might be available. Once you are done scanning type `gg`
`<enter>` to go to the top of the help menu followed by `/disassociate` `<enter>`
to search the document for the string "disassociate". Lastly type, `q` to
exit the help menu.

## Instantiation, disassociate, & power cycling

Now lets try calling the disassociate method:

```python
CWInterface.disassociate()
```

{{% alert info %}}
Note: All we did was add a period and the parentheses to call the method.
{{% /alert %}}

Hopefully you got back the following error:

```python
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: Missing argument: self
```

Strange, right? The option was in our help list. So why didn't it work? Lets
go back to the [CWInterface] documentation. You see that important warning message
up top? Here I'll paste it below:

{{% alert warning %}}
**Important**

Do not instantiate interface objects directly. Instead, use interface objects
vended by a [CWWiFiClient](https://developer.apple.com/documentation/corewlan/cwwificlient?language=objc)
instance via the [interface](https://developer.apple.com/documentation/corewlan/cwwificlient/1512352-interface?language=objc)
method or one of its relatives. This enables your app to adopt App Sandbox
even when it uses CoreWLAN without the need for any special exceptions.
Directly instantiating interface objects causes low level access to system
sockets, which by default is not allowed in a sandboxed environment.
{{% /alert %}}

So the positive is we don't care about Sandboxing since we are in python land.
This also means we can be lazy and instantiate the deprecated interface. IE:

```python
iface = CWInterface.interface()
```

Now lets try to disassociate:

```python
iface.disassociate()
```

If you check your airport status in the menu bar you should no longer be
connected to a wireless network. Now lets power cycle to rejoin.

```python
iface.setPower_error_(False, None)
iface.setPower_error_(True, None)
```

Isn't python fun? Yes this had nothing to do with the section but we are
learning here.

## Scanning

Lets get onto the scanning so lets revisit the objective-c code:

```objectivec
- (NSSet<CWNetwork *> *)scanForNetworksWithName:(NSString *)networkName
                                  includeHidden:(BOOL)includeHidden
                                          error:(out NSError * _Nullable *)error;
```

{{% alert info %}}
The documentation on CWInterface has multiple types of scans but we will be
working with the "WithName" + "includeHidden" option. For bonus when we are
complete try using one of the other scan options.
{{% /alert %}}

Now on to the scan. I would recommend revisiting the `help(CWInterface)`
help menu and searching for "scan". Since we have an instantiation object
`help(iface)` will also work.

In the help output you should see our option:

```python
 |  scanForNetworksWithChannels_ssid_bssid_restTime_dwellTime_ssidList_error_
 |
 |  scanForNetworksWithName_error_
 |
 |  scanForNetworksWithName_includeHidden_error_
 |
 |  scanForNetworksWithParameters_error_
 |
 |  scanForNetworksWithSSID_error_
 |
 |  scanForNetworksWithSSID_includeHidden_error_
```

Go ahead and compare the output from the above help menu to the objective-c
code. To do the conversion manually the general process is: `:` to `_` and
combine all the options into one method name.

Now lets run the scan code:

```python
iface.scanForNetworksWithName_includeHidden_error_()
```

While the above code is malformed it gives a very helpful error message of:

```python
>>> iface.scanForNetworksWithName_includeHidden_error_()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: Need 3 arguments, got 0
```

You now know definitively that this method needs three arguments. They can be
found from the Apple [declaration] documentation:

- `(NSString *)networkName`
- `(BOOL)includeHidden`
- `(out NSError * _Nullable *)error`

Try substituting the name of your SSID into the first field:

```python
result, error = iface.scanForNetworksWithName_includeHidden_error_("YOUR_SSID", True, None)
print(result)
print(error)
```

## Pulling out the data

This is great but I really need to be able to pull our the ssid, rssi, and
bssid fields. Looking at the documentation we can see we are getting back an
object that looks like a `CWNetwork`? Maybe? But it is surrounded in those
`{(` squiggly brackets things and parentheses.

Let us find out for sure:

```python
type(result)
```

which outputs:

```python
<objective-c class __NSSetI at 0x7fff84009be0>
```

Not sure what that is? Well lets cheat and go back to the Apple [declaration]
documentation.

```objectivec
- (NSSet<CWNetwork *> *)
```

NSSet and CWNetwork. Still lost? That is okay. Most `NS` objects come from
[PyObjC] and due to the bridge python can natively interactive with them. So
a NSSet most closely links to a [python set] IE:

```python
from sets import Set
>>> engineers = Set(['John', 'Jane', 'Jack', 'Janice'])
```

That means we should be able to loop over it, so lets try:

```python
for i in result:
    print(type(i))
    help(i)
    break
```

Looking through the help menu you will see this `i` object is a `CWNetwork`.
This can be validated when you exit the help menu and check the type output.

To quickly finish the code lets pull out the data keys I wanted:

```python
for i in results:
    if i.ssid() is None:
        continue
    print({'RSSI': i.rssiValue(), 'BSSID': i.bssid(), 'SSID_STR': i.ssid()})
```

# Wrap up

To be completely honest the above CoreWLAN sample is a very straight forward
example. Some other PyObjC code can become very complex very quickly. If this
was your first time interacting with PyOjbC hopefully the above walk through
helped guide you through the weeds. The above process was almost exactly how I
stepped through the code to figure out how things worked...while maybe a bit
exaggerated in this post.

<!-- Links -->

[bug]: https://github.com/clburlison/pinpoint/issues/34
[WiFi Explorer]: https://www.adriangranados.com/apps/wifi-explorer
[NetSpot]: https://www.netspotapp.com/
[CoreWLAN]: https://developer.apple.com/documentation/corewlan/?language=objc
[CWInterface]: https://developer.apple.com/documentation/corewlan/cwinterface?language=objc
[declaration]: https://developer.apple.com/documentation/corewlan/cwinterface/2919788-scanfornetworkswithname?language=objc
[Frogor]: https://gist.github.com/search?utf8=%E2%9C%93&q=user%3Apudquick+objc.loadBundle%28
[PyObjC]: https://pythonhosted.org/pyobjc/
[python set]: https://docs.python.org/2/library/sets.html
