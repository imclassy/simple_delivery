CREATE OR REPLACE PACKAGE error_mng
AS
  /* Description: Error management package for business errors */

  -- Raises an error and logs it with the scope and params of the caller program
  PROCEDURE raise (p_error_id errors.error_id%type,
                   p_extra_msg errors.message%type DEFAULT NULL);
END error_mng;
/
