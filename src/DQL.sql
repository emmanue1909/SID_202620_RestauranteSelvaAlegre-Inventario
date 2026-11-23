-- ------------------------------------------------------------
-- 1. Insumos bajo el stock minimo, con cuanto falta
-- ------------------------------------------------------------
-- Compara el stock actual contra el stock minimo de cada insumo;
-- si current_stock es menor, calcula la diferencia (faltante) y
-- ordena de mayor a menor faltante para priorizar reabastecimiento.
SELECT i.id, i.name AS insumo, i.minimum_stock AS stock_minimo, i.current_stock AS stock_actual, i.minimum_stock - i.current_stock AS faltante
FROM INGREDIENTS i
WHERE i.current_stock < i.minimum_stock
ORDER BY faltante DESC;


-- ------------------------------------------------------------
-- 2. Valor total del inventario (usando el precio promedio de compra)
-- ------------------------------------------------------------
-- Para cada insumo, promedia el precio pagado en sus compras
-- (PURCHASEDETAILS) y lo multiplica por el stock actual, para
-- estimar cuanto vale en pesos lo que hay guardado de ese insumo.
SELECT i.name AS insumo, i.current_stock AS stock_actual, AVG(pd.price) AS precio_promedio, i.current_stock * AVG(pd.price) AS valor_inventario
FROM INGREDIENTS i
INNER JOIN PURCHASEDETAILS pd ON pd.INGREDIENTS_id = i.id
GROUP BY i.name, i.current_stock
ORDER BY valor_inventario DESC;


-- ------------------------------------------------------------
-- 3. Historial de movimientos de un insumo en un rango de fechas,
--    con el responsable
-- ------------------------------------------------------------
-- Filtra los movimientos de un insumo especifico (aqui ING01) dentro
-- de un rango de fechas, y trae el nombre del empleado que registro
-- cada movimiento. Para consultar otro insumo o rango, solo cambias
-- los valores del WHERE.
SELECT m.id, m.movement_date AS fecha, i.name AS insumo, m.TYPE_MOVEMENT_name AS tipo, e.name AS responsable
FROM MOVEMENTS m
INNER JOIN INGREDIENTS i ON i.id = m.INGREDIENTS_id
INNER JOIN EMPLOYEES e ON e.id = m.EMPLOYEES_id
WHERE m.INGREDIENTS_id = 'ING01' AND m.movement_date BETWEEN DATE '2026-10-01' AND DATE '2026-11-30'
ORDER BY m.movement_date;


-- ------------------------------------------------------------
-- 4. Proveedor mas barato por insumo (subconsulta correlacionada)
-- ------------------------------------------------------------
-- Para cada linea de compra, compara su precio contra el precio
-- minimo pagado historicamente por ese mismo insumo (la subconsulta
-- se vuelve a evaluar por cada fila externa, usando el
-- pd.INGREDIENTS_id de esa fila -- por eso es "correlacionada").
-- Se queda solo con las lineas que si fueron el precio mas bajo
-- registrado para ese insumo.
SELECT i.name AS insumo, s.name AS proveedor, pd.price AS precio
FROM PURCHASEDETAILS pd
INNER JOIN INGREDIENTS i ON i.id = pd.INGREDIENTS_id
INNER JOIN PURCHASESUPPLIERS ps ON ps.id = pd.PURCHASESUPPLIERS_id
INNER JOIN SUPPLIERS s ON s.nit = ps.SUPPLIERS_nit
WHERE pd.price = (SELECT MIN(pd2.price) FROM PURCHASEDETAILS pd2 WHERE pd2.INGREDIENTS_id = pd.INGREDIENTS_id)
ORDER BY i.name;


-- ------------------------------------------------------------
-- 5. Costo de insumos por plato vendido (rentabilidad)
-- ------------------------------------------------------------
-- Recorre la ficha tecnica de cada plato (PLATE_DETAILS -> INGREDIENTS)
-- y suma lo que cuestan sus insumos (cantidad usada x precio de compra)
-- para sacar el costo por unidad; se lo resta al precio de venta para
-- el margen por unidad; y multiplica ambos por las unidades vendidas
-- (subconsulta "v", que suma plate_quantity por plato en ORDERDETAILS)
-- para llegar al costo total y la utilidad total.
SELECT p.name AS plato, v.unidades AS unidades_vendidas, p.price AS precio_venta, SUM(d.quantity * pd.price) AS costo_unidad, p.price - SUM(d.quantity * pd.price) AS margen_unidad, v.unidades * SUM(d.quantity * pd.price) AS costo_total, v.unidades * (p.price - SUM(d.quantity * pd.price)) AS utilidad_total
FROM PLATES p
INNER JOIN PLATE_DETAILS d ON d.PLATES_id = p.id
INNER JOIN INGREDIENTS i ON i.DETAILS_id_detail = d.id_detail
INNER JOIN PURCHASEDETAILS pd ON pd.INGREDIENTS_id = i.id
INNER JOIN (SELECT PLATES_id, SUM(plate_quantity) AS unidades FROM ORDERDETAILS GROUP BY PLATES_id) v ON v.PLATES_id = p.id
GROUP BY p.name, p.price, v.unidades
ORDER BY utilidad_total DESC;


