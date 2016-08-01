set serveroutput on size 100000;
set linesize 2000;
SPOOL tests_results.txt REPLACE;
BEGIN
   utsuite.ADD('simple_delivery');
   utpackage.ADD('simple_delivery','users_management');
   utpackage.ADD('simple_delivery','login');
   utplsql.testsuite('simple_delivery',recompile_in => FALSE);
END;
/
SPOOL OFF;
/
