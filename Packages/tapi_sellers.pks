create or replace PACKAGE tapi_sellers
IS
   /**
   * TAPI_SELLERS
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 20-JUL-2016 11:49
   * Created By: SIMPLE_DELIVERY
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE user_id IS sellers.user_id%TYPE;
   SUBTYPE state_id IS sellers.state_id%TYPE;

   --Record type
   TYPE sellers_rt
   IS
      RECORD (
            user_id sellers.user_id%TYPE,
            state_id sellers.state_id%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE sellers_tt IS TABLE OF sellers_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_user_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_user_id IN sellers.user_id%TYPE
                 )
    RETURN VARCHAR2;

   /**
   * This function generates a SHA1 hash for optimistic locking purposes.
   * Access directly to the row by rowid
   *
   * @param  p_rowid  must be NOT NULL
   */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

   /**
   * This is a table encapsulation function designed to retrieve information from the sellers table.
   *
   * @param      p_user_id      must be NOT NULL
   * @return     sellers Record Type
   */
   FUNCTION rt (
                p_user_id IN sellers.user_id%TYPE
               )
    RETURN sellers_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the sellers table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_user_id      must be NOT NULL
   * @return     sellers Record Type
   */
   FUNCTION rt_for_update (
                          p_user_id IN sellers.user_id%TYPE
                          )
    RETURN sellers_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the sellers table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_user_id      must be NOT NULL
   * @return     sellers Table Record Type
   */
   FUNCTION tt (
                p_user_id IN sellers.user_id%TYPE DEFAULT NULL
               )
   RETURN sellers_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the sellers table.
   *
   * @param      p_sellers_rec       Record Type
   * @return     p_sellers_rec       Record Type
   */
   PROCEDURE ins (p_sellers_rec IN OUT sellers_rt);

   /**
   * This is a table encapsulation function designed to update a row in the sellers table.
   *
   * @param      p_sellers_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_sellers_rec IN sellers_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the sellers table,
   * access directly to the row by rowid
   *
   * @param      p_sellers_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_sellers_rec IN sellers_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the sellers table whith optimistic lock validation
   *
   * @param      p_sellers_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_sellers_rec IN sellers_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the sellers table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_sellers_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_sellers_rec IN sellers_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the sellers table.
   *
   * @param    p_user_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_user_id IN sellers.user_id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the sellers table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the sellers table
   * whith optimistic lock validation
   *
   * @param      p_user_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_user_id IN sellers.user_id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the sellers table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_sellers;
 /