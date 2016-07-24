CREATE OR REPLACE PACKAGE error_mng
AS
  /* Description: Error management package for business errors */

  /* Description: Raises an error based on the error code in ERRORS table
     Exceptions: invalid_user_type */
  PROCEDURE raise (p_error_id errors.error_id%type,
                   p_extra_msg errors.message%type DEFAULT NULL);
END error_mng;
/
