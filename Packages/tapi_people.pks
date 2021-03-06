create or replace PACKAGE tapi_people
IS
   /**
   * TAPI_PEOPLE
   * Generated by: tapiGen2 - DO NOT MODIFY!
   * Website: github.com/osalvador/tapiGen2
   * Created On: 20-JUL-2016 11:49
   * Created By: SIMPLE_DELIVERY
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE person_id IS people.person_id%TYPE;
   SUBTYPE name IS people.name%TYPE;
   SUBTYPE last_name IS people.last_name%TYPE;
   SUBTYPE email IS people.email%TYPE;
   SUBTYPE cellphone IS people.cellphone%TYPE;

   --Record type
   TYPE people_rt
   IS
      RECORD (
            person_id people.person_id%TYPE,
            name people.name%TYPE,
            last_name people.last_name%TYPE,
            email people.email%TYPE,
            cellphone people.cellphone%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE people_tt IS TABLE OF people_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

   /**
   * Generates a SHA1 hash for optimistic locking purposes.
   *
   * @param    p_person_id        must be NOT NULL
   */
   FUNCTION hash (
                  p_person_id IN people.person_id%TYPE
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
   * This is a table encapsulation function designed to retrieve information from the people table.
   *
   * @param      p_person_id      must be NOT NULL
   * @return     people Record Type
   */
   FUNCTION rt (
                p_person_id IN people.person_id%TYPE
               )
    RETURN people_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information
   * from the people table while placing a lock on it for a potential
   * update/delete. Do not use this for updates in web based apps, instead use the
   * rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
   * includes all of the tables columns along with an md5 checksum for use in the
   * web_upd and web_del procedures.
   *
   * @param      p_person_id      must be NOT NULL
   * @return     people Record Type
   */
   FUNCTION rt_for_update (
                          p_person_id IN people.person_id%TYPE
                          )
    RETURN people_rt RESULT_CACHE;

   /**
   * This is a table encapsulation function designed to retrieve information from the people table.
   * This function return Record Table as PIPELINED Function
   *
   * @param      p_person_id      must be NOT NULL
   * @return     people Table Record Type
   */
   FUNCTION tt (
                p_person_id IN people.person_id%TYPE DEFAULT NULL
               )
   RETURN people_tt
   PIPELINED;

   /**
   * This is a table encapsulation function designed to insert a row into the people table.
   *
   * @param      p_people_rec       Record Type
   * @return     p_people_rec       Record Type
   */
   PROCEDURE ins (p_people_rec IN OUT people_rt);

   /**
   * This is a table encapsulation function designed to update a row in the people table.
   *
   * @param      p_people_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd (p_people_rec IN people_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row in the people table,
   * access directly to the row by rowid
   *
   * @param      p_people_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE upd_rowid (p_people_rec IN people_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the people table whith optimistic lock validation
   *
   * @param      p_people_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd (p_people_rec IN people_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to update a row
   * in the people table whith optimistic lock validation
   * access directly to the row by rowid
   *
   * @param      p_people_rec      Record Type
   * @param      p_ignore_nulls      IF TRUE then null values are ignored in the update
   */
   PROCEDURE web_upd_rowid (p_people_rec IN people_rt, p_ignore_nulls IN boolean := FALSE);

   /**
   * This is a table encapsulation function designed to delete a row from the people table.
   *
   * @param    p_person_id        must be NOT NULL
   */
   PROCEDURE del (
                  p_person_id IN people.person_id%TYPE
                );

   /**
   * This is a table encapsulation function designed to delete a row from the people table
   * access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

   /**
   * This is a table encapsulation function designed to delete a row from the people table
   * whith optimistic lock validation
   *
   * @param      p_person_id      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del (
                      p_person_id IN people.person_id%TYPE,
                      p_hash IN varchar2
                      );

   /**
   * This is a table encapsulation function designed to delete a row from the people table
   * whith optimistic lock validation, access directly to the row by rowid
   *
   * @param      p_rowid      must be NOT NULL
   * @param      p_hash       must be NOT NULL
   */
    PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2);

END tapi_people;
 /
