@echo off
set "sevenZipInstaller=https://www.7-zip.org/a/7z2201.exe"
set "sevenZipInstaller64=https://www.7-zip.org/a/7z2201-x64.exe"
set "sevenZipLocation=%ProgramFiles%\7-Zip\7z.exe"

:: Check if 7-Zip is already installed
if exist "%sevenZipLocation%" (
    goto choose_archive
)

:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    goto install_7zip
) else (
    echo You must run this script as an administrator.
    echo Please right-click and choose "Run as administrator".
    pause
    exit
)

:: Install 7-Zip silently
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    powershell Invoke-WebRequest '%sevenZipInstaller64%' -OutFile '7zInstaller.exe'
) else (
    powershell Invoke-WebRequest '%sevenZipInstaller%' -OutFile '7zInstaller.exe'
)
.\7zInstaller.exe /S

:choose_archive
set /p "archiveFolder=Enter archive folder location: "
echo Available archives:
setlocal enabledelayedexpansion
set "index=1"
for /f "tokens=*" %%a in ('dir /b /a-d "%archiveFolder%\*.7z" "%archiveFolder%\*.zip" "%archiveFolder%\*.rar" 2^>nul') do (
    echo !index!. %%a
    set /a "index+=1"
)
endlocal

set /p "archiveNumber=Enter archive number: "
setlocal enabledelayedexpansion
set "archive="
set "index=1"
for /f "tokens=*" %%a in ('dir /b /a-d "%archiveFolder%\*.7z" "%archiveFolder%\*.zip" "%archiveFolder%\*.rar" 2^>nul') do (
    if !index!==%archiveNumber% set "archive=%%a"
    set /a "index+=1"
)

if not defined archive (
    echo Archive not found.
    pause
    cls
    goto choose_archive
)

set /p "password=Enter password (leave blank if none): "
cls
echo Extracting archive contents...
if "%password%"=="" (
    "%sevenZipLocation%" x "%archiveFolder%\%archive%" -o"%temp%\7zip_extract" >nul
) else (
    "%sevenZipLocation%" x -p"%password%" "%archiveFolder%\%archive%" -o"%temp%\7zip_extract" >nul
)

echo.
echo Extracted files:
tree "%temp%\7zip_extract"
echo.
"%sevenZipLocation%" l "%archiveFolder%\%archive%" | findstr /C:"Type = " /C:"Compressed =" /C:"Size: " /C:"Size after:"

set /p "repeat=Do you want to open another archive? (y/n): "
if /i "%repeat%"=="y" (
    rd /s /q "%temp%\7zip_extract"
    cls
    goto choose_archive
) else (
    set /p "removeFolder=Do you want to remove the extracted folder? (y/n): "
    if /i "%removeFolder%"=="y" (
        rd /s /q "%temp%\7zip_extract"
    )
)

pause
