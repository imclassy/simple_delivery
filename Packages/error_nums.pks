CREATE OR REPLACE PACKAGE error_nums
AS
  c_invalid_user_type CONSTANT errors.error_id%type := -20000;
  c_invalid_error_id CONSTANT errors.error_id%type := -20001;

  /* Getter function for c_invalid_user_type constant */
  FUNCTION invalid_user_type
  RETURN errors.error_id%type RESULT_CACHE;

  /* Getter function for c_invalid_error_id constant */
  FUNCTION invalid_error_id
  RETURN errors.error_id%type RESULT_CACHE;

END error_nums;
/
