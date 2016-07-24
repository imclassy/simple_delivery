@echo off
echo Starting installation
del install_log.txt
echo Initializing database users
call "SQL Scripts\User\run.bat" >> install.log
echo Initializing tables
call "%~dp0SQL Scripts\Tables\run.bat" >> %~dp0install.log
echo Initializing packages
call "%~dp0Packages\run.bat" >> %~dp0install.log
echo Initializing data
call "%~dp0SQL Scripts\Data\run.bat" >> %~dp0install.log
echo Set up completed! Check the install_log for installation results.
pause
