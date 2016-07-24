CREATE OR REPLACE PACKAGE types
AS
  SUBTYPE user_type IS VARCHAR2(1);
  SUBTYPE max_varchar_sql IS VARCHAR2(4000);
  SUBTYPE max_varchar_plsql IS VARCHAR2(32767);
  SUBTYPE object_length IS VARCHAR2(30);
  SUBTYPE scope_prefix IS VARCHAR2(31);
END types;
/
