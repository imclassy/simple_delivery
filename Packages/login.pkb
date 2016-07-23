CREATE OR REPLACE PACKAGE BODY login
AS
  FUNCTION valid_login(p_user_id users.user_id%type,
                       p_user_type types.user_type,
                       p_password users.password%type)
  RETURN NUMBER RESULT_CACHE
  AS
    v_valid NUMBER := 0;
  begin
    IF p_user_type = login_constants.c_customer_user_type THEN
      IF users_management.is_customer(p_user_id) THEN
        IF valid_password(p_user_id, p_password) THEN
          v_valid := 1;
        END IF;
      END IF;
    ELSIF p_user_type = login_constants.c_seller_user_type THEN
      IF users_management.is_seller(p_user_id) THEN
        IF valid_password(p_user_id, p_password) THEN
          v_valid := 1;
        END IF;
      END IF;
    ELSE
      raise_application_error(-20000,'Wrong user type');
    END IF;

    RETURN v_valid;
  END valid_login;

  FUNCTION valid_password(p_user_id users.user_id%type,
                          p_password users.password%type)
  RETURN boolean RESULT_CACHE
  AS
    v_valid boolean := false;
  begin
    -- TO DO!!!
    RETURN v_valid;
  END valid_password;

END login;
/
