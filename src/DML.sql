-- ============================================================
-- SCRIPT DML - Datos de prueba
-- Restaurante Selva Alegre - Modulo de Inventario y Proveedores
--
-- Objetivo: cargar tuplas suficientes para alimentar los 4
-- reportes propuestos en la Entrega 0 ampliada, con al menos
-- 10 registros de soporte para cada uno:
--   1. Insumos con stock por debajo del minimo        (>=10 filas)
--   2. Historial de compras por proveedor              (12 compras)
--   3. Costo de insumos por plato vendido (rentabilidad)(12 pedidos)
--   4. Valor total del inventario disponible            (12 insumos)
--
-- NOTA sobre MOVEMENTS (MR v2 - arco exclusivo): PURCHASESUPPLIERS_id
-- y ORDERS_id ahora son opcionales, con un CHECK que obliga a que
-- cada movimiento tenga EXACTAMENTE una de las dos. Los movimientos
-- de tipo 'Entrada' quedan asociados a la compra que los origino
-- (PURCHASESUPPLIERS_id con valor, ORDERS_id en NULL); los de tipo
-- 'Salida' quedan asociados al pedido que consumio el insumo
-- (ORDERS_id con valor, PURCHASESUPPLIERS_id en NULL).
--
-- La tabla TYPE se renombro a TYPE_MOVEMENT y la columna
-- MOVEMENTS.TYPE_name paso a llamarse TYPE_MOVEMENT_name.
--
-- Orden de insercion: igual al orden de creacion de tablas en el
-- DDL, para respetar las dependencias de llave foranea.
-- ============================================================

-- ============================================================
-- 1. SUPPLIERS
-- ============================================================
INSERT INTO SUPPLIERS (nit, name, phone, email) VALUES ('SUP01', 'Distribuidora La Sabana', '3101234567', 'lasabana@mail.com');
INSERT INTO SUPPLIERS (nit, name, phone, email) VALUES ('SUP02', 'AgroFresh S.A.S.', '3112345678', 'agrofresh@mail.com');
INSERT INTO SUPPLIERS (nit, name, phone, email) VALUES ('SUP03', 'Carnes del Valle', '3123456789', 'carnesvalle@mail.com');
INSERT INTO SUPPLIERS (nit, name, phone, email) VALUES ('SUP04', 'Lacteos Andinos', '3134567890', 'lacteos@mail.com');
INSERT INTO SUPPLIERS (nit, name, phone, email) VALUES ('SUP05', 'Especias y Condimentos JM', '3145678901', 'especiasjm@mail.com');

-- ============================================================
-- 2. STATUS
-- ============================================================
INSERT INTO STATUS (name) VALUES ('Pendiente');
INSERT INTO STATUS (name) VALUES ('En preparacion');
INSERT INTO STATUS (name) VALUES ('Entregado');

-- ============================================================
-- 3. TYPE_MOVEMENT
-- ============================================================
INSERT INTO TYPE_MOVEMENT (name) VALUES ('Entrada');
INSERT INTO TYPE_MOVEMENT (name) VALUES ('Salida');

-- ============================================================
-- 4. EMPLOYEES
-- ============================================================
INSERT INTO EMPLOYEES (id, name, email, phone, salary, zone) VALUES ('EMP01', 'Carlos Ramirez', 'carlos@mail.com', '3001112233', 1800000.00, 'Cocina');
INSERT INTO EMPLOYEES (id, name, email, phone, salary, zone) VALUES ('EMP02', 'Laura Gomez', 'laura@mail.com', '3002223344', 1600000.00, 'Salon');
INSERT INTO EMPLOYEES (id, name, email, phone, salary, zone) VALUES ('EMP03', 'Andres Torres', 'andres@mail.com', '3003334455', 2000000.00, 'Administracion');
INSERT INTO EMPLOYEES (id, name, email, phone, salary, zone) VALUES ('EMP04', 'Diana Castro', 'diana@mail.com', '3004445566', 1700000.00, 'Cocina');
INSERT INTO EMPLOYEES (id, name, email, phone, salary, zone) VALUES ('EMP05', 'Felipe Ortiz', 'felipe@mail.com', '3005556677', 1600000.00, 'Salon');
INSERT INTO EMPLOYEES (id, name, email, phone, salary, zone) VALUES ('EMP06', 'Marcela Ruiz', 'marcela@mail.com', '3006667788', 1900000.00, 'Bodega');

