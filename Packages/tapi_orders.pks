create or replace PACKAGE tapi_orders
IS
   /**
   * TAPI_ORDERS
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 20-JUL-2016 11:49
   * Created By: SIMPLE_DELIVERY
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE order_id IS orders.order_id%TYPE;
   SUBTYPE user_id IS orders.user_id%TYPE;
   SUBTYPE shop_id IS orders.shop_id%TYPE;
   SUBTYPE geoloc IS orders.geoloc%TYPE;
   SUBTYPE address IS orders.address%TYPE;
   SUBTYPE comments IS orders.comments%TYPE;
   SUBTYPE request_time IS orders.request_time%TYPE;
   SUBTYPE response_time IS orders.response_time%TYPE;
   SUBTYPE arrival_time IS orders.arrival_time%TYPE;
   SUBTYPE state_id IS orders.state_id%TYPE;

   --Record type
   TYPE orders_rt
   IS
      RECORD (
            order_id orders.order_id%TYPE,
            user_id orders.user_id%TYPE,
            shop_id orders.shop_id%TYPE,
            geoloc orders.geoloc%TYPE,
            address orders.address%TYPE,
            comments orders.comments%TYPE,
            request_time orders.request_time%TYPE,
            response_time orders.response_time%TYPE,
            arrival_time orders.arrival_time%TYPE,
            state_id orders.state_id%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE orders_tt IS TABLE OF orders_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_order_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_order_id IN orders.order_id%TYPE
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
   * This is a table encapsulation function designed to retrieve information from the orders table.
   *
   * @param      p_order_id      must be NOT NULL
   * @return     orders Record Type
   */
   FUNCTION rt (
                p_order_id IN orders.order_id%TYPE
               )
    RETURN orders_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the orders table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_order_id      must be NOT NULL
   * @return     orders Record Type
   */
   FUNCTION rt_for_update (
                          p_order_id IN orders.order_id%TYPE
                          )
    RETURN orders_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the orders table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_order_id      must be NOT NULL
   * @return     orders Table Record Type
   */
   FUNCTION tt (
                p_order_id IN orders.order_id%TYPE DEFAULT NULL
               )
   RETURN orders_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the orders table.
   *
   * @param      p_orders_rec       Record Type
   * @return     p_orders_rec       Record Type
   */
   PROCEDURE ins (p_orders_rec IN OUT orders_rt);

   /**
   * This is a table encapsulation function designed to update a row in the orders table.
   *
   * @param      p_orders_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_orders_rec IN orders_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the orders table,
   * access directly to the row by rowid
   *
   * @param      p_orders_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_orders_rec IN orders_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the orders table whith optimistic lock validation
   *
   * @param      p_orders_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_orders_rec IN orders_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the orders table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_orders_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_orders_rec IN orders_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the orders table.
   *
   * @param    p_order_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_order_id IN orders.order_id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the orders table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the orders table
   * whith optimistic lock validation
   *
   * @param      p_order_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_order_id IN orders.order_id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the orders table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_orders;
 /