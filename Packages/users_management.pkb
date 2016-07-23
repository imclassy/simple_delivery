CREATE OR REPLACE PACKAGE BODY users_management
AS
  FUNCTION is_customer(p_user_id users.user_id%type)
  RETURN boolean RESULT_CACHE
  AS
    v_exists boolean := true;
    v_dummy NUMBER;
  begin
    <<search_customer>>
    BEGIN
      SELECT 1
        INTO v_dummy
        FROM customers
       WHERE user_id = p_user_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_exists := false;
    END search_customer;

    RETURN v_exists;
  END is_customer;

  FUNCTION is_seller(p_user_id users.user_id%type)
  RETURN boolean RESULT_CACHE
  AS
    v_exists boolean := true;
    v_dummy NUMBER;
  begin
    <<search_seller>>
    BEGIN
      SELECT 1
        INTO v_dummy
        FROM sellers
       WHERE user_id = p_user_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_exists := false;
    END search_seller;

    RETURN v_exists;
  END is_seller;

END users_management;
/
