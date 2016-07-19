-- Generado por Oracle SQL Developer Data Modeler 4.0.1.836
--   en:        2016-07-17 21:31:06 COT
--   sitio:      Oracle Database 12c
--   tipo:      Oracle Database 12c




 CREATE TABLE ARTICLES
   (
      article_id  NUMBER (10) NOT NULL ,
      name        VARCHAR2 (50) NOT NULL ,
      description VARCHAR2 (300) ,
      stock       NUMBER (20,10) NOT NULL ,
      price       NUMBER (30,10) NOT NULL ,
      picture BLOB ,
      shop_id         NUMBER (10) NOT NULL ,
      brand_id        NUMBER (10) NOT NULL ,
      article_type_id NUMBER (10) NOT NULL ,
      state_id        NUMBER (10) NOT NULL
   ) ;

ALTER TABLE ARTICLES ADD CONSTRAINT ARTICLES_PK PRIMARY KEY (
article_id ) ;

 CREATE TABLE ARTICLE_TYPES
   (
      article_type_id NUMBER (10) NOT NULL ,
      name            VARCHAR2 (50) NOT NULL ,
      shop_id         NUMBER (10) NOT NULL
   ) ;

ALTER TABLE ARTICLE_TYPES ADD CONSTRAINT ARTICLE_TYPES_PK PRIMARY KEY
( article_type_id ) ;

 CREATE TABLE BRANDS
   (
      brand_id NUMBER (10) NOT NULL ,
      name     VARCHAR2 (50) NOT NULL ,
      shop_id  NUMBER (10) NOT NULL
   ) ;



ALTER TABLE BRANDS ADD CONSTRAINT BRANDS_PK PRIMARY KEY ( brand_id )
;

 CREATE TABLE CUSTOMERS
   (
      user_id  NUMBER (10) NOT NULL ,
      state_id NUMBER (10) NOT NULL
   ) ;


ALTER TABLE CUSTOMERS ADD CONSTRAINT CUSTOMERS_PK PRIMARY KEY (
user_id ) ;

 CREATE TABLE INVENTORY_MOVEMENTS
   (
      inventory_movement_id        NUMBER (10) NOT NULL ,
      article_id                   NUMBER (10) NOT NULL ,
      type                         VARCHAR2 (3) NOT NULL ,
      quantity                     NUMBER (20,10) NOT NULL ,
      inventory_movement_source_id NUMBER (10) NOT NULL ,
      state_id                     NUMBER (10) NOT NULL
   ) ;





ALTER TABLE INVENTORY_MOVEMENTS ADD CONSTRAINT
INVENTORY_MOVEMENTS_TYPE_CK CHECK (type IN ('IN','OUT')) ;
ALTER TABLE INVENTORY_MOVEMENTS ADD CONSTRAINT INVENTORY_MOVEMENTS_PK
PRIMARY KEY ( inventory_movement_id ) ;

 CREATE TABLE INVENTORY_MOVEMENT_SOURCES
   (
      inventory_movement_source_id NUMBER (10) NOT NULL ,
      name                         VARCHAR2 (50)
   ) ;


ALTER TABLE INVENTORY_MOVEMENT_SOURCES ADD CONSTRAINT
INVENTORY_MOVEMENT_SOURCE_PK PRIMARY KEY (
inventory_movement_source_id ) ;

 CREATE TABLE ORDERS
   (
      order_id      NUMBER (10) NOT NULL ,
      user_id       NUMBER (10) NOT NULL ,
      shop_id       NUMBER (10) NOT NULL ,
      geoloc        VARCHAR2 (100) ,
      address       VARCHAR2 (100) NOT NULL ,
      comments      VARCHAR2 (300) ,
      request_time  TIMESTAMP NOT NULL ,
      response_time TIMESTAMP ,
      arrival_time  TIMESTAMP ,
      state_id      NUMBER (10) NOT NULL
   ) ;




