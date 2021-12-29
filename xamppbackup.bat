@echo off

tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe">NUL
if "%ERRORLEVEL%"=="0" (
    goto continue
) else (
    goto mysql_not_running
)

:continue		
 :: Enter DB credentials here
 set dbUser=
 set dbPassword= 
 set backupDir="PATH TO FOLDER TO STORE BACKUPS"
 :: This is the path to your mysqldump.exe and data folder, usually found at these paths
 set mysqldump="C:\xampp\mysql\bin\mysqldump.exe"
 set mysqlDataDir="C:\xampp\mysql\data"
 :: Path to your 7z.exe location
 set zip="C:\Program Files\7-Zip\7z.exe"

 :: get date
 for /F "tokens=2-4 delims=/ " %%i in ('date /t') do (
      set yy=%%i
      set mon=%%j
      set dd=%%k
 )

 :: get time
 for /F "tokens=5-8 delims=:. " %%i in ('echo^| time ^| find "current" ') do (
      set hh=%%i
      set min=%%j
 )

set hr=%time:~0,2%
set hr=%hr: =0%

 set dirName=%mon%-%yy%-%dd%_%hr%-%min%
  
 :: switch to the "data" folder
 pushd %mysqlDataDir%

 :: iterate over the folder structure in the "data" folder to get the databases
 for /d %%f in (ENTERDBNAMEHERE) do (

 if not exist %backupDir%\%dirName%\ (
      mkdir %backupDir%\%dirName%
 )
 echo -----------------------------
 echo * MySQL backup are starting *
 echo -----------------------------
 echo Current backup : %%f.sql
 %mysqldump% --host="localhost" --user=%dbUser% --password=%dbPassword% --single-transaction --add-drop-table --databases %%f > %backupDir%\%dirName%\%%f.sql

 %zip% a -tgzip %backupDir%\%dirName%\%%f.sql.gz %backupDir%\%dirName%\%%f.sql
 echo[
 echo Done compress and archive thus file..now lets delete SQL file...
 del %backupDir%\%dirName%\%%f.sql
 echo OK, now I need to take a breather for 3 seconds...
 choice /d y /t 3 > nul
 cls
 )
 popd

 echo -----------------------------
 echo + MySQL backup are finished +
 echo -----------------------------
 choice /d y /t 3 > nul
 cls
 )
 popd
 exit /b

:mysql_not_running
echo -----------------------------
echo !!WARNING COULDN'T CONTINUE!!
echo -----------------------------
echo Message: mysqld.exe is not running, please start it (e.g. via xampp-control)
pause
exit /b