-- ------------------------------------------------------------
-- 6. Pedidos sin entregar, con responsable y dias transcurridos
-- ------------------------------------------------------------
-- Filtra los pedidos cuyo estado no es 'Entregado' y calcula cuantos
-- dias han pasado desde que se hizo el pedido, restando la fecha del
-- pedido a la fecha de hoy (SYSDATE). En Oracle, restar dos fechas
-- da directamente el numero de dias de diferencia.
SELECT o.id, o.order_date AS fecha_pedido, o.STATUS_name AS estado, e.name AS atendido_por, SYSDATE - o.order_date AS dias_transcurridos
FROM ORDERS o
INNER JOIN EMPLOYEES e ON e.id = o.EMPLOYEES_id
WHERE o.STATUS_name <> 'Entregado'
ORDER BY dias_transcurridos DESC;


-- ------------------------------------------------------------
-- 7. Historial de compras por proveedor
-- ------------------------------------------------------------
-- Para cada proveedor cuenta cuantas compras le ha hecho el
-- restaurante, suma lo gastado en total y saca la fecha de la
-- compra mas reciente. Se usa LEFT JOIN (en vez de INNER JOIN)
-- para que tambien aparezcan proveedores sin compras registradas.
SELECT s.name AS proveedor, COUNT(ps.id) AS numero_compras, SUM(ps.total_price) AS total_gastado, MAX(ps.purchase_date) AS ultima_compra
FROM SUPPLIERS s
LEFT JOIN PURCHASESUPPLIERS ps ON ps.SUPPLIERS_nit = s.nit
GROUP BY s.name
ORDER BY total_gastado DESC;


-- ------------------------------------------------------------
-- 8. Platos mas vendidos, con unidades y plata generada
-- ------------------------------------------------------------
-- Suma las unidades vendidas de cada plato (plate_quantity) y la
-- plata que genero (unidades x precio). Se ordena por unidades
-- vendidas de mayor a menor, porque eso es lo que define "mas
-- vendido" (si se quisiera ordenar por dinero generado en vez de
-- unidades, el ORDER BY cambiaria a plata_generada DESC).
SELECT p.name AS plato, sum(o.plate_quantity) AS cantidad_platos, sum(o.plate_quantity * p.price) AS plata_generada
FROM ORDERDETAILS o JOIN PLATES p ON o.plates_id=p.id
GROUP BY p.name, p.price
ORDER BY cantidad_platos DESC;


-- ------------------------------------------------------------
-- 9. Platos que nunca se han pedido
-- ------------------------------------------------------------
-- LEFT JOIN desde PLATES hacia ORDERDETAILS: trae todos los platos,
-- y cuando un plato no tiene ninguna fila de ORDERDETAILS que le
-- calce, esas columnas quedan en NULL. Filtrando por o.id IS NULL
-- te quedas solo con los platos que nunca encontraron pareja.
SELECT p.id, p.name
FROM PLATES p LEFT JOIN ORDERDETAILS o ON o.plates_id = p.id
WHERE o.id IS NULL;


-- ------------------------------------------------------------
-- 10a. Ventas por empleado, agrupado, con total vendido y
--      numero de pedidos
-- ------------------------------------------------------------
-- Agrupa los pedidos por el empleado que los atendio, sumando el
-- total vendido y contando cuantos pedidos atendio cada uno.
SELECT e.id,e.name AS nombre_empleado, sum(o.total_price) AS total_ventas, count(o.id) AS numero_pedidos
FROM EMPLOYEES e JOIN ORDERS o ON o.employees_id = e.id
GROUP BY e.id, e.name;

-- ------------------------------------------------------------
-- 10b. Ventas por zona, agrupado, con total vendido y numero
--      de pedidos
-- ------------------------------------------------------------
-- Misma idea que la anterior pero agrupando por la zona del
-- empleado (Cocina, Salon, etc.) en vez de por cada persona.
SELECT e.zone, count(o.id) AS numero_pedidos, sum(o.total_price) AS total_vendido
FROM EMPLOYEES e JOIN ORDERS o ON o.employees_id = e.id
GROUP BY e.zone
ORDER BY total_vendido DESC;


-- ------------------------------------------------------------
-- 11. Compras por mes, con el gasto total de cada mes
-- ------------------------------------------------------------
-- TO_CHAR(purchase_date, 'YYYY-MM') convierte cada fecha a su
-- "ano-mes" (ej. '2026-10'), para que todas las compras del mismo
-- mes agrupen juntas, y suma cuanto se gasto y cuantas compras
-- hubo en cada mes.
SELECT TO_CHAR(purchase_date, 'YYYY-MM') AS mes, count(id) AS numero_compras, sum(total_price) AS gasto_total
FROM PURCHASESUPPLIERS
GROUP BY TO_CHAR(purchase_date, 'YYYY-MM')
ORDER BY mes;


-- ------------------------------------------------------------
-- 12. Compras con total mayor al promedio de todas las compras
-- ------------------------------------------------------------
-- La subconsulta calcula un solo numero: el promedio de total_price
-- de todas las compras. El WHERE externo compara cada compra
-- individual contra ese promedio fijo.
SELECT id, purchase_date, total_price
FROM PURCHASESUPPLIERS
WHERE total_price > (SELECT AVG(total_price) FROM PURCHASESUPPLIERS)
ORDER BY total_price DESC;