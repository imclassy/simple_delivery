@echo off
set vHost=localhost
set vPortNo=1521
set vServiceName=pdborcl as sysdba
set vUserName=sys
set vPassword=123456
echo @"%~dp0/user_init.sql" | sqlplus -S %vUserName%/%vPassword%@%vHost%:%VPortNo%/%vServiceName%
echo @"%~dp0/tools_init.sql"| sqlplus -S %vUserName%/%vPassword%@%vHost%:%VPortNo%/%vServiceName% 
