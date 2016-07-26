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

   PROCEDURE insert_test_customer_person(p_person_id_out OUT people.person_id%type)
   AS
     v_person tapi_people.people_rt;
   BEGIN
     v_person.name := 'CUSTOMER';
     v_person.last_name := 'PERSON';
     v_person.email := 'foo@gmail.com';
     v_person.cellphone := 123456;

     tapi_people.ins(v_person);

     p_person_id_out := v_person.person_id;
   END insert_test_customer_person;

   PROCEDURE insert_test_seller_person(p_person_id_out OUT people.person_id%type)
   AS
     v_person tapi_people.people_rt;
   BEGIN
     v_person.name := 'SELLER';
     v_person.last_name := 'PERSON';
     v_person.email := 'bar@gmail.com';
     v_person.cellphone := 987655;

     tapi_people.ins(v_person);

     p_person_id_out := v_person.person_id;
   END insert_test_customer_person;

   PROCEDURE insert_test_customer_user(p_person_id people.person_id%type,
                                       p_user_id_out OUT users.user_id%type)
   AS
     v_user tapi_users.users_rt;
   BEGIN
     v_user.password := 'abc12345';
     v_user.person_id := p_person_id;
     tapi_users.ins(v_user);

     p_user_id_out := v_user.user_id;
   END insert_test_customer_user;

   PROCEDURE insert_test_seller_user(p_person_id people.person_id%type,
                                     p_user_id_out OUT users.user_id%type)
   AS
     v_user tapi_users.users_rt;
   BEGIN
     v_user.password := 'abc12345';
     v_user.person_id := p_person_id;
     tapi_users.ins(v_user);

     p_user_id_out := v_user.user_id;
   END insert_test_customer_user;

   -- For each program to test...
   PROCEDURE ut_IS_CUSTOMER
   IS
      -- Verify and complete data types.
      against_this BOOLEAN;
      check_this BOOLEAN;
      v_customer_person_id people.person_id%type;
      v_customer_user_id users.user_id%type;
      v_seller_person_id people.person_id%type;
      v_seller_user_id users.user_id%type;

   BEGIN

      INSERT INTO users (password, creation_date, person_id, state_id)
        VALUES ('abc12345',SYSTIMESTAMP,v_seller_person_id,global_constants.active_state)
        RETURNING user_id INTO v_seller_user_id;

      INSERT INTO customers (user_id, state_id)
        VALUES (v_customer_user_id, global_constants.active_state);

      -- Define "control" operation

      against_this := TRUE;

      -- Execute test code

      check_this :=
      USERS_MANAGEMENT.IS_CUSTOMER (
         P_USER_ID => v_customer_user_id
       );

      -- Assert success

      -- Compare the two values.
      utAssert.eq (
         'Test of IS_CUSTOMER for a registered customer',
         check_this,
         against_this
         );

      against_this := FALSE;

      check_this :=
      USERS_MANAGEMENT.IS_CUSTOMER (
         P_USER_ID => v_seller_user_id
       );

      utAssert.eq (
        'Test of IS_CUSTOMER for non customer user',
        check_this,
        against_this
        );

      INSERT INTO customers (user_id, state_id)
        VALUES (v_seller_user_id, global_constants.active_state);

      against_this := TRUE;

      check_this :=
      USERS_MANAGEMENT.IS_CUSTOMER (
         P_USER_ID => v_seller_user_id
       );

      utAssert.eq (
       'Test of IS_CUSTOMER for a seller that is a customer too',
       check_this,
       against_this
       );

      ROLLBACK;
      -- End of test
   END ut_IS_CUSTOMER;

   PROCEDURE ut_IS_SELLER
   IS
      -- Verify and complete data types.
      against_this BOOLEAN;
      check_this BOOLEAN;
      v_customer_person_id people.person_id%type;
      v_customer_user_id users.user_id%type;
      v_seller_person_id people.person_id%type;
      v_seller_user_id users.user_id%type;
   BEGIN
     INSERT INTO people (name,last_name,email,cellphone)
       VALUES ('CUSTOMER', 'PERSON', 'foo@gmail.com',1234561)
       RETURNING person_id INTO v_customer_person_id;

     INSERT INTO people (name,last_name,email,cellphone)
       VALUES ('SELLER','PERSON','bar@gmail.com', 987655)
       RETURNING person_id INTO v_seller_person_id;

     INSERT INTO users (password, creation_date, person_id, state_id)
       VALUES ('abc12345',SYSTIMESTAMP,v_customer_person_id,global_constants.active_state)
       RETURNING user_id INTO v_customer_user_id;

     INSERT INTO users (password, creation_date, person_id, state_id)
       VALUES ('abc12345',SYSTIMESTAMP,v_seller_person_id,global_constants.active_state)
       RETURNING user_id INTO v_seller_user_id;

     INSERT INTO sellers (user_id, state_id)
       VALUES (v_seller_user_id, global_constants.active_state);
      -- Define "control" operation

      against_this := TRUE;

      -- Execute test code

      check_this :=
      USERS_MANAGEMENT.IS_SELLER (
         P_USER_ID => v_seller_user_id
       );

      -- Assert success

      -- Compare the two values.
      utAssert.eq (
         'Test of IS_SELLER for a registered seller',
         check_this,
         against_this
         );

      against_this := FALSE;

      -- Execute test code

      check_this :=
       USERS_MANAGEMENT.IS_SELLER (
          P_USER_ID => v_customer_user_id
        );

      -- Assert success

      -- Compare the two values.
      utAssert.eq (
          'Test of IS_SELLER for a non seller user',
          check_this,
          against_this
          );

      against_this := TRUE;
      INSERT INTO sellers (user_id, state_id)
        VALUES (v_customer_user_id, global_constants.active_state);

      check_this :=
       USERS_MANAGEMENT.IS_SELLER (
        P_USER_ID => v_customer_user_id
        );

      utAssert.eq (
          'Test of IS_SELLER for customer that is a seller too',
          check_this,
          against_this
          );

      ROLLBACK;

      -- End of test
   END ut_IS_SELLER;

END ut_users_management;
/
