@echo off
set vHost=localhost
set vPortNo=1521
set vServiceName=pdborcl as sysdba
set vUserName=sys
set vPassword=Pello1994
echo @"%~dp0/user_init.sql" | sqlplus -S %vUserName%/%vPassword%@%vHost%:%VPortNo%/%vServiceName%
set vServiceName=pdborcl
set vUserName=simple_delivery
set vPassword=123456
echo @"%~dp0/logger_3.1.0/logger_install.sql"| sqlplus -S %vUserName%/%vPassword%@%vHost%:%VPortNo%/%vServiceName%
set vUserName=simple_delivery_utp
cd %~dp0/utplsql/code
echo @"ut_i_do.sql" install| sqlplus -S %vUserName%/%vPassword%@%vHost%:%VPortNo%/%vServiceName%
