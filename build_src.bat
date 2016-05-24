@echo off
if exist loveccemupi.love del loveccemupi.love
winrar a -afzip loveccemupi.zip main.lua conf.lua assets
move loveccemupi.zip loveccemupi.love
