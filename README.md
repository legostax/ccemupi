ComputerCraft Emulator for Raspberry Pi 3
=============================

Description:
------------

This is a ComputerCraft Emulator written in Love2D. It is not complete, and is still a work in progress.

*This version only comes packaged with a special Raspbian image file that has yet to be released.*

HTTPS Support:
----------------
I may remove this in order to keep the system nerfed like normal computers in CC.
**Linux:**

```
apt-get install lua-sec
```

This should get everything you need.

Then go into conf.lua and set useLuaSec to true

**Windows:**

You can try LuaRocks to see if it has LuaSec, I did it manually

For HTTPS support, you'll need to grab:

From LuaSec: [Binaries](http://50.116.63.25/public/LuaSec-Binaries/), [Lua Code](http://www.inf.puc-rio.br/~brunoos/luasec/download/luasec-0.4.1.tar.gz):

  * ssl.dll -> ssl.dll

  * luasec-luasec-0.4.1/src/ssl.lua -> ssl.lua

  * luasec-luasec-0.4.1/src/https.lua -> ssl/https.lua

You also need to install OpenSSL: [Windows](http://slproweb.com/products/Win32OpenSSL.html)

Place these files where the love executable can get to them, where love is installed or the lua path.

Then go into conf.lua and set useLuaSec to true

**Mac:**

I dunno. Try the ssl.so file on the binaries page.

Screenshots:
------------

![Demonstration](http://i.imgur.com/VSCl7IN.png)

NOTES:
------

My fork of CCLite has a different save directory than Sorroko's and gamax92's versions. Mine will save to the "ccemupi" folder while theres' save to the "cclite" and "ccemu" folders respectively.

TODO:
-----

Add in more error checking

Special API in CC environment for controlling the Pi

Treat USB storage like ComputerCraft disks (might need an executable for file handling)

(maybe treat Bluetooth like Rednet)
