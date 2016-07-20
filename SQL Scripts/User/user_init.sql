DROP USER simple_delivery CASCADE;
CREATE USER simple_delivery IDENTIFIED BY 123456;
GRANT DBA TO simple_delivery;
GRANT connect,create view, create job, create table, create sequence, create trigger, create procedure, create any context TO simple_delivery;
GRANT EXECUTE ON dbms_crypto TO simple_delivery;
/
