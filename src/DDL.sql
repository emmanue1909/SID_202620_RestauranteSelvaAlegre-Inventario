-- ============================================================
-- SCRIPT DDL
--
-- NOTA: la columna "date" del modelo se renombro a purchase_date,
-- order_date y movement_date (segun la tabla) porque "date" sin
-- comillas colisiona con la palabra reservada DATE en Oracle.
--
-- NOTA: las columnas de cantidad/stock/unidad de medida que en el
-- modelo aparecian como NUMBER(2,100) y NUMBER(1,100) se ajustaron
-- a NUMBER(5,2) (5 digitos en total, 2 decimales -> rango -999.99
-- a 999.99).
-- 1. La entidad TYPE se renombro a TYPE_MOVEMENT y la columna
--    MOVEMENTS.TYPE_name paso a llamarse TYPE_MOVEMENT_name,
--    tal como quedo en el nuevo MER.
-- 2. MOVEMENTS.PURCHASESUPPLIERS_id y MOVEMENTS.ORDERS_id ya no
--    son obligatorias (NOT NULL): ahora son opcionales, y se
--    agrega un CHECK que obliga a que EXACTAMENTE una de las dos
--    tenga valor (arco exclusivo de Barker: un movimiento viene
--    de una compra o de un pedido, nunca de ambos ni de ninguno).
-- ============================================================

-- ============================================================
-- DROP de tablas (orden inverso a la creacion, por las FK)
-- CASCADE CONSTRAINTS elimina tambien las llaves foraneas
-- que dependan de cada tabla
-- ============================================================

DROP TABLE MOVEMENTS CASCADE CONSTRAINTS;
DROP TABLE ORDERDETAILS CASCADE CONSTRAINTS;
DROP TABLE PURCHASEDETAILS CASCADE CONSTRAINTS;
DROP TABLE ORDERS CASCADE CONSTRAINTS;
DROP TABLE INGREDIENTS CASCADE CONSTRAINTS;
DROP TABLE PLATE_DETAILS CASCADE CONSTRAINTS;
DROP TABLE PURCHASESUPPLIERS CASCADE CONSTRAINTS;
DROP TABLE PLATES CASCADE CONSTRAINTS;
DROP TABLE EMPLOYEES CASCADE CONSTRAINTS;
DROP TABLE TYPE_MOVEMENT CASCADE CONSTRAINTS;
DROP TABLE STATUS CASCADE CONSTRAINTS;
DROP TABLE SUPPLIERS CASCADE CONSTRAINTS;

-- ============================================================
-- Tablas sin dependencias
-- ============================================================

CREATE TABLE SUPPLIERS (
    nit     VARCHAR2(20)  NOT NULL,
    name    VARCHAR2(40)  NOT NULL,
    phone   VARCHAR2(15)  NOT NULL,
    email   VARCHAR2(20)  NOT NULL,
    CONSTRAINT SUPPLIERS_PK PRIMARY KEY (nit)
);

CREATE TABLE STATUS (
    name    VARCHAR2(20)  NOT NULL,
    CONSTRAINT STATUS_PK PRIMARY KEY (name)
);

CREATE TABLE TYPE_MOVEMENT (
    name    VARCHAR2(20)  NOT NULL,
    CONSTRAINT TYPE_MOVEMENT_PK PRIMARY KEY (name)
);

CREATE TABLE EMPLOYEES (
    id      VARCHAR2(20)  NOT NULL,
    name    VARCHAR2(15)  NOT NULL,
    email   VARCHAR2(20)  NOT NULL,
    phone   VARCHAR2(15)  NOT NULL,
    salary  NUMBER(10,2)     NOT NULL,
    zone    VARCHAR2(15),
    CONSTRAINT EMPLOYEES_PK PRIMARY KEY (id)
);

CREATE TABLE PLATES (
    id          VARCHAR2(20)   NOT NULL,
    name        VARCHAR2(20)   NOT NULL,
    price       NUMBER(10,2)      NOT NULL,
    description VARCHAR2(100)  NOT NULL,
    CONSTRAINT PLATES_PK PRIMARY KEY (id)
);

-- ============================================================
-- Tablas que dependen de las anteriores
-- ============================================================

CREATE TABLE PURCHASESUPPLIERS (
    id             VARCHAR2(20)  NOT NULL,
    purchase_date  DATE          NOT NULL,
    total_price    NUMBER(10,2)     NOT NULL,
    SUPPLIERS_nit  VARCHAR2(20)  NOT NULL,
    CONSTRAINT PURCHASESUPLIERS_PK PRIMARY KEY (id),
    CONSTRAINT PURCHASESUPPLIERS_SUPPLIERS_FK FOREIGN KEY (SUPPLIERS_nit)
        REFERENCES SUPPLIERS (nit)
);

CREATE TABLE PLATE_DETAILS (
    id_detail            VARCHAR2(20)   NOT NULL,
    quantity             NUMBER(5,2)  NOT NULL,
    restaurant_price     NUMBER(10,2)      NOT NULL,
    unit_of_measurement  NUMBER(5,2)  NOT NULL,
    PLATES_id            VARCHAR2(20)   NOT NULL,
    CONSTRAINT DETAILS_PK PRIMARY KEY (id_detail),
    CONSTRAINT DETAILS_PLATES_FK FOREIGN KEY (PLATES_id)
        REFERENCES PLATES (id)
);