-- ============================================================
-- 5. PLATES
-- ============================================================
INSERT INTO PLATES (id, name, price, description) VALUES ('PLT01', 'Bandeja Paisa', 28000.00, 'Plato tipico con frijoles, arroz, carne, chicharron, huevo y aguacate');
INSERT INTO PLATES (id, name, price, description) VALUES ('PLT02', 'Ajiaco Santafereno', 22000.00, 'Sopa tipica de pollo con tres tipos de papa, mazorca y guascas');
INSERT INTO PLATES (id, name, price, description) VALUES ('PLT03', 'Sancocho de Gallina', 25000.00, 'Sopa tradicional con gallina, platano y yuca');
INSERT INTO PLATES (id, name, price, description) VALUES ('PLT04', 'Lomo al Trapo', 32000.00, 'Lomo de res cocido en sal, acompanado de papa criolla');
INSERT INTO PLATES (id, name, price, description) VALUES ('PLT05', 'Ensalada Tropical', 18000.00, 'Mezcla de vegetales frescos con frutas de temporada');

-- ============================================================
-- 6. PURCHASESUPPLIERS (12 compras -> soporta reporte 2)
-- ============================================================
INSERT INTO PURCHASESUPPLIERS (id, purchase_date, total_price, SUPPLIERS_nit) VALUES ('PC01', TO_DATE('2026-10-01','YYYY-MM-DD'), 450000.00, 'SUP01');
INSERT INTO PURCHASESUPPLIERS (id, purchase_date, total_price, SUPPLIERS_nit) VALUES ('PC02', TO_DATE('2026-10-03','YYYY-MM-DD'), 320000.00, 'SUP02');
INSERT INTO PURCHASESUPPLIERS (id, purchase_date, total_price, SUPPLIERS_nit) VALUES ('PC03', TO_DATE('2026-10-05','YYYY-MM-DD'), 580000.00, 'SUP03');
INSERT INTO PURCHASESUPPLIERS (id, purchase_date, total_price, SUPPLIERS_nit) VALUES ('PC04', TO_DATE('2026-10-08','YYYY-MM-DD'), 210000.00, 'SUP04');
INSERT INTO PURCHASESUPPLIERS (id, purchase_date, total_price, SUPPLIERS_nit) VALUES ('PC05', TO_DATE('2026-10-10','YYYY-MM-DD'), 150000.00, 'SUP05');
INSERT INTO PURCHASESUPPLIERS (id, purchase_date, total_price, SUPPLIERS_nit) VALUES ('PC06', TO_DATE('2026-10-15','YYYY-MM-DD'), 470000.00, 'SUP01');
INSERT INTO PURCHASESUPPLIERS (id, purchase_date, total_price, SUPPLIERS_nit) VALUES ('PC07', TO_DATE('2026-10-18','YYYY-MM-DD'), 390000.00, 'SUP02');
INSERT INTO PURCHASESUPPLIERS (id, purchase_date, total_price, SUPPLIERS_nit) VALUES ('PC08', TO_DATE('2026-10-22','YYYY-MM-DD'), 610000.00, 'SUP03');
INSERT INTO PURCHASESUPPLIERS (id, purchase_date, total_price, SUPPLIERS_nit) VALUES ('PC09', TO_DATE('2026-10-25','YYYY-MM-DD'), 230000.00, 'SUP04');
INSERT INTO PURCHASESUPPLIERS (id, purchase_date, total_price, SUPPLIERS_nit) VALUES ('PC10', TO_DATE('2026-10-29','YYYY-MM-DD'), 175000.00, 'SUP05');
INSERT INTO PURCHASESUPPLIERS (id, purchase_date, total_price, SUPPLIERS_nit) VALUES ('PC11', TO_DATE('2026-11-03','YYYY-MM-DD'), 500000.00, 'SUP01');
INSERT INTO PURCHASESUPPLIERS (id, purchase_date, total_price, SUPPLIERS_nit) VALUES ('PC12', TO_DATE('2026-11-07','YYYY-MM-DD'), 340000.00, 'SUP02');