ALTER TABLE ORDERS ADD CONSTRAINT ORDERS_PK PRIMARY KEY ( order_id )
;

 CREATE TABLE ORDERS_DETAILS
   (
      orders_details_id NUMBER (10) ,
      article_id        NUMBER (10) NOT NULL ,
      order_id          NUMBER (10) NOT NULL ,
      quantity          NUMBER (20,10) NOT NULL
   ) ;





 CREATE TABLE PEOPLE
   (
      person_id NUMBER (10) NOT NULL ,
      name      VARCHAR2 (50) NOT NULL ,
      last_name VARCHAR2 (50) NOT NULL ,
      email     VARCHAR2 (300) NOT NULL ,
      cellphone NUMBER (20,10) NOT NULL
   ) ;




ALTER TABLE PEOPLE ADD CONSTRAINT PEOPLE_PK PRIMARY KEY ( person_id )
;
ALTER TABLE PEOPLE ADD CONSTRAINT PEOPLE__EMAIL_UNIQUE UNIQUE ( email
) ;

 CREATE TABLE SELLERS
   (
      user_id  NUMBER (10) NOT NULL ,
      state_id NUMBER (10) NOT NULL
   ) ;


ALTER TABLE SELLERS ADD CONSTRAINT SELLERS_PK PRIMARY KEY ( user_id )
;

 CREATE TABLE SHOPS
   (
      shop_id           NUMBER (10) NOT NULL ,
      user_id           NUMBER (10) NOT NULL ,
      shop_type_id      NUMBER (10) NOT NULL ,
      name              VARCHAR2 (50) NOT NULL ,
      telphone          NUMBER (20,10) ,
      celphone          NUMBER (20,10) NOT NULL ,
      address           VARCHAR2 (100) NOT NULL ,
      geoloc            VARCHAR2 (100) NOT NULL ,
      coverage          NUMBER (20,10) NOT NULL ,
      avg_delivery_time NUMBER (10,5) ,
      state_id          NUMBER (10) NOT NULL
   ) ;








ALTER TABLE SHOPS ADD CONSTRAINT SHOPS_PK PRIMARY KEY ( shop_id ) ;

 CREATE TABLE SHOP_TYPES
   (
      shop_type_id NUMBER (10) NOT NULL ,
      name         VARCHAR2 (50) NOT NULL
   ) ;


ALTER TABLE SHOP_TYPES ADD CONSTRAINT SHOP_TYPES_PK PRIMARY KEY (
shop_type_id ) ;

 CREATE TABLE STATES
   ( state_id NUMBER (10) NOT NULL , name VARCHAR2 (50)
   ) ;


ALTER TABLE STATES ADD CONSTRAINT STATES_PK PRIMARY KEY ( state_id )
;

 CREATE TABLE USERS
   (
      user_id       NUMBER (10) NOT NULL ,
      password      VARCHAR2 (300) ,
      creation_date TIMESTAMP NOT NULL ,
      person_id     NUMBER (10) NOT NULL ,
      state_id      NUMBER (10) NOT NULL
   ) ;



ALTER TABLE USERS ADD CONSTRAINT USERS_PK PRIMARY KEY ( user_id ) ;

ALTER TABLE ARTICLES ADD CONSTRAINT ARTICLES_ARTICLE_TYPES_FK FOREIGN
KEY ( article_type_id ) REFERENCES ARTICLE_TYPES ( article_type_id )
;

ALTER TABLE ARTICLES ADD CONSTRAINT ARTICLES_BRANDS_FK FOREIGN KEY (
brand_id ) REFERENCES BRANDS ( brand_id ) ;

ALTER TABLE ARTICLES ADD CONSTRAINT ARTICLES_SHOPS_FK FOREIGN KEY (
shop_id ) REFERENCES SHOPS ( shop_id ) ;

ALTER TABLE ARTICLES ADD CONSTRAINT ARTICLES_STATES_FK FOREIGN KEY (
state_id ) REFERENCES STATES ( state_id ) ;

ALTER TABLE ARTICLE_TYPES ADD CONSTRAINT ARTICLE_TYPES_SHOPS_FK
FOREIGN KEY ( shop_id ) REFERENCES SHOPS ( shop_id ) ;

