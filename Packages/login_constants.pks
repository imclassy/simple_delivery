CREATE OR REPLACE PACKAGE login_constants
AS
  c_customer_user_type CONSTANT types.user_type := 'C';
  c_seller_user_type CONSTANT types.user_type := 'S';

  FUNCTION customer_user_type
  RETURN types.user_type DETERMINISTIC;

  FUNCTION seller_user_type
  RETURN types.user_type DETERMINISTIC;

END login_constants;
/