-- ============================================================
-- 7. PLATE_DETAILS (una ficha tecnica por plato)
-- ============================================================
INSERT INTO PLATE_DETAILS (id_detail, quantity, restaurant_price, unit_of_measurement, PLATES_id) VALUES ('DET01', 1.00, 28000.00, 1.00, 'PLT01');
INSERT INTO PLATE_DETAILS (id_detail, quantity, restaurant_price, unit_of_measurement, PLATES_id) VALUES ('DET02', 1.00, 22000.00, 1.00, 'PLT02');
INSERT INTO PLATE_DETAILS (id_detail, quantity, restaurant_price, unit_of_measurement, PLATES_id) VALUES ('DET03', 1.00, 25000.00, 1.00, 'PLT03');
INSERT INTO PLATE_DETAILS (id_detail, quantity, restaurant_price, unit_of_measurement, PLATES_id) VALUES ('DET04', 1.00, 32000.00, 1.00, 'PLT04');
INSERT INTO PLATE_DETAILS (id_detail, quantity, restaurant_price, unit_of_measurement, PLATES_id) VALUES ('DET05', 1.00, 18000.00, 1.00, 'PLT05');

-- ============================================================
-- 8. INGREDIENTS (12 insumos; 10 por debajo del stock minimo
--    -> soporta reporte 1 y reporte 4)
-- ============================================================
INSERT INTO INGREDIENTS (id, name, unit_of_measurement, minimum_stock, current_stock, DETAILS_id_detail) VALUES ('ING01', 'Frijol', 1.00, 50.00, 12.00, 'DET01');       -- bajo minimo
INSERT INTO INGREDIENTS (id, name, unit_of_measurement, minimum_stock, current_stock, DETAILS_id_detail) VALUES ('ING02', 'Arroz', 1.00, 80.00, 25.00, 'DET01');        -- bajo minimo
INSERT INTO INGREDIENTS (id, name, unit_of_measurement, minimum_stock, current_stock, DETAILS_id_detail) VALUES ('ING03', 'Carne de Res', 1.00, 40.00, 10.00, 'DET01'); -- bajo minimo
INSERT INTO INGREDIENTS (id, name, unit_of_measurement, minimum_stock, current_stock, DETAILS_id_detail) VALUES ('ING04', 'Chicharron', 1.00, 30.00, 8.00, 'DET01');    -- bajo minimo
INSERT INTO INGREDIENTS (id, name, unit_of_measurement, minimum_stock, current_stock, DETAILS_id_detail) VALUES ('ING05', 'Papa Criolla', 1.00, 60.00, 55.00, 'DET02'); -- OK
INSERT INTO INGREDIENTS (id, name, unit_of_measurement, minimum_stock, current_stock, DETAILS_id_detail) VALUES ('ING06', 'Mazorca', 3.00, 40.00, 15.00, 'DET02');      -- bajo minimo
INSERT INTO INGREDIENTS (id, name, unit_of_measurement, minimum_stock, current_stock, DETAILS_id_detail) VALUES ('ING07', 'Pollo', 1.00, 35.00, 9.00, 'DET02');         -- bajo minimo
INSERT INTO INGREDIENTS (id, name, unit_of_measurement, minimum_stock, current_stock, DETAILS_id_detail) VALUES ('ING08', 'Yuca', 1.00, 45.00, 40.00, 'DET03');         -- OK
INSERT INTO INGREDIENTS (id, name, unit_of_measurement, minimum_stock, current_stock, DETAILS_id_detail) VALUES ('ING09', 'Platano', 1.00, 50.00, 18.00, 'DET03');      -- bajo minimo
INSERT INTO INGREDIENTS (id, name, unit_of_measurement, minimum_stock, current_stock, DETAILS_id_detail) VALUES ('ING10', 'Lomo de Res', 1.00, 25.00, 6.00, 'DET04');   -- bajo minimo
INSERT INTO INGREDIENTS (id, name, unit_of_measurement, minimum_stock, current_stock, DETAILS_id_detail) VALUES ('ING11', 'Lechuga', 1.00, 20.00, 5.00, 'DET05');       -- bajo minimo
INSERT INTO INGREDIENTS (id, name, unit_of_measurement, minimum_stock, current_stock, DETAILS_id_detail) VALUES ('ING12', 'Tomate', 1.00, 30.00, 7.00, 'DET05');        -- bajo minimo

