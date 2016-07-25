CREATE OR REPLACE PACKAGE ut_users_management
IS
   PROCEDURE ut_setup;
   PROCEDURE ut_teardown;

   -- For each program to test...
   PROCEDURE ut_IS_CUSTOMER;
   PROCEDURE ut_IS_SELLER;
END ut_users_management;
/
