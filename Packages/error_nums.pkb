CREATE OR REPLACE PACKAGE BODY error_nums
AS

  FUNCTION invalid_user_type
  RETURN errors.error_id%type RESULT_CACHE
  AS
  BEGIN
    RETURN c_invalid_user_type;
  END invalid_user_type;

END error_nums;
/