-- ============================================================
-- 9. ORDERS (12 pedidos -> soporta reporte 3)
-- ============================================================
INSERT INTO ORDERS (id, order_date, hour, total_price, STATUS_name, EMPLOYEES_id) VALUES ('OR01', TO_DATE('2026-10-02','YYYY-MM-DD'), TO_DATE('2026-10-02 12:30:00','YYYY-MM-DD HH24:MI:SS'), 28000.00, 'Entregado', 'EMP01');
INSERT INTO ORDERS (id, order_date, hour, total_price, STATUS_name, EMPLOYEES_id) VALUES ('OR02', TO_DATE('2026-10-03','YYYY-MM-DD'), TO_DATE('2026-10-03 13:15:00','YYYY-MM-DD HH24:MI:SS'), 44000.00, 'Entregado', 'EMP02');
INSERT INTO ORDERS (id, order_date, hour, total_price, STATUS_name, EMPLOYEES_id) VALUES ('OR03', TO_DATE('2026-10-05','YYYY-MM-DD'), TO_DATE('2026-10-05 19:00:00','YYYY-MM-DD HH24:MI:SS'), 25000.00, 'Entregado', 'EMP01');
INSERT INTO ORDERS (id, order_date, hour, total_price, STATUS_name, EMPLOYEES_id) VALUES ('OR04', TO_DATE('2026-10-07','YYYY-MM-DD'), TO_DATE('2026-10-07 20:10:00','YYYY-MM-DD HH24:MI:SS'), 32000.00, 'Entregado', 'EMP04');
INSERT INTO ORDERS (id, order_date, hour, total_price, STATUS_name, EMPLOYEES_id) VALUES ('OR05', TO_DATE('2026-10-10','YYYY-MM-DD'), TO_DATE('2026-10-10 12:45:00','YYYY-MM-DD HH24:MI:SS'), 18000.00, 'Entregado', 'EMP02');
INSERT INTO ORDERS (id, order_date, hour, total_price, STATUS_name, EMPLOYEES_id) VALUES ('OR06', TO_DATE('2026-10-12','YYYY-MM-DD'), TO_DATE('2026-10-12 13:30:00','YYYY-MM-DD HH24:MI:SS'), 56000.00, 'Entregado', 'EMP01');
INSERT INTO ORDERS (id, order_date, hour, total_price, STATUS_name, EMPLOYEES_id) VALUES ('OR07', TO_DATE('2026-10-15','YYYY-MM-DD'), TO_DATE('2026-10-15 19:20:00','YYYY-MM-DD HH24:MI:SS'), 22000.00, 'Entregado', 'EMP04');
INSERT INTO ORDERS (id, order_date, hour, total_price, STATUS_name, EMPLOYEES_id) VALUES ('OR08', TO_DATE('2026-10-18','YYYY-MM-DD'), TO_DATE('2026-10-18 20:00:00','YYYY-MM-DD HH24:MI:SS'), 50000.00, 'En preparacion', 'EMP02');
INSERT INTO ORDERS (id, order_date, hour, total_price, STATUS_name, EMPLOYEES_id) VALUES ('OR09', TO_DATE('2026-10-21','YYYY-MM-DD'), TO_DATE('2026-10-21 12:50:00','YYYY-MM-DD HH24:MI:SS'), 32000.00, 'Pendiente', 'EMP01');
INSERT INTO ORDERS (id, order_date, hour, total_price, STATUS_name, EMPLOYEES_id) VALUES ('OR10', TO_DATE('2026-10-24','YYYY-MM-DD'), TO_DATE('2026-10-24 13:40:00','YYYY-MM-DD HH24:MI:SS'), 18000.00, 'Entregado', 'EMP04');
INSERT INTO ORDERS (id, order_date, hour, total_price, STATUS_name, EMPLOYEES_id) VALUES ('OR11', TO_DATE('2026-10-28','YYYY-MM-DD'), TO_DATE('2026-10-28 19:10:00','YYYY-MM-DD HH24:MI:SS'), 28000.00, 'Entregado', 'EMP02');
INSERT INTO ORDERS (id, order_date, hour, total_price, STATUS_name, EMPLOYEES_id) VALUES ('OR12', TO_DATE('2026-11-02','YYYY-MM-DD'), TO_DATE('2026-11-02 20:25:00','YYYY-MM-DD HH24:MI:SS'), 44000.00, 'Entregado', 'EMP01');

