-- ============================================================
-- SCRIPT PL/SQL
-- Restaurante Selva Alegre - Modulo de Inventario y Proveedores
--
-- Contiene: 1 funcion, 1 procedimiento almacenado y 1 trigger.
-- ============================================================


-- ============================================================
-- FUNCION: costo_insumos_plato
-- ------------------------------------------------------------
-- Que hace: calcula el costo total de los insumos que lleva la
-- receta de un plato (su ficha tecnica en PLATE_DETAILS), para
-- saber cuanto le cuesta al restaurante prepararlo.
--
-- Como lo calcula: por cada insumo de la receta del plato,
-- multiplica la cantidad que usa (PLATE_DETAILS.quantity) por el
-- precio PROMEDIO al que se le ha comprado ese insumo (promedio
-- de PURCHASEDETAILS.price para ese insumo, por si se le ha
-- comprado mas de una vez a distintos precios), y suma todo.
--
-- Parametro:
--   p_plato_id -> el id del plato (PLATES.id) que se quiere costear
--
-- Retorna: NUMBER con el costo total de insumos de ese plato.
-- Si el plato no tiene receta registrada (como PLT06 o PLT07,
-- que agregamos sin PLATE_DETAILS), retorna 0.
--
-- Ejemplo de uso (se puede llamar dentro de un SELECT, porque
-- toda funcion siempre devuelve un valor):
--   SELECT name, costo_insumos_plato(id) AS costo_insumos
--   FROM PLATES;
-- ============================================================
CREATE OR REPLACE FUNCTION costo_insumos_plato (
    p_plato_id IN PLATES.id%TYPE
) RETURN NUMBER
IS
    v_costo NUMBER := 0;
BEGIN
    SELECT NVL(SUM(d.quantity * precio_prom.promedio), 0)
    INTO v_costo
    FROM PLATE_DETAILS d
    JOIN INGREDIENTS i
        ON i.DETAILS_id_detail = d.id_detail
    JOIN (
        SELECT INGREDIENTS_id, AVG(price) AS promedio
        FROM PURCHASEDETAILS
        GROUP BY INGREDIENTS_id
    ) precio_prom
        ON precio_prom.INGREDIENTS_id = i.id
    WHERE d.PLATES_id = p_plato_id;

    RETURN v_costo;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END costo_insumos_plato;
/


-- ============================================================
-- PROCEDIMIENTO: cambiar_estado_pedido
-- ------------------------------------------------------------
-- Que hace: cambia el estado de un pedido (ORDERS.STATUS_name),
-- por ejemplo de 'Pendiente' a 'En preparacion' o a 'Entregado',
-- centralizando esa logica en un solo lugar en vez de que cada
-- quien escriba su propio UPDATE.
--
-- Validaciones:
--   1. Si el pedido no existe, lanza un error propio y claro
--      (ORA-20001) en vez de simplemente no actualizar nada.
--   2. Si el estado no existe en la tabla STATUS, Oracle lo
--      rechaza solo por la llave foranea ORDERS_STATUS_FK (no
--      hace falta validarlo a mano).
--
-- Parametros:
--   p_pedido_id    -> el id del pedido a modificar (ORDERS.id)
--   p_nuevo_estado -> el nuevo estado (debe existir en STATUS)
--
-- No retorna nada (es un procedimiento, no una funcion): su
-- proposito es modificar datos, no calcular un valor.
--
-- Ejemplo de uso:
--   EXEC cambiar_estado_pedido('OR09', 'Entregado');
-- ============================================================
CREATE OR REPLACE PROCEDURE cambiar_estado_pedido (
    p_pedido_id    IN ORDERS.id%TYPE,
    p_nuevo_estado IN ORDERS.STATUS_name%TYPE
)
IS
    v_existe NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM ORDERS
    WHERE id = p_pedido_id;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El pedido ' || p_pedido_id || ' no existe.');
    END IF;

    UPDATE ORDERS
    SET STATUS_name = p_nuevo_estado
    WHERE id = p_pedido_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END cambiar_estado_pedido;
/


-- ============================================================
-- TRIGGER: trg_movements_tipo_origen
-- ------------------------------------------------------------
-- Que hace: se dispara automaticamente antes de cada INSERT o
-- UPDATE sobre MOVEMENTS, para validar que el tipo de movimiento
-- sea coherente con su origen:
--   - Si el movimiento viene de una COMPRA (PURCHASESUPPLIERS_id
--     tiene valor), el tipo debe ser 'Entrada'.
--   - Si el movimiento viene de un PEDIDO (ORDERS_id tiene valor),
--     el tipo debe ser 'Salida'.
--
-- Esto complementa al CHECK MOVEMENTS_ORIGIN_XOR_CHK del DDL: ese
-- CHECK ya garantiza que EXACTAMENTE una de las dos (compra o
-- pedido) tenga valor y la otra quede en NULL (el arco exclusivo);
-- este trigger agrega la otra mitad de la regla de negocio, que
-- el tipo de movimiento coincida con cual de las dos es.
--
-- No recibe parametros ni se llama manualmente: Oracle lo ejecuta
-- solo cada vez que alguien inserta o modifica una fila en
-- MOVEMENTS.
--
-- Ejemplo de prueba (debe fallar, porque trae PURCHASESUPPLIERS_id
-- pero el tipo dice 'Salida'):
--   INSERT INTO MOVEMENTS (id, movement_date, INGREDIENTS_id,
--       TYPE_MOVEMENT_name, EMPLOYEES_id, PURCHASESUPPLIERS_id, ORDERS_id)
--   VALUES ('MOVX', SYSDATE, 'ING01', 'Salida', 'EMP06', 'PC01', NULL);
-- ============================================================
CREATE OR REPLACE TRIGGER trg_movements_tipo_origen
BEFORE INSERT OR UPDATE ON MOVEMENTS
FOR EACH ROW
BEGIN
    IF :NEW.PURCHASESUPPLIERS_id IS NOT NULL AND :NEW.TYPE_MOVEMENT_name <> 'Entrada' THEN
        RAISE_APPLICATION_ERROR(-20010, 'Un movimiento originado en una compra debe ser de tipo Entrada.');
    END IF;

    IF :NEW.ORDERS_id IS NOT NULL AND :NEW.TYPE_MOVEMENT_name <> 'Salida' THEN
        RAISE_APPLICATION_ERROR(-20011, 'Un movimiento originado en un pedido debe ser de tipo Salida.');
    END IF;
END trg_movements_tipo_origen;
/