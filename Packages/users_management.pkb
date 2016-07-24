CREATE OR REPLACE PACKAGE BODY users_management
AS
  FUNCTION is_customer(p_user_id users.user_id%type)
  RETURN boolean RESULT_CACHE
  AS
    v_exists boolean := true;
    v_customer tapi_customers.customers_rt;
  begin
    <<search_customer>>
    BEGIN
      v_customer := tapi_customers.rt(p_user_id);
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
    v_seller tapi_sellers.sellers_rt;
  begin
    <<get_seller>>
    BEGIN
      v_seller := tapi_sellers.rt(p_user_id);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_exists := false;
    END get_seller;

    RETURN v_exists;
  END is_seller;

END users_management;
/
