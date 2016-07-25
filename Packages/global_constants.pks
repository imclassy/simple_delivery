CREATE OR REPLACE PACKAGE global_constants
AS
  c_active_state CONSTANT states.state_id%type := 1;
  c_inactive_state CONSTANT states.state_id%type := 2;

  -- Getter function for c_active_state
  FUNCTION active_state
  RETURN states.state_id%type RESULT_CACHE;

  -- Getter function for c_inactive_state
  FUNCTION inactive_state
  RETURN states.state_id%type RESULT_CACHE;

END global_constants;
/