-- ============================================================
-- Tablas de segundo nivel de dependencia
-- ============================================================

CREATE TABLE INGREDIENTS (
    id                   VARCHAR2(20)   NOT NULL,
    name                 VARCHAR2(15)   NOT NULL,
    unit_of_measurement  NUMBER(5,2)  NOT NULL,
    minimum_stock        NUMBER(5,2)  NOT NULL,
    current_stock        NUMBER(5,2)  NOT NULL,
    DETAILS_id_detail    VARCHAR2(20)   NOT NULL,
    CONSTRAINT SUPPLIES_PK PRIMARY KEY (id),
    CONSTRAINT SUPPLIES_DETAILS_FK FOREIGN KEY (DETAILS_id_detail)
        REFERENCES PLATE_DETAILS (id_detail)
);

CREATE TABLE ORDERS (
    id            VARCHAR2(20)  NOT NULL,
    order_date    DATE          NOT NULL,
    hour          DATE          NOT NULL,
    total_price   NUMBER(10,2)     NOT NULL,
    STATUS_name   VARCHAR2(20)  NOT NULL,
    EMPLOYEES_id  VARCHAR2(20)  NOT NULL,
    CONSTRAINT ORDERS_PK PRIMARY KEY (id),
    CONSTRAINT ORDERS_STATUS_FK FOREIGN KEY (STATUS_name)
        REFERENCES STATUS (name),
    CONSTRAINT ORDERS_EMPLOYEES_FK FOREIGN KEY (EMPLOYEES_id)
        REFERENCES EMPLOYEES (id)
);

CREATE TABLE PURCHASEDETAILS (
    id                    VARCHAR2(20)   NOT NULL,
    quantity              NUMBER(5,2)  NOT NULL,
    price                 NUMBER(10,2)      NOT NULL,
    unit_of_measurement   NUMBER(5,2)  NOT NULL,
    PURCHASESUPPLIERS_id  VARCHAR2(20)   NOT NULL,
    INGREDIENTS_id        VARCHAR2(20)   NOT NULL,
    CONSTRAINT PURCHASEDETAILS_PK PRIMARY KEY (id),
    CONSTRAINT PURCHASEDETAILS_PURCHASESUPPLIERS_FK FOREIGN KEY (PURCHASESUPPLIERS_id)
        REFERENCES PURCHASESUPPLIERS (id),
    CONSTRAINT PURCHASEDETAILS_SUPPLIES_FK FOREIGN KEY (INGREDIENTS_id)
        REFERENCES INGREDIENTS (id)
);

CREATE TABLE ORDERDETAILS (
    id              VARCHAR2(20)   NOT NULL,
    plate_quantity  NUMBER(5,2)  NOT NULL,
    ORDERS_id       VARCHAR2(20)   NOT NULL,
    PLATES_id       VARCHAR2(20)   NOT NULL,
    CONSTRAINT ORDERDETAILS_PK PRIMARY KEY (id),
    CONSTRAINT ORDERDETAILS_ORDERS_FK FOREIGN KEY (ORDERS_id)
        REFERENCES ORDERS (id),
    CONSTRAINT ORDERDETAILS_PLATES_FK FOREIGN KEY (PLATES_id)
        REFERENCES PLATES (id)
);

-- ============================================================
-- Tabla de mayor dependencia (ultima en crearse)
-- ============================================================

CREATE TABLE MOVEMENTS (
    id                    VARCHAR2(20)  NOT NULL,
    movement_date         DATE          NOT NULL,
    INGREDIENTS_id        VARCHAR2(20)  NOT NULL,
    TYPE_MOVEMENT_name    VARCHAR2(20)  NOT NULL,
    EMPLOYEES_id          VARCHAR2(20)  NOT NULL,
    PURCHASESUPPLIERS_id  VARCHAR2(20),
    ORDERS_id             VARCHAR2(20),
    CONSTRAINT MOVEMENTS_PK PRIMARY KEY (id),
    CONSTRAINT MOVEMENTS_SUPPLIES_FK FOREIGN KEY (INGREDIENTS_id)
        REFERENCES INGREDIENTS (id),
    CONSTRAINT MOVEMENTS_TYPE_FK FOREIGN KEY (TYPE_MOVEMENT_name)
        REFERENCES TYPE_MOVEMENT (name),
    CONSTRAINT MOVEMENTS_EMPLOYEES_FK FOREIGN KEY (EMPLOYEES_id)
        REFERENCES EMPLOYEES (id),
    CONSTRAINT MOVEMENTS_PURCHASESUPPLIERS_FK FOREIGN KEY (PURCHASESUPPLIERS_id)
        REFERENCES PURCHASESUPPLIERS (id),
    CONSTRAINT MOVEMENTS_ORDERS_FK FOREIGN KEY (ORDERS_id)
        REFERENCES ORDERS (id),
    CONSTRAINT MOVEMENTS_ORIGIN_XOR_CHK CHECK (
        (PURCHASESUPPLIERS_id IS NOT NULL AND ORDERS_id IS NULL)
     OR (PURCHASESUPPLIERS_id IS NULL AND ORDERS_id IS NOT NULL)
    )
);