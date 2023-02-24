@echo off

setlocal EnableDelayedExpansion

rem Set directory for wallpaper images
set wallpaper_dir=C:\Users\%USERNAME%\Pictures\Wallpapers

rem Set time interval for changing wallpaper in seconds
set interval=300

rem Initialize counter
set /a counter=0

rem Create list of wallpaper images
for /f "delims=" %%a in ('dir /b %wallpaper_dir%') do (
    set /a counter+=1
    set "image[!counter!]=%%a"
)

rem Set number of images
set /a num_images=%counter%

rem Start changing wallpapers
:loop
rem Choose a random number between 1 and num_images
set /a "random_num=%random% %% %num_images% + 1"

rem Set the wallpaper
REG ADD "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%wallpaper_dir%\!image[%random_num%]!" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

rem Wait for interval
ping -n %interval% 127.0.0.1 > nul

goto loop