-- ============================================================
-- 10. PURCHASEDETAILS (12 lineas -> precio de referencia por
--     insumo, usado para el reporte 4)
-- ============================================================
INSERT INTO PURCHASEDETAILS (id, quantity, price, unit_of_measurement, PURCHASESUPPLIERS_id, INGREDIENTS_id) VALUES ('PD01', 100.00, 4500.00, 1.00, 'PC01', 'ING01');
INSERT INTO PURCHASEDETAILS (id, quantity, price, unit_of_measurement, PURCHASESUPPLIERS_id, INGREDIENTS_id) VALUES ('PD02', 150.00, 3200.00, 1.00, 'PC02', 'ING02');
INSERT INTO PURCHASEDETAILS (id, quantity, price, unit_of_measurement, PURCHASESUPPLIERS_id, INGREDIENTS_id) VALUES ('PD03', 60.00, 18000.00, 1.00, 'PC03', 'ING03');
INSERT INTO PURCHASEDETAILS (id, quantity, price, unit_of_measurement, PURCHASESUPPLIERS_id, INGREDIENTS_id) VALUES ('PD04', 40.00, 15000.00, 1.00, 'PC04', 'ING04');
INSERT INTO PURCHASEDETAILS (id, quantity, price, unit_of_measurement, PURCHASESUPPLIERS_id, INGREDIENTS_id) VALUES ('PD05', 120.00, 2800.00, 1.00, 'PC05', 'ING05');
INSERT INTO PURCHASEDETAILS (id, quantity, price, unit_of_measurement, PURCHASESUPPLIERS_id, INGREDIENTS_id) VALUES ('PD06', 90.00, 1500.00, 3.00, 'PC06', 'ING06');
INSERT INTO PURCHASEDETAILS (id, quantity, price, unit_of_measurement, PURCHASESUPPLIERS_id, INGREDIENTS_id) VALUES ('PD07', 50.00, 9000.00, 1.00, 'PC07', 'ING07');
INSERT INTO PURCHASEDETAILS (id, quantity, price, unit_of_measurement, PURCHASESUPPLIERS_id, INGREDIENTS_id) VALUES ('PD08', 100.00, 2000.00, 1.00, 'PC08', 'ING08');
INSERT INTO PURCHASEDETAILS (id, quantity, price, unit_of_measurement, PURCHASESUPPLIERS_id, INGREDIENTS_id) VALUES ('PD09', 80.00, 1800.00, 1.00, 'PC09', 'ING09');
INSERT INTO PURCHASEDETAILS (id, quantity, price, unit_of_measurement, PURCHASESUPPLIERS_id, INGREDIENTS_id) VALUES ('PD10', 30.00, 22000.00, 1.00, 'PC10', 'ING10');
INSERT INTO PURCHASEDETAILS (id, quantity, price, unit_of_measurement, PURCHASESUPPLIERS_id, INGREDIENTS_id) VALUES ('PD11', 45.00, 2500.00, 1.00, 'PC11', 'ING11');
INSERT INTO PURCHASEDETAILS (id, quantity, price, unit_of_measurement, PURCHASESUPPLIERS_id, INGREDIENTS_id) VALUES ('PD12', 55.00, 3000.00, 1.00, 'PC12', 'ING12');

