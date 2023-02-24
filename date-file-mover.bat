@echo off
setlocal enableextensions

REM Get current date and time
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (
   set "month=%%a"
   set "day=%%b"
   set "year=%%c"
)
for /f "tokens=1-3 delims=: " %%a in ('time /t') do (
   set "hour=%%a"
   set "minute=%%b"
   set "second=%%c"
)

REM Create new folder with current date as name
set "folder=%year%-%month%-%day%"
mkdir "%folder%"

REM Move all files modified on current date into new folder
for /r %%i in (*) do (
   for %%j in (%%i) do (
      for /f "tokens=1-3 delims=/: " %%x in ("%%~ti") do (
         if "%%x-%%y-%%z"=="%month%-%day%-%year%" (
            move "%%i" "%folder%" > nul
         )
      )
   )
)

echo Done.
pause
