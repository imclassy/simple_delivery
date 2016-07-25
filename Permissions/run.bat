@echo off
set vHost=localhost
set vPortNo=1521
set vServiceName=pdborcl
set vUserName=simple_delivery
set vPassword=123456
for %%f in ("%~dp0\*.sql") do (
echo Start "%%f"
exit | sqlplus -S %vUserName%/%vPassword%@%vHost%:%VPortNo%/%vServiceName% @"%%f"
echo Completed "%%f"
)