ALTER TABLE BRANDS ADD CONSTRAINT BRANDS_SHOPS_FK FOREIGN KEY (
shop_id ) REFERENCES SHOPS ( shop_id ) ;

ALTER TABLE CUSTOMERS ADD CONSTRAINT CUSTOMERS_STATES_FK FOREIGN KEY
( state_id ) REFERENCES STATES ( state_id ) ;

ALTER TABLE CUSTOMERS ADD CONSTRAINT CUSTOMERS_USERS_FK FOREIGN KEY (
user_id ) REFERENCES USERS ( user_id ) ;

ALTER TABLE INVENTORY_MOVEMENTS ADD CONSTRAINT
INVENTORY_MOV_ARTICLES_FK FOREIGN KEY ( article_id ) REFERENCES
ARTICLES ( article_id ) ;

ALTER TABLE INVENTORY_MOVEMENTS ADD CONSTRAINT
INVENTORY_MOV_SOURCES_FK FOREIGN KEY ( inventory_movement_source_id )
REFERENCES INVENTORY_MOVEMENT_SOURCES ( inventory_movement_source_id
) ;

ALTER TABLE INVENTORY_MOVEMENTS ADD CONSTRAINT
INVENTORY_MOV_STATES_FK FOREIGN KEY ( state_id ) REFERENCES STATES (
state_id ) ;

ALTER TABLE ORDERS ADD CONSTRAINT ORDERS_CUSTOMERS_FK FOREIGN KEY (
user_id ) REFERENCES CUSTOMERS ( user_id ) ;

ALTER TABLE ORDERS_DETAILS ADD CONSTRAINT ORDERS_DETAILS_ARTICLES_FK
FOREIGN KEY ( article_id ) REFERENCES ARTICLES ( article_id ) ;

ALTER TABLE ORDERS_DETAILS ADD CONSTRAINT ORDERS_DETAILS_ORDERS_FK
FOREIGN KEY ( order_id ) REFERENCES ORDERS ( order_id ) ;

ALTER TABLE ORDERS ADD CONSTRAINT ORDERS_SHOPS_FK FOREIGN KEY (
shop_id ) REFERENCES SHOPS ( shop_id ) ;

ALTER TABLE ORDERS ADD CONSTRAINT ORDERS_STATES_FK FOREIGN KEY (
state_id ) REFERENCES STATES ( state_id ) ;

ALTER TABLE SELLERS ADD CONSTRAINT SELLERS_STATES_FK FOREIGN KEY (
state_id ) REFERENCES STATES ( state_id ) ;

ALTER TABLE SELLERS ADD CONSTRAINT SELLERS_USERS_FK FOREIGN KEY (
user_id ) REFERENCES USERS ( user_id ) ;

ALTER TABLE SHOPS ADD CONSTRAINT SHOPS_SELLERS_FK FOREIGN KEY (
user_id ) REFERENCES SELLERS ( user_id ) ;

ALTER TABLE SHOPS ADD CONSTRAINT SHOPS_SHOP_TYPES_FK FOREIGN KEY (
shop_type_id ) REFERENCES SHOP_TYPES ( shop_type_id ) ;

ALTER TABLE SHOPS ADD CONSTRAINT SHOPS_STATES_FK FOREIGN KEY (
state_id ) REFERENCES STATES ( state_id ) ;

ALTER TABLE USERS ADD CONSTRAINT USERS_PEOPLE_FK FOREIGN KEY (
person_id ) REFERENCES PEOPLE ( person_id ) ;

ALTER TABLE USERS ADD CONSTRAINT USERS_STATES_FK FOREIGN KEY (
state_id ) REFERENCES STATES ( state_id ) ;


-- Informe de Resumen de Oracle SQL Developer Data Modeler:
--
-- CREATE TABLE                            14
-- CREATE INDEX                             0
-- ALTER TABLE                             90
-- CREATE VIEW                              0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
--
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
--
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
--
-- ERRORS                                   0
-- WARNINGS                                 0
