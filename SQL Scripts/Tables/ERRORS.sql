DROP TABLE ERRORS;
CREATE TABLE errors
(
  error_id NUMBER PRIMARY KEY,
  message VARCHAR2(4000) NOT NULL
);
ALTER TABLE DROP CONSTRAINT error_id_chk;
ALTER TABLE errors ADD CONSTRAINT error_id_chk CHECK (error_id BETWEEN -20999 AND -20000);

INSERT INTO errors (error_id, message) VALUES (error_nums.invalid_user_type, 'Invalid user type');
COMMIT;
/
