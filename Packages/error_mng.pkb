CREATE OR REPLACE PACKAGE BODY error_mng
AS
  -- Raises an error based on the error code in ERRORS table
  PROCEDURE raise (p_error_id errors.error_id%type,
                   p_extra_msg errors.message%type DEFAULT NULL)
  AS
    v_error tapi_errors.errors_rt;
  BEGIN
    <<get_error>>
    BEGIN
      v_error := tapi_errors.rt(p_error_id);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        raise_application_error(error_nums.c_invalid_error_id,
                                'Invalid error id: '||p_error_id);
    END get_error;

    raise_application_error(v_error.error_id,v_error.message||nvl(p_extra_msg,''));
  END raise;
END error_mng;
/
