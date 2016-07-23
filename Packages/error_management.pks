CREATE OR REPLACE PACKAGE error_management
AS
  -- Raises an error and logs it with the scope and params of the caller program
  PROCEDURE raise (p_scope logger_logs.scope%type,
                   p_params logger.tab_param,
                   p_error_id errors.error_id%type,
                   p_extra_msg errors.message%type DEFAULT NULL);

END error_management;
/
