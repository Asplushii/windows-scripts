@echo off
setlocal EnableDelayedExpansion

REM prompt the user to enter the path to the directory they want to sort
set /p folderPath=Enter the path to the directory you want to sort: 

REM create a folder for each file type
for /f "tokens=*" %%a in ('dir /b /a-d "%folderPath%" ^| find "."') do (
    set "ext=%%~xa"
    md "%folderPath%\!ext:~1!" 2>nul
)

REM move files to their respective folders
for /f "tokens=*" %%a in ('dir /b /a-d "%folderPath%" ^| find "."') do (
    set "file=%%~nxa"
    set "ext=%%~xa"
    move "%folderPath%\!file!" "%folderPath%\!ext:~1!" >nul
)

echo Sorting complete.
pause
