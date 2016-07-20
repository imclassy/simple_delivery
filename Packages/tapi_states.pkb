create or replace PACKAGE BODY tapi_states IS

   /**
   * TAPI_STATES
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 20-JUL-2016 11:48
   * Created By: SIMPLE_DELIVERY
   */

    --Global logger scope
    gc_scope_prefix CONSTANT varchar2(31) := LOWER($$plsql_unit)||'.';

   --GLOBAL_PRIVATE_CURSORS
   --By PK
   CURSOR states_cur (
                       p_state_id IN states.state_id%TYPE
                       )
   IS
      SELECT
            state_id,
            name,
            tapi_states.hash(state_id),
            ROWID
      FROM states
      WHERE
           state_id = states_cur.p_state_id
      FOR UPDATE;

    --By Rowid
    CURSOR states_rowid_cur (p_rowid IN VARCHAR2)
    IS
      SELECT
             state_id,
             name,
             tapi_states.hash(state_id),
             ROWID
      FROM states
      WHERE ROWID = p_rowid
      FOR UPDATE;


    FUNCTION hash (
                  p_state_id IN states.state_id%TYPE
                  )
      RETURN varchar2
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'hash';
      l_params logger.tab_param;
      l_retval hash_t;
      l_string CLOB;
      l_date_format VARCHAR2(64);
   BEGIN

      logger.append_param(l_params, 'p_state_id', p_state_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Getting row data into one string', l_scope);

     --Get actual NLS_DATE_FORMAT
     SELECT   VALUE
       INTO   l_date_format
       FROM   v$nls_parameters
      WHERE   parameter = 'NLS_DATE_FORMAT';

      --Alter session for date columns
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''YYYY/MM/DD hh24:mi:ss''';

      SELECT
            state_id||
            name
      INTO l_string
      FROM states
      WHERE
           state_id = hash.p_state_id
           ;

      --Restore NLS_DATE_FORMAT to default
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''' || l_date_format|| '''';

      logger.LOG('Converting into SHA1 hash', l_scope);
      l_retval := DBMS_CRYPTO.hash(l_string, DBMS_CRYPTO.hash_sh1);
      logger.LOG('END', l_scope);

      RETURN l_retval;

   EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   END hash;

    FUNCTION hash_rowid (p_rowid IN varchar2)
      RETURN varchar2
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'hash_rowid';
      l_params logger.tab_param;
      l_retval hash_t;
      l_string CLOB;
      l_date_format varchar2(64);
   BEGIN
      logger.append_param(l_params, 'p_rowid', p_rowid);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Getting row data into one string', l_scope);

      --Get actual NLS_DATE_FORMAT
      SELECT VALUE INTO l_date_format  FROM v$nls_parameters WHERE parameter ='NLS_DATE_FORMAT';

      --Alter session for date columns
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''YYYY/MM/DD hh24:mi:ss''';

      SELECT
            state_id||
            name
      INTO l_string
      FROM states
      WHERE  ROWID = hash_rowid.p_rowid;

      --Restore NLS_DATE_FORMAT to default
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''' || l_date_format|| '''';

      logger.LOG('Converting into SHA1 hash', l_scope);
      l_retval := DBMS_CRYPTO.hash(l_string, DBMS_CRYPTO.hash_sh1);

      logger.LOG('END', l_scope);
      RETURN l_retval;

   EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   END hash_rowid;

   FUNCTION rt (
               p_state_id IN states.state_id%TYPE
               )
      RETURN states_rt RESULT_CACHE
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'rt';
      l_params logger.tab_param;
      l_states_rec states_rt;
   BEGIN
      logger.append_param(l_params, 'p_state_id', p_state_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Populating record type from DB', l_scope);

      SELECT a.*,
             tapi_states.hash(state_id),
             rowid
      INTO l_states_rec
      FROM states a
      WHERE
           state_id = rt.p_state_id
           ;

      logger.LOG('END', l_scope);

      RETURN l_states_rec;

   EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   END rt;

   FUNCTION rt_for_update (
                          p_state_id IN states.state_id%TYPE
                          )
      RETURN states_rt RESULT_CACHE
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'rt_for_update';
      l_params logger.tab_param;
      l_states_rec states_rt;
   BEGIN

      logger.append_param(l_params, 'p_state_id', p_state_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Populating record type from DB', l_scope);

      SELECT a.*,
             tapi_states.hash(state_id),
             rowid
      INTO l_states_rec
      FROM states a
      WHERE
           state_id = rt_for_update.p_state_id
      FOR UPDATE;

      logger.LOG('END', l_scope);

      RETURN l_states_rec;

   EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   END rt_for_update;

    FUNCTION tt (
                p_state_id IN states.state_id%TYPE DEFAULT NULL
                )
       RETURN states_tt
       PIPELINED
    IS
       l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'tt';
       l_params logger.tab_param;
       l_states_rec   states_rt;
    BEGIN
      logger.append_param(l_params, 'p_state_id', tt.p_state_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Populating record type from DB', l_scope);

       FOR c1 IN (SELECT   a.*, ROWID
                    FROM   states a
                   WHERE
                        state_id = NVL(tt.p_state_id,state_id)
                        )
       LOOP
              l_states_rec.state_id := c1.state_id;
              l_states_rec.name := c1.name;
              l_states_rec.hash := tapi_states.hash( c1.state_id);
              l_states_rec.row_id := c1.ROWID;
              PIPE ROW (l_states_rec);
       END LOOP;

       logger.LOG('END', l_scope);

       RETURN;

    EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
    END tt;


    PROCEDURE ins (p_states_rec IN OUT states_rt)
    IS
        l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'ins';
        l_params logger.tab_param;
        l_rowtype     states%ROWTYPE;

    BEGIN
        logger.append_param(l_params, 'p_states_rec.state_id', ins.p_states_rec.state_id);
        logger.append_param(l_params, 'p_states_rec.name', ins.p_states_rec.name);
        logger.LOG('START', l_scope, NULL, l_params);
        logger.LOG('Inserting data', l_scope);


        l_rowtype.state_id := ins.p_states_rec.state_id;
        l_rowtype.name := ins.p_states_rec.name;

       INSERT INTO states
         VALUES   l_rowtype;

       logger.LOG('END', l_scope);

    EXCEPTION
      WHEN OTHERS
      THEN
         logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
         RAISE;
    END ins;

    PROCEDURE upd (
                  p_states_rec         IN states_rt,
                  p_ignore_nulls         IN boolean := FALSE
                  )
    IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'upd';
      l_params logger.tab_param;
    BEGIN
       logger.append_param(l_params, 'p_states_rec.state_id', upd.p_states_rec.state_id);
       logger.append_param(l_params, 'p_states_rec.name', upd.p_states_rec.name);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);

       IF NVL (p_ignore_nulls, FALSE)
       THEN
          UPDATE   states
             SET state_id = NVL(p_states_rec.state_id,state_id),
                name = NVL(p_states_rec.name,name)
           WHERE
                state_id = upd.p_states_rec.state_id
                ;
       ELSE
          UPDATE   states
             SET state_id = p_states_rec.state_id,
                name = p_states_rec.name
           WHERE
                state_id = upd.p_states_rec.state_id
                ;
       END IF;

       IF SQL%ROWCOUNT != 1 THEN RAISE e_upd_failed; END IF;
       logger.LOG('END', l_scope);

    EXCEPTION
       WHEN e_upd_failed
       THEN
          raise_application_error (-20000, 'No rows were updated. The update failed.');
       WHEN OTHERS
       THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
    END upd;


    PROCEDURE upd_rowid (
                         p_states_rec         IN states_rt,
                         p_ignore_nulls         IN boolean := FALSE
                        )
    IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'upd_rowid';
      l_params logger.tab_param;
    BEGIN
       logger.append_param(l_params, 'p_states_rec.state_id', upd_rowid.p_states_rec.state_id);
       logger.append_param(l_params, 'p_states_rec.name', upd_rowid.p_states_rec.name);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);

       IF NVL (p_ignore_nulls, FALSE)
       THEN
          UPDATE   states
             SET state_id = NVL(p_states_rec.state_id,state_id),
                name = NVL(p_states_rec.name,name)
           WHERE  ROWID = p_states_rec.row_id;
       ELSE
          UPDATE   states
             SET state_id = p_states_rec.state_id,
                name = p_states_rec.name
           WHERE  ROWID = p_states_rec.row_id;
       END IF;

       IF SQL%ROWCOUNT != 1 THEN RAISE e_upd_failed; END IF;
       logger.LOG('END', l_scope);

    EXCEPTION
       WHEN e_upd_failed
       THEN
          raise_application_error (-20000, 'No rows were updated. The update failed.');
       WHEN OTHERS
       THEN
          logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
          RAISE;
    END upd_rowid;

   PROCEDURE web_upd (
                  p_states_rec         IN states_rt,
                  p_ignore_nulls         IN boolean := FALSE
                )
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_upd';
      l_params logger.tab_param;
      l_states_rec states_rt;
   BEGIN
       logger.append_param(l_params, 'p_states_rec.state_id', web_upd.p_states_rec.state_id);
       logger.append_param(l_params, 'p_states_rec.name', web_upd.p_states_rec.name);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);

      OPEN states_cur(
                             web_upd.p_states_rec.state_id
                        );

      FETCH states_cur INTO l_states_rec;

      IF states_cur%NOTFOUND THEN
         CLOSE states_cur;
         RAISE e_row_missing;
      ELSE
         IF p_states_rec.hash != l_states_rec.hash THEN
            CLOSE states_cur;
            RAISE e_ol_check_failed;
         ELSE
            IF NVL(p_ignore_nulls, FALSE)
            THEN

                UPDATE   states
                   SET state_id = NVL(p_states_rec.state_id,state_id),
                       name = NVL(p_states_rec.name,name)
               WHERE CURRENT OF states_cur;
            ELSE
                UPDATE   states
                   SET state_id = p_states_rec.state_id,
                       name = p_states_rec.name
               WHERE CURRENT OF states_cur;
            END IF;

            CLOSE states_cur;
         END IF;
      END IF;

      logger.LOG('END', l_scope);

   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Update operation failed because the row is no longer in the database.');
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   END web_upd;

   PROCEDURE web_upd_rowid (
                            p_states_rec    IN states_rt,
                            p_ignore_nulls         IN boolean := FALSE
                           )
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_upd_rowid';
      l_params logger.tab_param;
      l_states_rec states_rt;
   BEGIN
       logger.append_param(l_params, 'p_states_rec.state_id', web_upd_rowid.p_states_rec.state_id);
       logger.append_param(l_params, 'p_states_rec.name', web_upd_rowid.p_states_rec.name);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);

      OPEN states_rowid_cur(web_upd_rowid.p_states_rec.row_id);

      FETCH states_rowid_cur INTO l_states_rec;

      IF states_rowid_cur%NOTFOUND THEN
         CLOSE states_rowid_cur;
         RAISE e_row_missing;
      ELSE
         IF web_upd_rowid.p_states_rec.hash != l_states_rec.hash THEN
            CLOSE states_rowid_cur;
            RAISE e_ol_check_failed;
         ELSE
            IF NVL(web_upd_rowid.p_ignore_nulls, FALSE)
            THEN
                UPDATE   states
                   SET state_id = NVL(p_states_rec.state_id,state_id),
                       name = NVL(p_states_rec.name,name)
               WHERE CURRENT OF states_rowid_cur;
            ELSE
                UPDATE   states
                   SET state_id = p_states_rec.state_id,
                       name = p_states_rec.name
               WHERE CURRENT OF states_rowid_cur;
            END IF;

            CLOSE states_rowid_cur;
         END IF;
      END IF;

      logger.LOG('END', l_scope);

   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Update operation failed because the row is no longer in the database.');
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   END web_upd_rowid;

    PROCEDURE del (
                  p_state_id IN states.state_id%TYPE
                  )
    IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'del';
      l_params logger.tab_param;
    BEGIN
      logger.append_param(l_params, 'p_state_id', del.p_state_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Deleting record', l_scope);

       DELETE FROM   states
             WHERE
                  state_id = del.p_state_id
                   ;

       IF sql%ROWCOUNT != 1
       THEN
          RAISE e_del_failed;
       END IF;

       logger.LOG('END', l_scope);

    EXCEPTION
       WHEN e_del_failed
       THEN
          raise_application_error (-20000, 'No rows were deleted. The delete failed.');
       WHEN OTHERS
       THEN
          logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
          RAISE;
    END del;

    PROCEDURE del_rowid (p_rowid IN varchar2)
    IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'del_rowid';
      l_params logger.tab_param;
    BEGIN
       logger.append_param(l_params, 'p_rowid', del_rowid.p_rowid);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Deleting record', l_scope);

       DELETE FROM   states
             WHERE   ROWID = del_rowid.p_rowid;

       IF sql%ROWCOUNT != 1
       THEN
          RAISE e_del_failed;
       END IF;

       logger.LOG('END', l_scope);

    EXCEPTION
       WHEN e_del_failed
       THEN
          raise_application_error (-20000, 'No rows were deleted. The delete failed.');
       WHEN OTHERS
       THEN
          logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
          RAISE;
    END del_rowid;

    PROCEDURE web_del (
                      p_state_id IN states.state_id%TYPE,
                      p_hash IN varchar2
                      )
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_del';
      l_params logger.tab_param;
      l_states_rec states_rt;
   BEGIN

      logger.append_param(l_params, 'p_state_id', web_del.p_state_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Deleting record', l_scope);

      OPEN states_cur(
                            web_del.p_state_id
                            );

      FETCH states_cur INTO l_states_rec;

      IF states_cur%NOTFOUND THEN
         CLOSE states_cur;
         RAISE e_row_missing;
      ELSE
         IF web_del.p_hash != l_states_rec.hash THEN
            CLOSE states_cur;
            RAISE e_ol_check_failed;
         ELSE
            DELETE FROM states
            WHERE CURRENT OF states_cur;

            CLOSE states_cur;
         END IF;
      END IF;


      logger.LOG('END', l_scope);

   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Delete operation failed because the row is no longer in the database.');
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   END web_del;

   PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2)
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_del_rowid';
      l_params logger.tab_param;
      l_states_rec states_rt;
   BEGIN

      logger.append_param(l_params, 'p_rowid', web_del_rowid.p_rowid);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Deleting record', l_scope);

      OPEN states_rowid_cur(web_del_rowid.p_rowid);

      FETCH states_rowid_cur INTO l_states_rec;

      IF states_rowid_cur%NOTFOUND THEN
         CLOSE states_rowid_cur;
         RAISE e_row_missing;
      ELSE
         IF web_del_rowid.p_hash != l_states_rec.hash THEN
            CLOSE states_rowid_cur;
            RAISE e_ol_check_failed;
         ELSE
            DELETE FROM states
            WHERE CURRENT OF states_rowid_cur;

            CLOSE states_rowid_cur;
         END IF;
      END IF;

      logger.LOG('END', l_scope);
   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Delete operation failed because the row is no longer in the database.');
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   END web_del_rowid;

END tapi_states;

 /
