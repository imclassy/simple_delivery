CREATE OR REPLACE PACKAGE login
AS
  FUNCTION valid_login(p_user_id users.user_id%type,
                       p_user_type types.user_type,
                       p_password users.password%type)
  RETURN NUMBER RESULT_CACHE;

  FUNCTION valid_password(p_user_id users.user_id%type,
                          p_password users.password%type)
  RETURN boolean RESULT_CACHE;

END login;
/
