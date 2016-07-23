CREATE OR REPLACE PACKAGE error_nums
AS
  c_invalid_user_type CONSTANT errors.error_id%type := -20000;

  /* Getter function for c_invalid_user_type constant */
  FUNCTION invalid_user_type
  RETURN errors.error_id%type RESULT_CACHE;

END error_nums;
/
