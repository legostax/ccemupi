ComputerCraft Emulator for Raspberry Pi 3
=============================

Description:
------------
This is a version of the ComputerCraft Emulator written with LÖVE 0.10.0 that is designed for use with the Raspberry Pi.  The image ships with Raspbian Jessie Lite (built on 5-10-2016), a splash screen, LÖVE 0.10.0,  and the emulator itself.

Notes:
------
- My fork of CCLite has a different save directory than Sorroko's and gamax92's versions. Mine will save to the "ccemupi" folder while theres' save to the "cclite" and "ccemu" folders respectively.
- Due to certain glitches with the SDL2 library for the Pi, the mouse cursor has been removed and the emulator only supports a normal black and white CC computer in order to keep to the spirit of ComputerCraft
- On the first run, the user will be prompted to set a new password for the pi account as well as configure the wi-fi.

Installation:
-------------
1. You will need at least an 8GB SD card.  **If someone knows how to create a smaller disk image, please let me know**
2. **Download the zipped disk image here:**
Note that the disk image file is **7.4 GB**.
3. Extract the disk image from the zip file.
4. If you're running Windows, use Win32 Disk Imager: https://sourceforge.net/projects/win32diskimager/
5. Insert your 8 GB SD card into your computer and open the disk imager.
6. Choose the image from file, then select the SD card you wish to write to. Then click Write.
7. Once the write process is complete, put your SD card into your Raspberry Pi, turn it on, and follow the onscreen instructions.

Build the image yourself
------------------------
Detailed instructions will be written in the wiki eventually.

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

TODO:
-----

Add in more error checking

Special API in CC environment for controlling the Pi

Treat USB storage like ComputerCraft disks (might need an executable for file handling)

(maybe treat Bluetooth like Rednet)
