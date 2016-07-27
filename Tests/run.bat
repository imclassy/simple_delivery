@echo off
set vHost=localhost
set vPortNo=1521
set vServiceName=pdborcl
set vUserName=simple_delivery_utp
set vPassword=123456
set vCurrPath=%~dp0
for %%f in ("%~dp0\*.pks") do (
echo Start "%%f"
exit | sqlplus -S %vUserName%/%vPassword%@%vHost%:%VPortNo%/%vServiceName% @"%%f"
echo Completed "%%f"
)
for %%f in ("%~dp0\*.pkb") do (
echo Start "%%f"
exit | sqlplus -S %vUserName%/%vPassword%@%vHost%:%VPortNo%/%vServiceName% @"%%f"
echo Completed "%%f"
)
exit | sqlplus -S %vUserName%/%vPassword%@%vHost%:%VPortNo%/%vServiceName% @"set_dir.sql" %~dp0.
pause
