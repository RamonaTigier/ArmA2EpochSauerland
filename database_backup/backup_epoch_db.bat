@ECHO OFF
:: mysql backup into several databases for rollback, checking if mysql and arma2oaserver is running
::
:: Version 0.1.0.1 initial version

:: *** self administrate
SET DAB=epoch_database
:: ATTENTION !!! Be sure that the starting process is in the correct directory!!!
SET BAD="%cd%"

:: *** Init 
pushd %BAD%
SET LGF=%BAD%"\logs\backup.log"
SET TME=""
IF "%1"=="" IF "%2"=="" IF "%3"=="" IF "%4"=="" IF "%5"=="" GOTO Check
SET USR=%2
SET PWD=%3
SET HST=%4
SET PRT=%5
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS

:: *** which backup is running (variable %1)
IF "%1"=="full" set TME=%1 
IF "%1"=="quarter" set TME=%1 
IF "%1"=="half" set TME=%1 
IF "%1"=="three-quarter" set TME="tree_quarter"

:: *** manual start?
IF "%1"=="manual" ( 
	set TME=%1 
	GOTO Backup
)

:: *** no args set? exit!
:Check
IF %TME%=="" (
	echo "usage: backup_epoch_db <full|quarter|half|three-quarter|manual> <db user> <db password> <db host> <db port>" 
	echo "u entered: backup_epoch_db %1 %2 %3 %4 %5"
	echo %date:~-4,4%%date:~-7,2%%date:~-10,2%%time:~-11,2%%time:~-8,2%:wrong usage, nothing to do exiting... >> %LGF%
	timeout 15
	GOTO End
)

:: *** everything ok until here? go on!
echo %date:~-4,4%%date:~-7,2%%date:~-10,2%%time:~-11,2%%time:~-8,2%:backup starting >> %LGF%

:: *** Check mysqld running
tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe">NUL
IF "%ERRORLEVEL%"=="0" GOTO Savelogs
echo %date:~-4,4%%date:~-7,2%%date:~-10,2%%time:~-11,2%%time:~-8,2%:no mysqld running, nothing to do exiting... >> %LGF%
GOTO End
echo %date:~-4,4%%date:~-7,2%%date:~-10,2%%time:~-11,2%%time:~-8,2%:mysqld running >> %LGF%

:: *** Log rotate
:Savelogs
IF %time:~-11,2%==00 (
	IF %time:~-8,2%==00 (
		"C:\Program Files\7-Zip\7z.exe" a -t7z logs\backup.7z logs\backup.log
		IF "%ERRORLEVEL%"=="0" (
			powershell -ep RemoteSigned -file .\yesterday.ps1 >.\yesterday.txt
			SET /p YSD=< %BAD%\yesterday.txt
			echo test #%YSD%#
			REN logs\backup.7z logs\backup%YSD%.7z
			del logs\backup.log
			echo %date:~-4,4%%date:~-7,2%%date:~-10,2%%time:~-11,2%%time:~-8,2%:backup zipping success >> %LGF%
		) ELSE (
			echo %date:~-4,4%%date:~-7,2%%date:~-10,2%%time:~-11,2%%time:~-8,2%:backup zipping error, please check!!! >> %LGF%
		)
	)
)

:: *** check ArmA 2 server running
tasklist /FI "IMAGENAME eq arma2oaserver.exe" 2>NUL | find /I /N "arma2oaserver.exe">NUL
if "%ERRORLEVEL%"=="0" GOTO Run
echo %date:~-4,4%%date:~-7,2%%date:~-10,2%%time:~-11,2%%time:~-8,2%:arma2oaserver NOT running, nothing to do, exiting... >> %LGF%
GOTO End
echo %date:~-4,4%%date:~-7,2%%date:~-10,2%%time:~-11,2%%time:~-8,2%:arma2oaserver running >> %LGF%

:: *** log start 
echo %date:~-4,4%%date:~-7,2%%date:~-10,2%%time:~-11,2%%time:~-8,2%:backup starting:arg:%1 %2 <password hidden> %4 %5 >> %LGF%

:: *** Start 
:Run

:: *** do backup
:Backup
cd C:\Program Files (x86)\MySQL\MySQL Utilities\
mysqldbcopy.exe --source=%USR%:%PWD%@%HST%:%PRT% --destination=%USR%:%PWD%@%HST%:%PRT% %DAB%:%DAB%_save_%TME% --drop-first >> %LGF%
IF "%ERRORLEVEL%"=="0" (
	echo %date:~-4,4%%date:~-7,2%%date:~-10,2%%time:~-11,2%%time:~-8,2%:backup success >> %LGF%
) ELSE (
	echo %date:~-4,4%%date:~-7,2%%date:~-10,2%%time:~-11,2%%time:~-8,2%:backup error, please check >> %LGF%
)
:End
echo %date:~-4,4%%date:~-7,2%%date:~-10,2%%time:~-11,2%%time:~-8,2%:backup end. >> %LGF%
popd