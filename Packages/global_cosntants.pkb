CREATE OR REPLACE PACKAGE BODY global_constants
AS

  FUNCTION active_state
  RETURN states.state_id%type RESULT_CACHE
  AS
  BEGIN
    RETURN c_active_state;
  END active_state;

  FUNCTION inactive_state
  RETURN states.state_id%type RESULT_CACHE
  AS
  BEGIN
    RETURN c_inactive_state;
  END inactive_state;


END global_constants;
/
