@echo off
set /p source_folder=Enter the path of the folder to be backed up: 
set /p backup_drive=Enter the drive letter of the backup drive (e.g. E:): 

echo Starting backup of %source_folder% to %backup_drive%...

if not exist %backup_drive%\backup md %backup_drive%\backup

robocopy %source_folder% %backup_drive%\backup /e /zb /copyall /r:1 /w:1 /tee /log:backup.log

echo Backup completed. Log file saved as backup.log.

pause
