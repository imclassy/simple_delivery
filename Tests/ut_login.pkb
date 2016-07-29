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

   PROCEDURE insert_test_person(p_person_id_out OUT people.person_id%type)
   AS
     v_person tapi_people.people_rt;
   BEGIN
     v_person.name := 'USER';
     v_person.last_name := 'PERSON';
     v_person.email := 'foo@gmail.com';
     v_person.cellphone := 123456;

     tapi_people.ins(v_person);

     p_person_id_out := v_person.person_id;
   END insert_test_customer_person;

   PROCEDURE insert_test_user(p_person_id people.person_id%type,
                              p_password users.password%type,
                              p_user_id_out OUT users.user_id%type)
   AS
     v_user tapi_users.users_rt;
   BEGIN
     v_user.password := p_password;
     v_user.person_id := p_person_id;
     tapi_users.ins(v_user);

     p_user_id_out := v_user.user_id;
   END insert_test_user;

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
      v_test_person_id people.person_id%type;
      v_test_user_id users.user_id%type;
   BEGIN
      insert_test_person(p_person_id_out => v_test_person_id);

      insert_test_user(p_person_id => v_test_person_id,
                       p_password => 'abc12345',
                       p_user_id_out => v_test_user_id);
      -- Testing two identical passwords are valid
      check_this :=
         LOGIN.VALID_PASSWORD (
            P_USER_ID => v_test_user_id,
            P_PASSWORD => 'abc12345'
          );

      against_this := TRUE;
      -- Compare the two values.
      utAssert.eq (
         'Test of VALID_PASSWORD, same passwords, both lowercase letters with numbers',
         check_this,
         against_this
         );
      -- Testing two different passwords are invalid
      check_this :=
          LOGIN.VALID_PASSWORD (
             P_USER_ID => v_test_user_id,
             P_PASSWORD => 'ffff12345'
           );

      against_this := FALSE;

      utAssert.eq (
         'Test of VALID_PASSWORD, different passwords, both lowercase letters with numbers',
         check_this,
         against_this
         );

      UPDATE users
         SET password = 'ABC12345'
       WHERE user_id = v_test_user_id;
       
       -- If password validation must be case sensitive
       check_this :=
          LOGIN.VALID_PASSWORD (
             P_USER_ID => v_test_user_id,
             P_PASSWORD => 'abc12345'
           );

       against_this := FALSE;

      -- End of test
   END ut_VALID_PASSWORD;

END ut_login;
/
