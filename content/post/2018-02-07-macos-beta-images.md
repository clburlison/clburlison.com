---
title: "macOS Beta Images"
date: 2018-02-07T17:49:41-06:00
categories:
- tech
tags:
- macOS
keywords:
- tech
- imaging
- beta
- apple
#thumbnailImage: //example.com/image.jpg
---

Apple releases new macOS betas pretty frequently and you test all of those
betas, right? Well what if I told you there are some features you
**can't** test. Not because you don't want to but because Apple doesn't
give you the tools.
<!--more-->

Apple just released macOS 10.13.4 beta 2 on [Feb. 6, 2018][apple_10.13.4b2].
However, if you wanted to test this new release with Apple's own
[Device Enrollment Program (DEP)][dep] you **can't**! Or can you?

With some inspiration from [@groob], [@tvsutton], & [@fuzzylogiq]. Along with
a little code inspiration from [@frogor], [@gregneagle] & [@magervalp].
The following hacky method was created.

# Requirements

* A spare mac (virtual or physical)
* At least 40 GB of free space running 10.13.X
* About 30-90 minutes depending on disk speed and internet connection
* [Autodmg]
* [SUS Inspector]
* Latest [Install macOS Install app] from the Mac App Store

# Process

Please note this process is not 100% clean and **might** install beta software
onto the root drive running 10.13 so it is highly recommended you do not use
your primary machine unless it is already on the beta track. Remember "hacky"
above?

1. Use autodmg with a 10.13.x installer to create a dmg.
    {{< image classes="fancybox center clear" src="/images/2018-02-07/autodmg.gif" title="Using Autodmg" >}}
1. Mount the 10.13.X ouput dmg with.
    ```bash
    hdiutil attach -owners on /path/to/10.13.3.dmg -shadow

    # output
    expected   CRC32 $FC3036F4
    /dev/disk5         	EF57347C-0000-11AA-AA11-0030654	
    /dev/disk5s1       	41504653-0000-11AA-AA11-0030654	/Volumes/Macintosh HD 1
    /dev/disk5s2       	41504653-0000-11AA-AA11-0030654	/Volumes/Preboot
    /dev/disk5s3       	41504653-0000-11AA-AA11-0030654	/Volumes/Recovery 1
    /dev/disk4          	GUID_partition_scheme          	
    /dev/disk4s1        	EFI                            	
    /dev/disk4s2        	Apple_APFS    
    ```

    {{% alert info %}}
    Note your disk number: '/dev/disk5' from the above output  
    Note your mount path: '/Volumes/Macintosh HD 1' from the above output
    {{% /alert %}}

1. Launch SUS Inspector.
1. If this is your first time using SUS Inspector you will be asked if you want to add custom catalogs which we do. If you have already configured SUS and didn't add these seed catalogs see [^1].
    {{< image classes="fancybox center clear" src="/images/2018-02-07/sus01.png" title="Adding custom catalogs" >}}
1. Add the following additional Apple catalogs into the feed window.

    | Feed Name | Feed URL |
    | ------------- |---------------|
    | DeveloperSeed   | http://swscan.apple.com/content/catalogs/others/index-10.13seed-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog |
    | PublicSeed      | http://swscan.apple.com/content/catalogs/others/index-10.13beta-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog |
    | CustomerSeed | http://swscan.apple.com/content/catalogs/others/index-10.13customerseed-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog |


    {{% alert info %}}
    Tip: SUS Inspector is an alpha release. When you copy/paste
    the Name and URL hit "enter" on the keyboard after each item is added.
    Once all three feeds have been added click "save".
    {{% /alert %}}

1. Let SUS Inspector sync the catalogs.
    {{< image classes="fancybox center clear" src="/images/2018-02-07/sus02.png" title="SUS Inspector syncing catalogs" >}}
1. Use the CustomerSeed or PublicSeed to find the latest 10.13.X combo update beta.
1. Right click the item, select "Get Info", change to packages tab, download all of them.
    {{< image classes="fancybox center clear" src="/images/2018-02-07/find_the_beta.png" title="Finding and downloading the right files" >}}
1. Once the download is complete click reveal.
1. Now we will modify the `XXX-English.dist` file to disregard all safety checks essentially allowing us to always install. Remember "hacky" method?

    ```bash
    sed -i '' 's/return false/return true/g' /path/to/091-65991.English.dist
    ```
1. Use an undocumented option to install from the dist file directly to the shadow mounted dmg. Make sure to change the Volumes path if it is named differently.

    ```bash
    sudo installer -pkg /path/to/091-65991.English.dist -tgt /Volumes/Macintosh\ HD\ 1
    ```
1. Unmount the shadow dmg.
    ```bash
    hdiutil detach /dev/disk<number_from_step2>
    ```
1. Convert the shadow dmg to compressed dmg.
    ```bash
    hdiutil convert -format UDZO -o 10.13.4b2.dmg /path/to/10.13.3.dmg -shadow
    ```
1. Now you will want to delete shadow file manually. It will be next to your 10.13.3.dmg with `.shadow` extension.

This dmg can now be used in [vfuse], imaging, etc. for DEP testing.

# Other thoughts

This is not a valid solution. I would love for Apple to properly distribute a
real `macOS Install XXX Beta.app` file with each beta. This would allow
admins and other members of the community (VMware, Parallels, etc.) to
properly to test against beta releases. For example the `startosinstall`
command is completely untestable right now and the above hacky method does
not allow us to validate changes until Apple releases full point releases,
which often is too late.

[^1]: Close SUS Inspector and delete the following directory `~/Library/Application Support/SUS Inspector/SUS_Inspector.storedata` see the following link for [more info][SUS Reset]

<!-- Links -->
[apple_10.13.4b2]: https://www.macrumors.com/2018/02/06/apple-seeds-macos-high-sierra-10-13-4-beta-2/
[dep]: https://www.apple.com/business/dep/
[@groob]: https://twitter.com/wikiwalk
[@tvsutton]: https://twitter.com/tvsutton
[@fuzzylogiq]: https://twitter.com/fuzzylogiq
[@frogor]: https://twitter.com/mikeymikey
[@gregneagle]: https://twitter.com/gregneagle
[@magervalp]: https://twitter.com/magervalp
[Autodmg]: https://github.com/MagerValp/AutoDMG/releases
[SUS Inspector]: https://github.com/hjuutilainen/sus-inspector/releases
[Install macOS Install app]: https://itunes.apple.com/us/app/macos-high-sierra/id1246284741?mt=12
[SUS Reset]: https://github.com/hjuutilainen/sus-inspector#resetting-and-uninstalling
[vfuse]: https://github.com/chilcote/vfuse
