DECLARE
   v_sql varchar2(32000);
BEGIN
   FOR obj IN (SELECT object_name NAME
                 FROM user_objects
                WHERE object_type = 'PACKAGE')
   loop

      v_sql := 'GRANT EXECUTE ON SIMPLE_DELIVERY.'||obj.name||' TO SIMPLE_DELIVERY_UTP';
      EXECUTE IMMEDIATE v_sql;


   END loop;
END;
/

DECLARE
   v_sql varchar2(32000);
BEGIN
   FOR obj IN (SELECT table_name NAME
                 FROM user_tables)
   loop

      v_sql := 'GRANT SELECT ON SIMPLE_DELIVERY.'||obj.name||' TO SIMPLE_DELIVERY_UTP';
      EXECUTE IMMEDIATE v_sql;

   END loop;
END;
/
