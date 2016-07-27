CREATE OR REPLACE PACKAGE BODY ut_login
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
   PROCEDURE ut_VALID_LOGIN
   IS
      -- Verify and complete data types.
      against_this NUMBER;
      check_this NUMBER;
   BEGIN

      -- Define "control" operation

      against_this := NULL;

      -- Execute test code

      check_this :=
      LOGIN.VALID_LOGIN (
         P_USER_ID => ''
         ,
         P_USER_TYPE => ''
         ,
         P_PASSWORD => ''
       );

      -- Assert success

      -- Compare the two values.
      utAssert.eq (
         'Test of VALID_LOGIN',
         check_this,
         against_this
         );

      -- End of test
   END ut_VALID_LOGIN;

   PROCEDURE ut_VALID_PASSWORD
   IS
      -- Verify and complete data types.
      against_this BOOLEAN;
      check_this BOOLEAN;
   BEGIN

      -- Define "control" operation

      against_this := NULL;

      -- Execute test code

      check_this :=
      LOGIN.VALID_PASSWORD (
         P_USER_ID => ''
         ,
         P_PASSWORD => ''
       );

      -- Assert success

      -- Compare the two values.
      utAssert.eq (
         'Test of VALID_PASSWORD',
         check_this,
         against_this
         );

      -- End of test
   END ut_VALID_PASSWORD;

END ut_login;
/
