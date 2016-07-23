CREATE OR REPLACE PACKAGE users_management
AS
  FUNCTION is_customer(p_user_id users.user_id%type)
  RETURN boolean RESULT_CACHE;

  FUNCTION is_seller(p_user_id users.user_id%type)
  RETURN boolean RESULT_CACHE;
END users_management;
/
