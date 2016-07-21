del install_log.txt
call "SQL Scripts\User\run.bat"  >> install_log.txt
call "SQL Scripts\Tables\run.bat"  >> install_log.txt
call "Packages\run.bat"  >> install_log.txt
pause
