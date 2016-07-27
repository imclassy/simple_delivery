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
   END insert_test_seller_person;

   PROCEDURE insert_test_user(p_person_id people.person_id%type,
                              p_user_id_out OUT users.user_id%type)
   AS
     v_user tapi_users.users_rt;
   BEGIN
     v_user.password := 'abc12345';
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
   END insert_test_customer;

   PROCEDURE insert_test_seller(p_user_id users.user_id%type)
   AS
     v_seller tapi_sellers.sellers_rt;
   BEGIN
     v_seller.user_id := p_user_id;
     tapi_sellers.ins(v_seller);
   END insert_test_seller;

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

      insert_test_customer_person(p_person_id_out => v_customer_person_id);

      insert_test_seller_person(p_person_id_out => v_seller_person_id);

      insert_test_user(p_person_id => v_customer_person_id,
                       p_user_id_out => v_customer_user_id);

      insert_test_user(p_person_id => v_seller_person_id,
                       p_user_id_out => v_seller_user_id);

      insert_test_customer(p_user_id => v_customer_user_id);

      -- Is the customer a customer?
      check_this :=
       USERS_MANAGEMENT.IS_CUSTOMER (
        P_USER_ID => v_customer_user_id
        );

      against_this := TRUE;

      -- The customer should be a customer..
      utAssert.eq (
         'Test of IS_CUSTOMER for a registered customer',
         check_this,
         against_this
         );

      against_this := FALSE;

      -- Is the seller a customer?
      check_this :=
      USERS_MANAGEMENT.IS_CUSTOMER (
         P_USER_ID => v_seller_user_id
       );

      -- The seller should NOT be a customer
      utAssert.eq (
        'Test of IS_CUSTOMER for non customer user',
        check_this,
        against_this
        );

      -- Making the seller a customer too!
      insert_test_customer(v_seller_user_id);

      against_this := TRUE;

      -- Is the seller a customer now?
      check_this :=
      USERS_MANAGEMENT.IS_CUSTOMER (
         P_USER_ID => v_seller_user_id
       );

      -- The seller should be a customer  too!
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
     insert_test_seller_person(p_person_id_out => v_seller_person_id);

     insert_test_customer_person(p_person_id_out => v_customer_person_id);

     insert_test_user(p_person_id => v_seller_person_id,
                      p_user_id_out => v_seller_user_id);

     insert_test_user(p_person_id => v_customer_person_id,
                      p_user_id_out => v_customer_user_id);

     insert_test_seller(p_user_id => v_seller_user_id);

      -- Seller is a seller !
      check_this :=
      USERS_MANAGEMENT.IS_SELLER (
         P_USER_ID => v_seller_user_id
       );

      against_this := TRUE;

      utAssert.eq (
         'Test of IS_SELLER for a registered seller',
         check_this,
         against_this
         );

      -- Is the customer a seller?
      check_this :=
       USERS_MANAGEMENT.IS_SELLER (
          P_USER_ID => v_customer_user_id
        );

      against_this := FALSE;

      utAssert.eq (
          'Test of IS_SELLER for a non seller user',
          check_this,
          against_this
          );

      --Make the customer a seller too!

      insert_test_seller(p_user_id => v_customer_user_id);

      against_this := TRUE;

      check_this :=
       USERS_MANAGEMENT.IS_SELLER (
        P_USER_ID => v_customer_user_id
        );

      -- Checking the customer is seller too!
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
