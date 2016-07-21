DROP ROLE admin_role;
CREATE ROLE admin_role;

GRANT connect, create view, create job, create table, create sequence,
      create trigger, create procedure, create any context,
      create public synonym, create session  TO admin_role;

GRANT SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE,  DELETE ANY TABLE, CREATE ANY TABLE TO admin_role;

GRANT EXECUTE ANY PROCEDURE TO admin_role;
GRANT EXECUTE ANY PROGRAM TO admin_role;
GRANT EXECUTE ON sys.dbms_crypto TO admin_role;
GRANT SELECT ON  V_$PARAMETER TO admin_role;


DROP USER simple_delivery CASCADE;
CREATE USER simple_delivery IDENTIFIED BY 123456;
GRANT admin_role TO simple_delivery;

DROP USER simple_delivery_utp CASCADE;
CREATE USER simple_delivery_utp IDENTIFIED BY 123456;
GRANT admin_role TO simple_delivery_utp;

alter user simple_delivery_utp quota unlimited on users;

GRANT UNLIMITED TABLESPACE TO simple_delivery_utp;
GRANT UNLIMITED TABLESPACE TO simple_delivery;

GRANT EXECUTE ON dbms_crypto TO simple_delivery;
/