-- ============================================================
-- 11. ORDERDETAILS (12 lineas de platos vendidos -> soporta
--     directamente el reporte 3)
-- ============================================================
INSERT INTO ORDERDETAILS (id, plate_quantity, ORDERS_id, PLATES_id) VALUES ('OD01', 1.00, 'OR01', 'PLT01');
INSERT INTO ORDERDETAILS (id, plate_quantity, ORDERS_id, PLATES_id) VALUES ('OD02', 2.00, 'OR02', 'PLT02');
INSERT INTO ORDERDETAILS (id, plate_quantity, ORDERS_id, PLATES_id) VALUES ('OD03', 1.00, 'OR03', 'PLT03');
INSERT INTO ORDERDETAILS (id, plate_quantity, ORDERS_id, PLATES_id) VALUES ('OD04', 1.00, 'OR04', 'PLT04');
INSERT INTO ORDERDETAILS (id, plate_quantity, ORDERS_id, PLATES_id) VALUES ('OD05', 1.00, 'OR05', 'PLT05');
INSERT INTO ORDERDETAILS (id, plate_quantity, ORDERS_id, PLATES_id) VALUES ('OD06', 2.00, 'OR06', 'PLT01');
INSERT INTO ORDERDETAILS (id, plate_quantity, ORDERS_id, PLATES_id) VALUES ('OD07', 1.00, 'OR07', 'PLT02');
INSERT INTO ORDERDETAILS (id, plate_quantity, ORDERS_id, PLATES_id) VALUES ('OD08', 2.00, 'OR08', 'PLT03');
INSERT INTO ORDERDETAILS (id, plate_quantity, ORDERS_id, PLATES_id) VALUES ('OD09', 1.00, 'OR09', 'PLT04');
INSERT INTO ORDERDETAILS (id, plate_quantity, ORDERS_id, PLATES_id) VALUES ('OD10', 1.00, 'OR10', 'PLT05');
INSERT INTO ORDERDETAILS (id, plate_quantity, ORDERS_id, PLATES_id) VALUES ('OD11', 1.00, 'OR11', 'PLT01');
INSERT INTO ORDERDETAILS (id, plate_quantity, ORDERS_id, PLATES_id) VALUES ('OD12', 2.00, 'OR12', 'PLT02');

-- ============================================================
-- 12. MOVEMENTS (12 movimientos de inventario; cada fila queda
--     asociada a un insumo, un tipo y un empleado, mas EXACTAMENTE
--     una de las dos: la compra que la origino (Entrada) o el
--     pedido que la consumio (Salida) -> arco exclusivo)
-- ============================================================
INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id, TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id) VALUES ('MOV01', TO_DATE('2026-10-01','YYYY-MM-DD'), 'ING01', 'Entrada', 'EMP06', 'PC01', NULL);
INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id, TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id) VALUES ('MOV02', TO_DATE('2026-10-03','YYYY-MM-DD'), 'ING02', 'Entrada', 'EMP06', 'PC02', NULL);
INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id, TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id) VALUES ('MOV03', TO_DATE('2026-10-05','YYYY-MM-DD'), 'ING03', 'Entrada', 'EMP06', 'PC03', NULL);
INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id, TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id) VALUES ('MOV04', TO_DATE('2026-10-08','YYYY-MM-DD'), 'ING04', 'Entrada', 'EMP06', 'PC04', NULL);
INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id, TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id) VALUES ('MOV05', TO_DATE('2026-10-10','YYYY-MM-DD'), 'ING05', 'Entrada', 'EMP06', 'PC05', NULL);
INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id, TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id) VALUES ('MOV06', TO_DATE('2026-10-12','YYYY-MM-DD'), 'ING06', 'Salida', 'EMP01', NULL, 'OR06');
INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id, TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id) VALUES ('MOV07', TO_DATE('2026-10-15','YYYY-MM-DD'), 'ING07', 'Salida', 'EMP02', NULL, 'OR07');
INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id, TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id) VALUES ('MOV08', TO_DATE('2026-10-18','YYYY-MM-DD'), 'ING08', 'Salida', 'EMP04', NULL, 'OR08');
INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id, TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id) VALUES ('MOV09', TO_DATE('2026-10-21','YYYY-MM-DD'), 'ING09', 'Salida', 'EMP01', NULL, 'OR09');
INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id, TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id) VALUES ('MOV10', TO_DATE('2026-10-24','YYYY-MM-DD'), 'ING10', 'Salida', 'EMP02', NULL, 'OR10');
INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id, TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id) VALUES ('MOV11', TO_DATE('2026-11-03','YYYY-MM-DD'), 'ING11', 'Entrada', 'EMP06', 'PC11', NULL);
INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id, TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id) VALUES ('MOV12', TO_DATE('2026-11-07','YYYY-MM-DD'), 'ING12', 'Salida', 'EMP04', NULL, 'OR12');

COMMIT;