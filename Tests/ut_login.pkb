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
   END insert_test_person;

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

   PROCEDURE insert_test_customer(p_user_id users.user_id%type)
   AS
     v_customer tapi_customers.customers_rt;
   BEGIN
     v_customer.user_id := p_user_id;
     tapi_customers.ins(v_customer);
   END;

   PROCEDURE insert_test_seller(p_user_id users.user_id%type)
   AS
     v_seller tapi_sellers.sellers_rt;
   BEGIN
     v_seller.user_id := p_user_id;
     tapi_sellers.ins(v_seller);
   END;

   -- For each program to test...
   PROCEDURE ut_VALID_LOGIN
   IS
      -- Verify and complete data types.
      against_this NUMBER;
      check_this NUMBER;
      v_test_person_id people.person_id%type;
      v_test_user_id users.user_id%type;
      v_error_num errors.error_id%type;
      v_dummy number;
   BEGIN
     insert_test_person(p_person_id_out => v_test_person_id);

     insert_test_user(
       p_person_id => v_test_person_id,
       p_password => 'abc12345',
       p_user_id_out => v_test_user_id);

     insert_test_seller(v_test_user_id);

     -- Testing a registered seller with same password
     check_this :=
     LOGIN.VALID_LOGIN (
        P_USER_ID => v_test_user_id,
        P_USER_TYPE => login_constants.c_seller_user_type,
        P_PASSWORD => 'abc12345'
      );

      against_this := 1;

      utAssert.eq (
         'Test of VALID_LOGIN, a registered seller with correct password must be valid!',
         check_this,
         against_this
         );

      UPDATE sellers
         SET state_id = global_constants.inactive_state
       WHERE user_id = v_test_user_id;

      -- Testing a inactive seller with valid password
       check_this :=
       LOGIN.VALID_LOGIN (
          P_USER_ID => v_test_user_id,
          P_USER_TYPE => login_constants.c_seller_user_type,
          P_PASSWORD => 'abc12345'
        );

       against_this := 0;

       utAssert.eq (
          'Test of VALID_LOGIN, an inactive seller with must be invalid!',
          check_this,
          against_this
          );

       UPDATE sellers
          SET state_id = global_constants.active_state
        WHERE user_id = v_test_user_id;
        -- Testing a registered seller login in as a customer
       check_this :=
          LOGIN.VALID_LOGIN (
             P_USER_ID => v_test_user_id,
             P_USER_TYPE => login_constants.c_customer_user_type,
             P_PASSWORD => 'abc12345'
           );

       against_this := 0;

       utAssert.eq (
          'Test of VALID_LOGIN, a seller should not log in as a customer!',
          check_this,
          against_this
          );

       insert_test_customer(v_test_user_id);

       -- Testing a registered customer with valid password
       check_this :=
          LOGIN.VALID_LOGIN (
             P_USER_ID => v_test_user_id,
             P_USER_TYPE => login_constants.c_customer_user_type,
             P_PASSWORD => 'abc12345'
           );

       against_this := 1;

       utAssert.eq (
           'Test of VALID_LOGIN, a registered customer with a valid password should log in!',
           check_this,
           against_this
           );
       -- Testing a log in with an invalid user type
       <<catch_invalid_user_type_error>>
       BEGIN
         v_dummy := login.valid_login(
                      p_user_id => v_test_user_id,
                      p_user_type => 'X',
                      p_password => 'abc12345'
                     );
       EXCEPTION
         WHEN OTHERS THEN
           v_error_num := SQLCODE;
       END catch_invalid_user_type_error;

       check_this :=  0;

       IF v_error_num = error_nums.invalid_user_type THEN
         check_this := 1;
       END IF;

       against_this := 1;

       utAssert.eq (
           'Test of VALID_LOGIN, a login with a invalid user type must throw invalid_user_type exception!',
           check_this,
           against_this
           );
    ROLLBACK;
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

       -- Password validation must be case sensitive
       check_this :=
          LOGIN.VALID_PASSWORD (
             P_USER_ID => v_test_user_id,
             P_PASSWORD => 'abc12345'
           );

       against_this := FALSE;

       utAssert.eq (
          'Test of VALID_PASSWORD, testing case sensitive validation',
          check_this,
          against_this
          );

       UPDATE users
          SET password = '&&/!ñ12345'
        WHERE user_id = v_test_user_id;
      -- Testing with weird characters
      check_this :=
         LOGIN.VALID_PASSWORD (
            P_USER_ID => v_test_user_id,
            P_PASSWORD => '&&/!ñ12345'
          );

      against_this := TRUE;

      utAssert.eq (
         'Test of VALID_PASSWORD, testing validation with weird characters',
         check_this,
         against_this
         );

      ROLLBACK;
   END ut_VALID_PASSWORD;

END ut_login;
/
