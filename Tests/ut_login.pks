CREATE OR REPLACE PACKAGE ut_login
IS
   PROCEDURE ut_setup;
   PROCEDURE ut_teardown;

   -- For each program to test...
   PROCEDURE ut_VALID_LOGIN;
   PROCEDURE ut_VALID_PASSWORD;
END ut_login;
/
