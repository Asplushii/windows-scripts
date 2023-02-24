@echo off

REM Define the directory where the wallpaper images are stored
set IMAGE_DIRECTORY="C:\Wallpapers"

REM Define the time interval for how often the wallpaper should change (in seconds)
set INTERVAL=300

REM Create the Windows service
:serviceloop
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WallpaperChanger" /v "ImagePath" /t REG_EXPAND_SZ /d "%~dpnx0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WallpaperChanger" /v "DisplayName" /t REG_SZ /d "Wallpaper Changer" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WallpaperChanger" /v "Start" /t REG_DWORD /d 2 /f
net start WallpaperChanger

REM Randomly select a wallpaper image and set it as the desktop wallpaper
:wallpaperloop
setlocal enableextensions
set "CHOSEN_IMAGE=%IMAGE_DIRECTORY%\*.*"
set "CHOSEN_IMAGE=!CHOSEN_IMAGE:%~dp0=!"
for /r %CHOSEN_IMAGE% %%i in (*) do (
  set "RNDIMAGE=%%i"
  set /a "counter+=1"
)
set /a "rand=(%random%*%counter%/32768)+1"
set "CHOSEN_IMAGE="
set "counter=0"
for /r %CHOSEN_IMAGE% %%i in (*) do if not defined CHOSEN_IMAGE set "CHOSEN_IMAGE=%%i" && set /a "counter+=1" && if !counter!==!rand! set "CHOSEN_IMAGE=%%i" && set /a "counter+=1"
echo %CHOSEN_IMAGE%
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d %CHOSEN_IMAGE% /f
rundll32.exe user32.dll,UpdatePerUserSystemParameters

REM Wait for the specified interval and then change the wallpaper again
ping -n %INTERVAL% localhost > nul
goto wallpaperloop
