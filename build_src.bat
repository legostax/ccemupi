@echo off
if exist ccemupi.love del ccemupi.love
winrar a -afzip ccemupi.zip http libraries lua peripheral res test api.lua conf.lua main.lua render.lua vfs.lua
move ccemupi.zip ccemupi.love
