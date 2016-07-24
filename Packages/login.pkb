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
    v_user tapi_users.users_rt;
    v_user_exists boolean := true;
  begin
    <<get_user>>
    BEGIN
      v_user := tapi_users.rt(p_user_id);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_user_exists := false;
    END get_user;

    IF v_user_exists THEN
      IF v_user.password = md5(p_password) THEN
        v_valid := true;
      END IF;
    END IF;
    
    RETURN v_valid;
  END valid_password;

  FUNCTION md5(p_string VARCHAR2)
  RETURN CLOB
  AS
  BEGIN
    RETURN to_clob(dbms_crypto.hash(to_clob(p_string), 2));
  END md5;

END login;
/
