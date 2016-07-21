DROP USER simple_delivery CASCADE;
CREATE USER simple_delivery IDENTIFIED BY 123456;
GRANT DBA TO simple_delivery;
GRANT connect,create view, create job, create table, create sequence, create trigger, create procedure, create any context TO simple_delivery;
GRANT EXECUTE ON dbms_crypto TO simple_delivery;

DROP USER simple_delivery_utp CASCADE;
CREATE USER simple_delivery_utp IDENTIFIED BY 123456;
GRANT create session, create table, create procedure,
  create sequence, create view, create public synonym,
  drop public synonym to simple_delivery_utp;
/
