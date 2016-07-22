CREATE OR REPLACE PACKAGE login_constants
AS
  c_client_user_type CONSTANT VARCHAR2(1) := 'C';
  c_seller_user_type CONSTANT VARCHAR2(1) := 'S';
END login_constants;
/
