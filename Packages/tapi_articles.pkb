CREATE OR REPLACE PACKAGE BODY tapi_articles IS

   /**
   * TAPI_ARTICLES
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 26-JUL-2016 13:32
   * Created By: SIMPLE_DELIVERY
   */

    --Global logger scope
    gc_scope_prefix CONSTANT varchar2(31) := LOWER($$plsql_unit)||'.';

   --GLOBAL_PRIVATE_CURSORS
   --By PK
   CURSOR articles_cur (
                       p_article_id IN articles.article_id%TYPE
                       )
   IS
      SELECT
            article_id,
            name,
            code,
            description,
            stock,
            price,
            picture,
            shop_id,
            brand_id,
            article_type_id,
            state_id,
            tapi_articles.hash(article_id),
            ROWID
      FROM articles
      WHERE
           article_id = articles_cur.p_article_id
      FOR UPDATE;

    --By Rowid
    CURSOR articles_rowid_cur (p_rowid IN VARCHAR2)
    IS
      SELECT
             article_id,
             name,
             code,
             description,
             stock,
             price,
             picture,
             shop_id,
             brand_id,
             article_type_id,
             state_id,
             tapi_articles.hash(article_id),
             ROWID
      FROM articles
      WHERE ROWID = p_rowid
      FOR UPDATE;


    FUNCTION hash (
                  p_article_id IN articles.article_id%TYPE
                  )
      RETURN varchar2
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'hash';
      l_params logger.tab_param;
      l_retval hash_t;
      l_string CLOB;
      l_date_format VARCHAR2(64);
   BEGIN

      logger.append_param(l_params, 'p_article_id', p_article_id);
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
            article_id||
            name||
            code||
            description||
            stock||
            price||
            picture||
            shop_id||
            brand_id||
            article_type_id||
            state_id
      INTO l_string
      FROM articles
      WHERE
           article_id = hash.p_article_id
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
            article_id||
            name||
            code||
            description||
            stock||
            price||
            picture||
            shop_id||
            brand_id||
            article_type_id||
            state_id
      INTO l_string
      FROM articles
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
               p_article_id IN articles.article_id%TYPE
               )
      RETURN articles_rt RESULT_CACHE
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'rt';
      l_params logger.tab_param;
      l_articles_rec articles_rt;
   BEGIN
      logger.append_param(l_params, 'p_article_id', p_article_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Populating record type from DB', l_scope);

      SELECT a.*,
             tapi_articles.hash(article_id),
             rowid
      INTO l_articles_rec
      FROM articles a
      WHERE
           article_id = rt.p_article_id
           ;

      logger.LOG('END', l_scope);

      RETURN l_articles_rec;

   EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   END rt;

   FUNCTION rt_for_update (
                          p_article_id IN articles.article_id%TYPE
                          )
      RETURN articles_rt RESULT_CACHE
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'rt_for_update';
      l_params logger.tab_param;
      l_articles_rec articles_rt;
   BEGIN

      logger.append_param(l_params, 'p_article_id', p_article_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Populating record type from DB', l_scope);

      SELECT a.*,
             tapi_articles.hash(article_id),
             rowid
      INTO l_articles_rec
      FROM articles a
      WHERE
           article_id = rt_for_update.p_article_id
      FOR UPDATE;

      logger.LOG('END', l_scope);

      RETURN l_articles_rec;

   EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
   END rt_for_update;

    FUNCTION tt (
                p_article_id IN articles.article_id%TYPE DEFAULT NULL
                )
       RETURN articles_tt
       PIPELINED
    IS
       l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'tt';
       l_params logger.tab_param;
       l_articles_rec   articles_rt;
    BEGIN
      logger.append_param(l_params, 'p_article_id', tt.p_article_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Populating record type from DB', l_scope);

       FOR c1 IN (SELECT   a.*, ROWID
                    FROM   articles a
                   WHERE
                        article_id = NVL(tt.p_article_id,article_id)
                        )
       LOOP
              l_articles_rec.article_id := c1.article_id;
              l_articles_rec.name := c1.name;
              l_articles_rec.code := c1.code;
              l_articles_rec.description := c1.description;
              l_articles_rec.stock := c1.stock;
              l_articles_rec.price := c1.price;
              l_articles_rec.picture := c1.picture;
              l_articles_rec.shop_id := c1.shop_id;
              l_articles_rec.brand_id := c1.brand_id;
              l_articles_rec.article_type_id := c1.article_type_id;
              l_articles_rec.state_id := c1.state_id;
              l_articles_rec.hash := tapi_articles.hash( c1.article_id);
              l_articles_rec.row_id := c1.ROWID;
              PIPE ROW (l_articles_rec);
       END LOOP;

       logger.LOG('END', l_scope);

       RETURN;

    EXCEPTION
     WHEN OTHERS
     THEN
        logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
        RAISE;
    END tt;


    PROCEDURE ins (p_articles_rec IN OUT articles_rt)
    IS
        l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'ins';
        l_params logger.tab_param;
        l_rowtype     articles%ROWTYPE;

    BEGIN
        logger.append_param(l_params, 'p_articles_rec.article_id', ins.p_articles_rec.article_id);
        logger.append_param(l_params, 'p_articles_rec.name', ins.p_articles_rec.name);
        logger.append_param(l_params, 'p_articles_rec.code', ins.p_articles_rec.code);
        logger.append_param(l_params, 'p_articles_rec.description', ins.p_articles_rec.description);
        logger.append_param(l_params, 'p_articles_rec.stock', ins.p_articles_rec.stock);
        logger.append_param(l_params, 'p_articles_rec.price', ins.p_articles_rec.price);
        logger.append_param(l_params, 'p_articles_rec.picture', ins.p_articles_rec.picture);
        logger.append_param(l_params, 'p_articles_rec.shop_id', ins.p_articles_rec.shop_id);
        logger.append_param(l_params, 'p_articles_rec.brand_id', ins.p_articles_rec.brand_id);
        logger.append_param(l_params, 'p_articles_rec.article_type_id', ins.p_articles_rec.article_type_id);
        logger.append_param(l_params, 'p_articles_rec.state_id', ins.p_articles_rec.state_id);
        logger.LOG('START', l_scope, NULL, l_params);
        logger.LOG('Inserting data', l_scope);


        l_rowtype.article_id := ins.p_articles_rec.article_id;
        l_rowtype.name := ins.p_articles_rec.name;
        l_rowtype.code := ins.p_articles_rec.code;
        l_rowtype.description := ins.p_articles_rec.description;
        l_rowtype.stock := ins.p_articles_rec.stock;
        l_rowtype.price := ins.p_articles_rec.price;
        l_rowtype.picture := ins.p_articles_rec.picture;
        l_rowtype.shop_id := ins.p_articles_rec.shop_id;
        l_rowtype.brand_id := ins.p_articles_rec.brand_id;
        l_rowtype.article_type_id := ins.p_articles_rec.article_type_id;
        l_rowtype.state_id := ins.p_articles_rec.state_id;

       INSERT INTO articles
         VALUES   l_rowtype;

       logger.LOG('END', l_scope);

    EXCEPTION
      WHEN OTHERS
      THEN
         logger.log_error('Unhandled Exception', l_scope, NULL, l_params);
         RAISE;
    END ins;

    PROCEDURE upd (
                  p_articles_rec         IN articles_rt,
                  p_ignore_nulls         IN boolean := FALSE
                  )
    IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'upd';
      l_params logger.tab_param;
    BEGIN
       logger.append_param(l_params, 'p_articles_rec.article_id', upd.p_articles_rec.article_id);
       logger.append_param(l_params, 'p_articles_rec.name', upd.p_articles_rec.name);
       logger.append_param(l_params, 'p_articles_rec.code', upd.p_articles_rec.code);
       logger.append_param(l_params, 'p_articles_rec.description', upd.p_articles_rec.description);
       logger.append_param(l_params, 'p_articles_rec.stock', upd.p_articles_rec.stock);
       logger.append_param(l_params, 'p_articles_rec.price', upd.p_articles_rec.price);
       logger.append_param(l_params, 'p_articles_rec.picture', upd.p_articles_rec.picture);
       logger.append_param(l_params, 'p_articles_rec.shop_id', upd.p_articles_rec.shop_id);
       logger.append_param(l_params, 'p_articles_rec.brand_id', upd.p_articles_rec.brand_id);
       logger.append_param(l_params, 'p_articles_rec.article_type_id', upd.p_articles_rec.article_type_id);
       logger.append_param(l_params, 'p_articles_rec.state_id', upd.p_articles_rec.state_id);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);

       IF NVL (p_ignore_nulls, FALSE)
       THEN
          UPDATE   articles
             SET article_id = NVL(p_articles_rec.article_id,article_id),
                name = NVL(p_articles_rec.name,name),
                code = NVL(p_articles_rec.code,code),
                description = NVL(p_articles_rec.description,description),
                stock = NVL(p_articles_rec.stock,stock),
                price = NVL(p_articles_rec.price,price),
                picture = NVL(p_articles_rec.picture,picture),
                shop_id = NVL(p_articles_rec.shop_id,shop_id),
                brand_id = NVL(p_articles_rec.brand_id,brand_id),
                article_type_id = NVL(p_articles_rec.article_type_id,article_type_id),
                state_id = NVL(p_articles_rec.state_id,state_id)
           WHERE
                article_id = upd.p_articles_rec.article_id
                ;
       ELSE
          UPDATE   articles
             SET article_id = p_articles_rec.article_id,
                name = p_articles_rec.name,
                code = p_articles_rec.code,
                description = p_articles_rec.description,
                stock = p_articles_rec.stock,
                price = p_articles_rec.price,
                picture = p_articles_rec.picture,
                shop_id = p_articles_rec.shop_id,
                brand_id = p_articles_rec.brand_id,
                article_type_id = p_articles_rec.article_type_id,
                state_id = p_articles_rec.state_id
           WHERE
                article_id = upd.p_articles_rec.article_id
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
                         p_articles_rec         IN articles_rt,
                         p_ignore_nulls         IN boolean := FALSE
                        )
    IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'upd_rowid';
      l_params logger.tab_param;
    BEGIN
       logger.append_param(l_params, 'p_articles_rec.article_id', upd_rowid.p_articles_rec.article_id);
       logger.append_param(l_params, 'p_articles_rec.name', upd_rowid.p_articles_rec.name);
       logger.append_param(l_params, 'p_articles_rec.code', upd_rowid.p_articles_rec.code);
       logger.append_param(l_params, 'p_articles_rec.description', upd_rowid.p_articles_rec.description);
       logger.append_param(l_params, 'p_articles_rec.stock', upd_rowid.p_articles_rec.stock);
       logger.append_param(l_params, 'p_articles_rec.price', upd_rowid.p_articles_rec.price);
       logger.append_param(l_params, 'p_articles_rec.picture', upd_rowid.p_articles_rec.picture);
       logger.append_param(l_params, 'p_articles_rec.shop_id', upd_rowid.p_articles_rec.shop_id);
       logger.append_param(l_params, 'p_articles_rec.brand_id', upd_rowid.p_articles_rec.brand_id);
       logger.append_param(l_params, 'p_articles_rec.article_type_id', upd_rowid.p_articles_rec.article_type_id);
       logger.append_param(l_params, 'p_articles_rec.state_id', upd_rowid.p_articles_rec.state_id);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);

       IF NVL (p_ignore_nulls, FALSE)
       THEN
          UPDATE   articles
             SET article_id = NVL(p_articles_rec.article_id,article_id),
                name = NVL(p_articles_rec.name,name),
                code = NVL(p_articles_rec.code,code),
                description = NVL(p_articles_rec.description,description),
                stock = NVL(p_articles_rec.stock,stock),
                price = NVL(p_articles_rec.price,price),
                picture = NVL(p_articles_rec.picture,picture),
                shop_id = NVL(p_articles_rec.shop_id,shop_id),
                brand_id = NVL(p_articles_rec.brand_id,brand_id),
                article_type_id = NVL(p_articles_rec.article_type_id,article_type_id),
                state_id = NVL(p_articles_rec.state_id,state_id)
           WHERE  ROWID = p_articles_rec.row_id;
       ELSE
          UPDATE   articles
             SET article_id = p_articles_rec.article_id,
                name = p_articles_rec.name,
                code = p_articles_rec.code,
                description = p_articles_rec.description,
                stock = p_articles_rec.stock,
                price = p_articles_rec.price,
                picture = p_articles_rec.picture,
                shop_id = p_articles_rec.shop_id,
                brand_id = p_articles_rec.brand_id,
                article_type_id = p_articles_rec.article_type_id,
                state_id = p_articles_rec.state_id
           WHERE  ROWID = p_articles_rec.row_id;
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
                  p_articles_rec         IN articles_rt,
                  p_ignore_nulls         IN boolean := FALSE
                )
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_upd';
      l_params logger.tab_param;
      l_articles_rec articles_rt;
   BEGIN
       logger.append_param(l_params, 'p_articles_rec.article_id', web_upd.p_articles_rec.article_id);
       logger.append_param(l_params, 'p_articles_rec.name', web_upd.p_articles_rec.name);
       logger.append_param(l_params, 'p_articles_rec.code', web_upd.p_articles_rec.code);
       logger.append_param(l_params, 'p_articles_rec.description', web_upd.p_articles_rec.description);
       logger.append_param(l_params, 'p_articles_rec.stock', web_upd.p_articles_rec.stock);
       logger.append_param(l_params, 'p_articles_rec.price', web_upd.p_articles_rec.price);
       logger.append_param(l_params, 'p_articles_rec.picture', web_upd.p_articles_rec.picture);
       logger.append_param(l_params, 'p_articles_rec.shop_id', web_upd.p_articles_rec.shop_id);
       logger.append_param(l_params, 'p_articles_rec.brand_id', web_upd.p_articles_rec.brand_id);
       logger.append_param(l_params, 'p_articles_rec.article_type_id', web_upd.p_articles_rec.article_type_id);
       logger.append_param(l_params, 'p_articles_rec.state_id', web_upd.p_articles_rec.state_id);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);

      OPEN articles_cur(
                             web_upd.p_articles_rec.article_id
                        );

      FETCH articles_cur INTO l_articles_rec;

      IF articles_cur%NOTFOUND THEN
         CLOSE articles_cur;
         RAISE e_row_missing;
      ELSE
         IF p_articles_rec.hash != l_articles_rec.hash THEN
            CLOSE articles_cur;
            RAISE e_ol_check_failed;
         ELSE
            IF NVL(p_ignore_nulls, FALSE)
            THEN

                UPDATE   articles
                   SET article_id = NVL(p_articles_rec.article_id,article_id),
                       name = NVL(p_articles_rec.name,name),
                       code = NVL(p_articles_rec.code,code),
                       description = NVL(p_articles_rec.description,description),
                       stock = NVL(p_articles_rec.stock,stock),
                       price = NVL(p_articles_rec.price,price),
                       picture = NVL(p_articles_rec.picture,picture),
                       shop_id = NVL(p_articles_rec.shop_id,shop_id),
                       brand_id = NVL(p_articles_rec.brand_id,brand_id),
                       article_type_id = NVL(p_articles_rec.article_type_id,article_type_id),
                       state_id = NVL(p_articles_rec.state_id,state_id)
               WHERE CURRENT OF articles_cur;
            ELSE
                UPDATE   articles
                   SET article_id = p_articles_rec.article_id,
                       name = p_articles_rec.name,
                       code = p_articles_rec.code,
                       description = p_articles_rec.description,
                       stock = p_articles_rec.stock,
                       price = p_articles_rec.price,
                       picture = p_articles_rec.picture,
                       shop_id = p_articles_rec.shop_id,
                       brand_id = p_articles_rec.brand_id,
                       article_type_id = p_articles_rec.article_type_id,
                       state_id = p_articles_rec.state_id
               WHERE CURRENT OF articles_cur;
            END IF;

            CLOSE articles_cur;
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
                            p_articles_rec    IN articles_rt,
                            p_ignore_nulls         IN boolean := FALSE
                           )
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_upd_rowid';
      l_params logger.tab_param;
      l_articles_rec articles_rt;
   BEGIN
       logger.append_param(l_params, 'p_articles_rec.article_id', web_upd_rowid.p_articles_rec.article_id);
       logger.append_param(l_params, 'p_articles_rec.name', web_upd_rowid.p_articles_rec.name);
       logger.append_param(l_params, 'p_articles_rec.code', web_upd_rowid.p_articles_rec.code);
       logger.append_param(l_params, 'p_articles_rec.description', web_upd_rowid.p_articles_rec.description);
       logger.append_param(l_params, 'p_articles_rec.stock', web_upd_rowid.p_articles_rec.stock);
       logger.append_param(l_params, 'p_articles_rec.price', web_upd_rowid.p_articles_rec.price);
       logger.append_param(l_params, 'p_articles_rec.picture', web_upd_rowid.p_articles_rec.picture);
       logger.append_param(l_params, 'p_articles_rec.shop_id', web_upd_rowid.p_articles_rec.shop_id);
       logger.append_param(l_params, 'p_articles_rec.brand_id', web_upd_rowid.p_articles_rec.brand_id);
       logger.append_param(l_params, 'p_articles_rec.article_type_id', web_upd_rowid.p_articles_rec.article_type_id);
       logger.append_param(l_params, 'p_articles_rec.state_id', web_upd_rowid.p_articles_rec.state_id);
       logger.LOG('START', l_scope, NULL, l_params);
       logger.LOG('Updating table', l_scope);

      OPEN articles_rowid_cur(web_upd_rowid.p_articles_rec.row_id);

      FETCH articles_rowid_cur INTO l_articles_rec;

      IF articles_rowid_cur%NOTFOUND THEN
         CLOSE articles_rowid_cur;
         RAISE e_row_missing;
      ELSE
         IF web_upd_rowid.p_articles_rec.hash != l_articles_rec.hash THEN
            CLOSE articles_rowid_cur;
            RAISE e_ol_check_failed;
         ELSE
            IF NVL(web_upd_rowid.p_ignore_nulls, FALSE)
            THEN
                UPDATE   articles
                   SET article_id = NVL(p_articles_rec.article_id,article_id),
                       name = NVL(p_articles_rec.name,name),
                       code = NVL(p_articles_rec.code,code),
                       description = NVL(p_articles_rec.description,description),
                       stock = NVL(p_articles_rec.stock,stock),
                       price = NVL(p_articles_rec.price,price),
                       picture = NVL(p_articles_rec.picture,picture),
                       shop_id = NVL(p_articles_rec.shop_id,shop_id),
                       brand_id = NVL(p_articles_rec.brand_id,brand_id),
                       article_type_id = NVL(p_articles_rec.article_type_id,article_type_id),
                       state_id = NVL(p_articles_rec.state_id,state_id)
               WHERE CURRENT OF articles_rowid_cur;
            ELSE
                UPDATE   articles
                   SET article_id = p_articles_rec.article_id,
                       name = p_articles_rec.name,
                       code = p_articles_rec.code,
                       description = p_articles_rec.description,
                       stock = p_articles_rec.stock,
                       price = p_articles_rec.price,
                       picture = p_articles_rec.picture,
                       shop_id = p_articles_rec.shop_id,
                       brand_id = p_articles_rec.brand_id,
                       article_type_id = p_articles_rec.article_type_id,
                       state_id = p_articles_rec.state_id
               WHERE CURRENT OF articles_rowid_cur;
            END IF;

            CLOSE articles_rowid_cur;
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
                  p_article_id IN articles.article_id%TYPE
                  )
    IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'del';
      l_params logger.tab_param;
    BEGIN
      logger.append_param(l_params, 'p_article_id', del.p_article_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Deleting record', l_scope);

       DELETE FROM   articles
             WHERE
                  article_id = del.p_article_id
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

       DELETE FROM   articles
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
                      p_article_id IN articles.article_id%TYPE,
                      p_hash IN varchar2
                      )
   IS
      l_scope logger_logs.scope%TYPE := gc_scope_prefix || 'web_del';
      l_params logger.tab_param;
      l_articles_rec articles_rt;
   BEGIN

      logger.append_param(l_params, 'p_article_id', web_del.p_article_id);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Deleting record', l_scope);

      OPEN articles_cur(
                            web_del.p_article_id
                            );

      FETCH articles_cur INTO l_articles_rec;

      IF articles_cur%NOTFOUND THEN
         CLOSE articles_cur;
         RAISE e_row_missing;
      ELSE
         IF web_del.p_hash != l_articles_rec.hash THEN
            CLOSE articles_cur;
            RAISE e_ol_check_failed;
         ELSE
            DELETE FROM articles
            WHERE CURRENT OF articles_cur;

            CLOSE articles_cur;
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
      l_articles_rec articles_rt;
   BEGIN

      logger.append_param(l_params, 'p_rowid', web_del_rowid.p_rowid);
      logger.LOG('START', l_scope, NULL, l_params);
      logger.LOG('Deleting record', l_scope);

      OPEN articles_rowid_cur(web_del_rowid.p_rowid);

      FETCH articles_rowid_cur INTO l_articles_rec;

      IF articles_rowid_cur%NOTFOUND THEN
         CLOSE articles_rowid_cur;
         RAISE e_row_missing;
      ELSE
         IF web_del_rowid.p_hash != l_articles_rec.hash THEN
            CLOSE articles_rowid_cur;
            RAISE e_ol_check_failed;
         ELSE
            DELETE FROM articles
            WHERE CURRENT OF articles_rowid_cur;

            CLOSE articles_rowid_cur;
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

END tapi_articles;
/
