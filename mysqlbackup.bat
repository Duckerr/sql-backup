set year=%DATE:~10,4%
set day=%DATE:~7,2%
set mnt=%DATE:~4,2%
set hr=%TIME:~0,2%
set min=%TIME:~3,2%

IF %day% LSS 10 SET day=0%day:~1,1%
IF %mnt% LSS 10 SET mnt=0%mnt:~1,1%
IF %hr% LSS 10 SET hr=0%hr:~1,1%
IF %min% LSS 10 SET min=0%min:~1,1%

set backuptime=%year%-%day%-%mnt%-%hr%-%min%
echo %backuptime%



:: SETTINGS AND PATHS 
:: Note: Do not put spaces before the equal signs or variables will fail

:: Name of the database user with rights to all tables
set dbuser=

:: Password for the database user
set dbpass=

:: Error log path - Important in debugging your issues
set errorLogPath="c:\MySQLBackups\backupfiles\dumperrors.txt"

:: MySQL EXE Path
set mysqldumpexe="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe"

:: Error log path
set backupfldr=c:\MySQLBackups\backupfiles\

:: Path to data folder which may differ from install dir
set datafldr="C:\ProgramData\MySQL\MySQL Server 8.0\Data"

:: Path to zip executable
set zipper="C:\Program Files\7-Zip\7z.exe"

:: Number of days to retain .zip backup files 
set retaindays=954

:: DONE WITH SETTINGS



:: GO FORTH AND BACKUP EVERYTHING!

:: Switch to the data directory to enumerate the folders
pushd %datafldr%

echo "Pass each name to mysqldump.exe and output an individual .sql file for each"

:: turn on if you are debugging
@echo off

FOR /D %%F IN (*) DO (

IF NOT [%%F]==[performance_schema] (
SET %%F=!%%F:@002d=-!
%mysqldumpexe% --user=%dbuser% --password=%dbpass% --databases --routines --log-error=%errorLogPath% %%F > "%backupfldr%%%F.%backuptime%.sql"
) ELSE (
echo Skipping DB backup for performance_schema
)
)

echo "Zipping all files ending in .sql in the folder"


:: .zip option clean but not as compressed
%zipper% a -tzip "%backupfldr%FullBackup.%backuptime%.zip" "%backupfldr%*.sql"


echo "Deleting all the files ending in .sql only"
 
del "%backupfldr%*.sql"

echo "Deleting zip files older than 30 days now"
Forfiles -p %backupfldr% -s -m *.* -d -%retaindays% -c "cmd /c del /q @path"


::FOR THOSE WHO WISH TO FTP YOUR FILE UNCOMMENT THESE LINES AND UPDATE

::cd\[path to directory where your file is saved]
::@echo off
::echo user [here comes your ftp username]>ftpup.dat
::echo [here comes ftp password]>>ftpup.dat
::echo [optional line; you can put "cd" command to navigate through the folders on the ftp server; eg. cd\folder1\folder2]>>ftpup.dat
::echo binary>>ftpup.dat
::echo put [file name comes here; eg. FullBackup.%backuptime%.zip]>>ftpup.dat
::echo quit>>ftpup.dat
::ftp -n -s:ftpup.dat [insert ftp server here; eg. myserver.com]
::del ftpup.dat

echo "done"

::return to the main script dir on end
popd