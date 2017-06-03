+++
date = "2017-03-26T00:00:00+02:00"
title = "Installing LEDE on a Netgear R6220"
lang = "en"
+++

[LEDE](https://lede-project.org/) has recently added support for the [Netgear R6220](http://www.netgear.com/home/products/networking/wifi-routers/R6220.aspx).
LEDE is a Linux operating system based on OpenWrt. We'll see how to install it.

> **Disclaimer**: R6220 support is still unstable, do not install it if you care
> about availability! Also, you have a chance to brick your router by flashing
> LEDE.

![Front view of the R6220](/img/blog/2017-installing-lede-on-a-netgear-r6220/front.png)

## Flashing LEDE

R6220 support has been added just a few weeks ago, so factory installation
images are not yet available. We'll need to flash LEDE through Telnet.

First download images for the kernel and the root filesystem:

```shell
curl -O https://downloads.lede-project.org/snapshots/targets/ramips/mt7621/lede-ramips-mt7621-r6220-squashfs-rootfs.bin
curl -O https://downloads.lede-project.org/snapshots/targets/ramips/mt7621/lede-ramips-mt7621-r6220-squashfs-kernel.bin
```

Then copy these two files on a USB stick, and plug it on the back of the router.

Enable Telnet on the router by opening this link (you'll be asked to login,
default credentials are printed under the router):

```
http://192.168.1.1/setup.cgi?todo=debug
```

You'll see something like: _Debug Enabled!_

We can now open a Telnet connection, login with _root_ and `cd` to your USB stick:

```shell
telnet 192.168.1.1
# Login with "root"
ls /mnt/shares/ # To find your USB stick
cd /mnt/shares/<usb stick>
```

We can now flash the images! Take a deep breath, and:

```shell
mtd_write write lede-ramips-mt7621-r6220-squashfs-rootfs.bin Rootfs
mtd_write write lede-ramips-mt7621-r6220-squashfs-kernel.bin Kernel
reboot
```

Your router is supposed to boot (blinking _power_ LED). If something goes wrong
(e.g. it's bootlooping), scroll down to the last section of this article.

## Setting up LEDE

You can now follow [standard instructions to setup LEDE after a snapshot
installation](https://lede-project.org/docs/guide-quick-start/developmentinstallation#installing_a_lede_snapshot).
You can install LuCI (the web interface) and configure your router from there.

I myself had an issue with Internet connectivity: I was able to `ping 8.8.8.8`
but `opkg update` was failing. The problem was that I connected the WAN port to
an existing network whose IP address is `192.168.1.0` and that the router's
default IP address is `192.168.1.1`. Thus, my old router's IP address was
conflicting with LEDE's IP address. To fix this, I had to edit
`/etc/config/network` (it seems that only `vi` is available) and replace
`192.168.1.1` by `192.168.2.1` under the `[lan]` section. Reboot the router and
now you should be able to run `opkg update`.

You can install `kmod-usb3` to get the USB port to work (and `kmod-usb-ledtrig-usbport`
to turn on the corresponding LED when a device is connected).

## What if I've bricked my router?

If something goes wrong, there's a way to unbrick your router using [nmrpflash](https://github.com/jclehner/nmrpflash).

First download [the router's default firmware](https://www.netgear.com/support/product/R6220#download)
and [the latest nmrpflash release](https://github.com/jclehner/nmrpflash/releases).

Then follow the instructions in the README. You'll have to connect your router
directly to your computer and run something like this:

```shell
nmrpflash -i enp0s25 -F firmware -f R6220_V1.1.0.34_1.0.1.img
```

If you get the error `Timeout while waiting for ACK(0)/OACK.`, then you're as
unlucky as me and you'll need to manually edit your ARP table. Your router's
MAC address is printed under it. Some details are in this GitHub issue:
https://github.com/jclehner/nmrpflash/issues/4#issuecomment-287555780

## References

1. Official product page: http://www.netgear.com/home/products/networking/wifi-routers/R6220.aspx
2. R6220 techdata: https://lede-project.org/toh/hwdata/netgear/netgear_r6220
3. Pull request adding R6220 support to LEDE: https://github.com/lede-project/source/pull/921
4. Development installation docs: https://lede-project.org/docs/guide-quick-start/developmentinstallation
