create or replace PACKAGE BODY tapi_orders_details IS

   /**
   * TAPI_ORDERS_DETAILS
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 20-JUL-2016 11:49
   * Created By: SIMPLE_DELIVERY
   */

    --Global logger scope
    gc_scope_prefix CONSTANT varchar2(31) := LOWER($$plsql_unit)||'.';

   --GLOBAL_PRIVATE_CURSORS
   --By PK
   CURSOR orders_details_cur (
                       p_orders_details_id IN orders_details.orders_details_id%TYPE
                       )
   IS
      SELECT
            orders_details_id,
            article_id,
            order_id,
            quantity,
            tapi_orders_details.hash(orders_details_id),
            ROWID
      FROM orders_details
      WHERE
           orders_details_id = orders_details_cur.p_orders_details_id
      FOR UPDATE;

    --By Rowid
    CURSOR orders_details_rowid_cur (p_rowid IN VARCHAR2)
    IS
      SELECT
             orders_details_id,
             article_id,
             order_id,
             quantity,
             tapi_orders_details.hash(orders_details_id),
             ROWID
      FROM orders_details
      WHERE ROWID = p_rowid
      FOR UPDATE;


    FUNCTION hash (
                  p_orders_details_id IN orders_details.orders_details_id%TYPE
                  )
      RETURN varchar2
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'hash';
      l_params logger.tab_param;
      l_retval hash_t;
      l_string CLOB;
      l_date_format VARCHAR2(64);
   BEGIN

      logger.append_param(l_params, 'p_orders_details_id', p_orders_details_id);
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
            orders_details_id||
            article_id||
            order_id||
            quantity
      INTO l_string
      FROM orders_details
      WHERE
           orders_details_id = hash.p_orders_details_id
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
            orders_details_id||
            article_id||
            order_id||
            quantity
      INTO l_string
      FROM orders_details
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
               p_orders_details_id IN orders_details.orders_details_id%TYPE
               )
      RETURN orders_details_rt RESULT_CACHE
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'rt';
      l_params logger.tab_param;
      l_orders_details_rec orders_details_rt;
   BEGIN
      logger.append_param(l_params, 'p_orders_details_id', p_orders_details_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Populating record type from DB', l_scope);

      SELECT a.*,
             tapi_orders_details.hash(orders_details_id),
             rowid
      INTO l_orders_details_rec
      FROM orders_details a
      WHERE
           orders_details_id = rt.p_orders_details_id
           ;

      logger.LOG('END', l_scope);

      RETURN l_orders_details_rec;

   EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   END rt;

   FUNCTION rt_for_update (
                          p_orders_details_id IN orders_details.orders_details_id%TYPE
                          )
      RETURN orders_details_rt RESULT_CACHE
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'rt_for_update';
      l_params logger.tab_param;
      l_orders_details_rec orders_details_rt;
   BEGIN

      logger.append_param(l_params, 'p_orders_details_id', p_orders_details_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Populating record type from DB', l_scope);

      SELECT a.*,
             tapi_orders_details.hash(orders_details_id),
             rowid
      INTO l_orders_details_rec
      FROM orders_details a
      WHERE
           orders_details_id = rt_for_update.p_orders_details_id
      FOR UPDATE;

      logger.LOG('END', l_scope);

      RETURN l_orders_details_rec;

   EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   END rt_for_update;

    FUNCTION tt (
                p_orders_details_id IN orders_details.orders_details_id%TYPE DEFAULT NULL
                )
       RETURN orders_details_tt
       PIPELINED
    IS
       l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'tt';
       l_params logger.tab_param;
       l_orders_details_rec   orders_details_rt;
    BEGIN
      logger.append_param(l_params, 'p_orders_details_id', tt.p_orders_details_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Populating record type from DB', l_scope);

       FOR c1 IN (SELECT   a.*, ROWID
                    FROM   orders_details a
                   WHERE
                        orders_details_id = NVL(tt.p_orders_details_id,orders_details_id)
                        )
       LOOP
              l_orders_details_rec.orders_details_id := c1.orders_details_id;
              l_orders_details_rec.article_id := c1.article_id;
              l_orders_details_rec.order_id := c1.order_id;
              l_orders_details_rec.quantity := c1.quantity;
              l_orders_details_rec.hash := tapi_orders_details.hash( c1.orders_details_id);
              l_orders_details_rec.row_id := c1.ROWID;
              PIPE ROW (l_orders_details_rec);
       END LOOP;

       logger.LOG('END', l_scope);

       RETURN;

    EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
    END tt;


    PROCEDURE ins (p_orders_details_rec IN OUT orders_details_rt)
    IS
        l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'ins';
        l_params logger.tab_param;
        l_rowtype     orders_details%ROWTYPE;

    BEGIN
        logger.append_param(l_params, 'p_orders_details_rec.orders_details_id', ins.p_orders_details_rec.orders_details_id);
        logger.append_param(l_params, 'p_orders_details_rec.article_id', ins.p_orders_details_rec.article_id);
        logger.append_param(l_params, 'p_orders_details_rec.order_id', ins.p_orders_details_rec.order_id);
        logger.append_param(l_params, 'p_orders_details_rec.quantity', ins.p_orders_details_rec.quantity);
        logger.LOG('START', l_scope, NULL, l_params);
        logger.LOG('Inserting data', l_scope);


        l_rowtype.orders_details_id := ins.p_orders_details_rec.orders_details_id;
        l_rowtype.article_id := ins.p_orders_details_rec.article_id;
        l_rowtype.order_id := ins.p_orders_details_rec.order_id;
        l_rowtype.quantity := ins.p_orders_details_rec.quantity;

       INSERT INTO orders_details
         VALUES   l_rowtype;

       logger.LOG('END', l_scope);

    EXCEPTION
      WHEN OTHERS
      THEN
         logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
         RAISE;
    END ins;

    PROCEDURE upd (
                  p_orders_details_rec         IN orders_details_rt,
                  p_ignore_nulls         IN boolean := FALSE
                  )
    IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'upd';
      l_params logger.tab_param;
    BEGIN
       logger.append_param(l_params, 'p_orders_details_rec.orders_details_id', upd.p_orders_details_rec.orders_details_id);
       logger.append_param(l_params, 'p_orders_details_rec.article_id', upd.p_orders_details_rec.article_id);
       logger.append_param(l_params, 'p_orders_details_rec.order_id', upd.p_orders_details_rec.order_id);
       logger.append_param(l_params, 'p_orders_details_rec.quantity', upd.p_orders_details_rec.quantity);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);

       IF NVL (p_ignore_nulls, FALSE)
       THEN
          UPDATE   orders_details
             SET orders_details_id = NVL(p_orders_details_rec.orders_details_id,orders_details_id),
                article_id = NVL(p_orders_details_rec.article_id,article_id),
                order_id = NVL(p_orders_details_rec.order_id,order_id),
                quantity = NVL(p_orders_details_rec.quantity,quantity)
           WHERE
                orders_details_id = upd.p_orders_details_rec.orders_details_id
                ;
       ELSE
          UPDATE   orders_details
             SET orders_details_id = p_orders_details_rec.orders_details_id,
                article_id = p_orders_details_rec.article_id,
                order_id = p_orders_details_rec.order_id,
                quantity = p_orders_details_rec.quantity
           WHERE
                orders_details_id = upd.p_orders_details_rec.orders_details_id
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
                         p_orders_details_rec         IN orders_details_rt,
                         p_ignore_nulls         IN boolean := FALSE
                        )
    IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'upd_rowid';
      l_params logger.tab_param;
    BEGIN
       logger.append_param(l_params, 'p_orders_details_rec.orders_details_id', upd_rowid.p_orders_details_rec.orders_details_id);
       logger.append_param(l_params, 'p_orders_details_rec.article_id', upd_rowid.p_orders_details_rec.article_id);
       logger.append_param(l_params, 'p_orders_details_rec.order_id', upd_rowid.p_orders_details_rec.order_id);
       logger.append_param(l_params, 'p_orders_details_rec.quantity', upd_rowid.p_orders_details_rec.quantity);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);

       IF NVL (p_ignore_nulls, FALSE)
       THEN
          UPDATE   orders_details
             SET orders_details_id = NVL(p_orders_details_rec.orders_details_id,orders_details_id),
                article_id = NVL(p_orders_details_rec.article_id,article_id),
                order_id = NVL(p_orders_details_rec.order_id,order_id),
                quantity = NVL(p_orders_details_rec.quantity,quantity)
           WHERE  ROWID = p_orders_details_rec.row_id;
       ELSE
          UPDATE   orders_details
             SET orders_details_id = p_orders_details_rec.orders_details_id,
                article_id = p_orders_details_rec.article_id,
                order_id = p_orders_details_rec.order_id,
                quantity = p_orders_details_rec.quantity
           WHERE  ROWID = p_orders_details_rec.row_id;
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
                  p_orders_details_rec         IN orders_details_rt,
                  p_ignore_nulls         IN boolean := FALSE
                )
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_upd';
      l_params logger.tab_param;
      l_orders_details_rec orders_details_rt;
   BEGIN
       logger.append_param(l_params, 'p_orders_details_rec.orders_details_id', web_upd.p_orders_details_rec.orders_details_id);
       logger.append_param(l_params, 'p_orders_details_rec.article_id', web_upd.p_orders_details_rec.article_id);
       logger.append_param(l_params, 'p_orders_details_rec.order_id', web_upd.p_orders_details_rec.order_id);
       logger.append_param(l_params, 'p_orders_details_rec.quantity', web_upd.p_orders_details_rec.quantity);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);

      OPEN orders_details_cur(
                             web_upd.p_orders_details_rec.orders_details_id
                        );

      FETCH orders_details_cur INTO l_orders_details_rec;

      IF orders_details_cur%NOTFOUND THEN
         CLOSE orders_details_cur;
         RAISE e_row_missing;
      ELSE
         IF p_orders_details_rec.hash != l_orders_details_rec.hash THEN
            CLOSE orders_details_cur;
            RAISE e_ol_check_failed;
         ELSE
            IF NVL(p_ignore_nulls, FALSE)
            THEN

                UPDATE   orders_details
                   SET orders_details_id = NVL(p_orders_details_rec.orders_details_id,orders_details_id),
                       article_id = NVL(p_orders_details_rec.article_id,article_id),
                       order_id = NVL(p_orders_details_rec.order_id,order_id),
                       quantity = NVL(p_orders_details_rec.quantity,quantity)
               WHERE CURRENT OF orders_details_cur;
            ELSE
                UPDATE   orders_details
                   SET orders_details_id = p_orders_details_rec.orders_details_id,
                       article_id = p_orders_details_rec.article_id,
                       order_id = p_orders_details_rec.order_id,
                       quantity = p_orders_details_rec.quantity
               WHERE CURRENT OF orders_details_cur;
            END IF;

            CLOSE orders_details_cur;
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
                            p_orders_details_rec    IN orders_details_rt,
                            p_ignore_nulls         IN boolean := FALSE
                           )
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_upd_rowid';
      l_params logger.tab_param;
      l_orders_details_rec orders_details_rt;
   BEGIN
       logger.append_param(l_params, 'p_orders_details_rec.orders_details_id', web_upd_rowid.p_orders_details_rec.orders_details_id);
       logger.append_param(l_params, 'p_orders_details_rec.article_id', web_upd_rowid.p_orders_details_rec.article_id);
       logger.append_param(l_params, 'p_orders_details_rec.order_id', web_upd_rowid.p_orders_details_rec.order_id);
       logger.append_param(l_params, 'p_orders_details_rec.quantity', web_upd_rowid.p_orders_details_rec.quantity);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);

      OPEN orders_details_rowid_cur(web_upd_rowid.p_orders_details_rec.row_id);

      FETCH orders_details_rowid_cur INTO l_orders_details_rec;

      IF orders_details_rowid_cur%NOTFOUND THEN
         CLOSE orders_details_rowid_cur;
         RAISE e_row_missing;
      ELSE
         IF web_upd_rowid.p_orders_details_rec.hash != l_orders_details_rec.hash THEN
            CLOSE orders_details_rowid_cur;
            RAISE e_ol_check_failed;
         ELSE
            IF NVL(web_upd_rowid.p_ignore_nulls, FALSE)
            THEN
                UPDATE   orders_details
                   SET orders_details_id = NVL(p_orders_details_rec.orders_details_id,orders_details_id),
                       article_id = NVL(p_orders_details_rec.article_id,article_id),
                       order_id = NVL(p_orders_details_rec.order_id,order_id),
                       quantity = NVL(p_orders_details_rec.quantity,quantity)
               WHERE CURRENT OF orders_details_rowid_cur;
            ELSE
                UPDATE   orders_details
                   SET orders_details_id = p_orders_details_rec.orders_details_id,
                       article_id = p_orders_details_rec.article_id,
                       order_id = p_orders_details_rec.order_id,
                       quantity = p_orders_details_rec.quantity
               WHERE CURRENT OF orders_details_rowid_cur;
            END IF;

            CLOSE orders_details_rowid_cur;
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
                  p_orders_details_id IN orders_details.orders_details_id%TYPE
                  )
    IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'del';
      l_params logger.tab_param;
    BEGIN
      logger.append_param(l_params, 'p_orders_details_id', del.p_orders_details_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Deleting record', l_scope);

       DELETE FROM   orders_details
             WHERE
                  orders_details_id = del.p_orders_details_id
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

       DELETE FROM   orders_details
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
                      p_orders_details_id IN orders_details.orders_details_id%TYPE,
                      p_hash IN varchar2
                      )
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_del';
      l_params logger.tab_param;
      l_orders_details_rec orders_details_rt;
   BEGIN

      logger.append_param(l_params, 'p_orders_details_id', web_del.p_orders_details_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Deleting record', l_scope);

      OPEN orders_details_cur(
                            web_del.p_orders_details_id
                            );

      FETCH orders_details_cur INTO l_orders_details_rec;

      IF orders_details_cur%NOTFOUND THEN
         CLOSE orders_details_cur;
         RAISE e_row_missing;
      ELSE
         IF web_del.p_hash != l_orders_details_rec.hash THEN
            CLOSE orders_details_cur;
            RAISE e_ol_check_failed;
         ELSE
            DELETE FROM orders_details
            WHERE CURRENT OF orders_details_cur;

            CLOSE orders_details_cur;
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
      l_orders_details_rec orders_details_rt;
   BEGIN

      logger.append_param(l_params, 'p_rowid', web_del_rowid.p_rowid);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Deleting record', l_scope);

      OPEN orders_details_rowid_cur(web_del_rowid.p_rowid);

      FETCH orders_details_rowid_cur INTO l_orders_details_rec;

      IF orders_details_rowid_cur%NOTFOUND THEN
         CLOSE orders_details_rowid_cur;
         RAISE e_row_missing;
      ELSE
         IF web_del_rowid.p_hash != l_orders_details_rec.hash THEN
            CLOSE orders_details_rowid_cur;
            RAISE e_ol_check_failed;
         ELSE
            DELETE FROM orders_details
            WHERE CURRENT OF orders_details_rowid_cur;

            CLOSE orders_details_rowid_cur;
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

END tapi_orders_details;

 /
