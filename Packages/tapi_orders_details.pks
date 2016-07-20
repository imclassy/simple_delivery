create or replace PACKAGE tapi_orders_details
IS
   /**
   * TAPI_ORDERS_DETAILS
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 20-JUL-2016 11:49
   * Created By: SIMPLE_DELIVERY
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE orders_details_id IS orders_details.orders_details_id%TYPE;
   SUBTYPE article_id IS orders_details.article_id%TYPE;
   SUBTYPE order_id IS orders_details.order_id%TYPE;
   SUBTYPE quantity IS orders_details.quantity%TYPE;

   --Record type
   TYPE orders_details_rt
   IS
      RECORD (
            orders_details_id orders_details.orders_details_id%TYPE,
            article_id orders_details.article_id%TYPE,
            order_id orders_details.order_id%TYPE,
            quantity orders_details.quantity%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE orders_details_tt IS TABLE OF orders_details_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_orders_details_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_orders_details_id IN orders_details.orders_details_id%TYPE
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
   * This is a table encapsulation function designed to retrieve information from the orders_details table.
   *
   * @param      p_orders_details_id      must be NOT NULL
   * @return     orders_details Record Type
   */
   FUNCTION rt (
                p_orders_details_id IN orders_details.orders_details_id%TYPE
               )
    RETURN orders_details_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the orders_details table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_orders_details_id      must be NOT NULL
   * @return     orders_details Record Type
   */
   FUNCTION rt_for_update (
                          p_orders_details_id IN orders_details.orders_details_id%TYPE
                          )
    RETURN orders_details_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the orders_details table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_orders_details_id      must be NOT NULL
   * @return     orders_details Table Record Type
   */
   FUNCTION tt (
                p_orders_details_id IN orders_details.orders_details_id%TYPE DEFAULT NULL
               )
   RETURN orders_details_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the orders_details table.
   *
   * @param      p_orders_details_rec       Record Type
   * @return     p_orders_details_rec       Record Type
   */
   PROCEDURE ins (p_orders_details_rec IN OUT orders_details_rt);

   /**
   * This is a table encapsulation function designed to update a row in the orders_details table.
   *
   * @param      p_orders_details_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_orders_details_rec IN orders_details_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the orders_details table,
   * access directly to the row by rowid
   *
   * @param      p_orders_details_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_orders_details_rec IN orders_details_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the orders_details table whith optimistic lock validation
   *
   * @param      p_orders_details_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_orders_details_rec IN orders_details_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the orders_details table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_orders_details_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_orders_details_rec IN orders_details_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the orders_details table.
   *
   * @param    p_orders_details_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_orders_details_id IN orders_details.orders_details_id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the orders_details table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the orders_details table
   * whith optimistic lock validation
   *
   * @param      p_orders_details_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_orders_details_id IN orders_details.orders_details_id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the orders_details table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_orders_details;
 /
