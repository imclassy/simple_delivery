DECLARE
   v_sql varchar2(32000);
BEGIN
   FOR obj IN (SELECT table_name NAME
                 FROM user_tables
                UNION
               SELECT object_name NAME
                 FROM user_objects
                WHERE object_type = 'PACKAGE')
   loop

      v_sql := 'CREATE OR REPLACE PUBLIC SYNONYM '||obj.NAME||' FOR '||
                'SIMPLE_DELIVERY.'||obj.NAME;
      EXECUTE IMMEDIATE v_sql;


   END loop;
END;
/
