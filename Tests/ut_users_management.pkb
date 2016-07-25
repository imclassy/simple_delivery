CREATE OR REPLACE PACKAGE BODY ut_users_management
IS
   PROCEDURE ut_setup
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE ut_teardown
   IS
   BEGIN
      NULL;
   END;
   -- For each program to test...
   PROCEDURE ut_IS_CUSTOMER
   IS
      -- Verify and complete data types.
      against_this BOOLEAN;
      check_this BOOLEAN;
   BEGIN

      -- Define "control" operation

      against_this := NULL;

      -- Execute test code

      check_this :=
      USERS_MANAGEMENT.IS_CUSTOMER (
         P_USER_ID => ''
       );

      -- Assert success

      -- Compare the two values.
      utAssert.eq (
         'Test of IS_CUSTOMER',
         check_this,
         against_this
         );

      -- End of test
   END ut_IS_CUSTOMER;

   PROCEDURE ut_IS_SELLER
   IS
      -- Verify and complete data types.
      against_this BOOLEAN;
      check_this BOOLEAN;
   BEGIN

      -- Define "control" operation

      against_this := NULL;

      -- Execute test code

      check_this :=
      USERS_MANAGEMENT.IS_SELLER (
         P_USER_ID => ''
       );

      -- Assert success

      -- Compare the two values.
      utAssert.eq (
         'Test of IS_SELLER',
         check_this,
         against_this
         );

      -- End of test
   END ut_IS_SELLER;

END ut_users_management;
/
