CREATE OR REPLACE PACKAGE BODY login
AS
  FUNCTION md5(p_string VARCHAR2)
  RETURN users.password%type
  AS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'md5';
    v_params logger.tab_param;
  BEGIN
    logger.append_param(v_params, 'p_string', p_string);

    RETURN dbms_lob.substr(dbms_crypto.hash(to_clob(p_string), 2),
                           4000,
                           1);
  EXCEPTION
   WHEN OTHERS THEN
      logger.log_error('Unhandled Exception', v_scope, null, v_params);
      RAISE;
  END md5;
  
  FUNCTION valid_login(p_user_id users.user_id%type,
                       p_user_type types.user_type,
                       p_password users.password%type)
  RETURN NUMBER RESULT_CACHE
  AS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'valid_login';
    v_params logger.tab_param;
    v_valid NUMBER := 0;
  begin
    logger.append_param(v_params, 'p_user_id', p_user_id);
    logger.append_param(v_params, 'p_user_type', p_user_type);
    logger.append_param(v_params, 'p_password', p_password);
    logger.log('START', v_scope, null, v_params);

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
      error_mng.raise(p_error_id => error_nums.c_invalid_user_type,
                      p_extra_msg => ': '||p_user_type);
    END IF;

    logger.log('END', v_scope);
    RETURN v_valid;
  EXCEPTION
    WHEN OTHERS THEN
      logger.log_error('Unhandled Exception', v_scope, null, v_params);
      RAISE;
  END valid_login;

  FUNCTION valid_password(p_user_id users.user_id%type,
                          p_password users.password%type)
  RETURN boolean RESULT_CACHE
  AS
    v_scope logger_logs.scope%type := gc_scope_prefix || 'valid_password';
    v_params logger.tab_param;
    v_valid boolean := false;
    v_user tapi_users.users_rt;
    v_user_exists boolean := true;
  begin
    logger.append_param(v_params, 'p_user_id', p_user_id);
    logger.append_param(v_params, 'p_password', p_password);
    logger.log('START', v_scope, null, v_params);

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

    logger.log('END', v_scope);
    RETURN v_valid;
  EXCEPTION
    WHEN OTHERS THEN
      logger.log_error('Unhandled Exception', v_scope, null, v_params);
      RAISE;
  END valid_password;

END login;
/
