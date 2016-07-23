CREATE OR REPLACE PACKAGE BODY login_constants
AS

  FUNCTION customer_user_type
  RETURN types.user_type DETERMINISTIC
  AS
  begin
    RETURN c_customer_user_type;
  END customer_user_type;

  FUNCTION seller_user_type
  RETURN types.user_type DETERMINISTIC
  AS
  begin
    RETURN c_seller_user_type;
  END seller_user_type;

END login_constants;
/
