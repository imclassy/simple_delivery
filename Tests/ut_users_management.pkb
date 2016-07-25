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
         'Test of IS_CUSTOMER for a registered customer',
         check_this,
         against_this
         );

      -- End of test
   END ut_IS_SELLER;

END ut_users_management;
/
