echo off
exit | sqlplus -S simple_delivery_utp/123456@localhost:1521/pdborcl @"run_tests.sql"
del "processed_tests_results.txt"
java -jar testResults.jar
echo Tests runned successfully, see tests results in processed_tests_results file!
pause