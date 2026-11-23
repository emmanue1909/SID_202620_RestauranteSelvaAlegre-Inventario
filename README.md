# Restaurante Selva Alegre: módulo de inventario y proveedores

Proyecto del curso **Sistemas Intensivos en Datos 2026-2** · Universidad Icesi

## Integrantes

| Nombre | Código |
| --- | --- |
| Emmanuel Muñoz | A00410447 |
| María Camila Córdoba | A00412038 |
| María Alejandra Enriquez | A00412040 |

## Descripción del proyecto

Selva Alegre es un restaurante de comida típica colombiana, de un solo local y con servicio en mesa, que hoy maneja todo en papel: comandas, cuentas, compras e inventario. Esto causa pérdida de comandas, errores al calcular la cuenta y ninguna visibilidad sobre qué se vende, qué se gasta ni cuándo hay que reabastecer.

Este proyecto diseña e implementa la base de datos relacional (Oracle) del **módulo de inventario y proveedores**, que permite:

- Registrar proveedores, insumos y compras.
- Llevar el inventario de cada insumo con su stock mínimo y su stock actual.
- Registrar los movimientos de entrada y salida de inventario y quién los gestionó.
- Relacionar los platos con los insumos que consumen (ficha técnica) y con los pedidos del restaurante.

### Reportes de interés

- Platos más vendidos en un período (top N).
- Ventas totales agrupadas por día, semana o mes.
- Desempeño por mesero: pedidos atendidos y valor vendido.
- Nivel de inventario actual e insumos por debajo del stock mínimo.
- Historial de movimientos (entradas y salidas) de un insumo en un rango de fechas.
- Costo de insumos por plato vendido, para evaluar la rentabilidad.
- Valor total del inventario disponible.

## Estructura del repositorio

### `doc/`: documentación

- [Descripción del caso](doc/caso/Entrega1_enunciado_unificado.docx) (enunciado unificado del caso)
- [Caso de estudio, Entrega 0](doc/caso/Entrega0_Inventario_Proveedores.docx)
- [Dependencias funcionales](doc/caso/Dependencias%20Funcionales.md)
- [Verificación de join sin pérdida](doc/lossless_join_verifiaction.pdf)
- [Acuerdos del equipo](doc/Acuerdos_del_equipo.docx)
- [Riesgos del uso de IAG](doc/Riesgos_uso_IAG_Selva_Alegre.docx)
- Bitácoras de reuniones: [Acta No. 3](doc/bitacoras/Acta%20de%20Reunion%20No%203%20Bitacora.docx)
- Actas de reuniones en clase: [Acta No. 2](doc/actas%20en%20clase/Acta%20de%20Reunion%20No%202.docx)

### `model/`: modelos de datos

| Modelo | Imagen (PDF) | Fuentes (zip del `.dmd`) |
| --- | --- | --- |
| Modelo entidad-relación (MER) | [merProyectoActualizado.pdf](model/merPDF/merProyectoActualizado.pdf) | [modeloMER2.0proyectoRestaurante.zip](model/merZIP/modeloMER2.0proyectoRestaurante.zip) |
| Modelo relacional (3FN) | [modeloRelacionalProyecto.pdf](model/mrPDF/modeloRelacionalProyecto.pdf) | [modeloMR1.0proyectoRestaurante.zip](model/mrZIP/modeloMR1.0proyectoRestaurante.zip) |

### `src/`: scripts SQL y PL/SQL

| Script | Contenido |
| --- | --- |
| [DDL](src/DDL.sql) | Creación de las tablas, llaves y restricciones |
| [DML](src/DML.sql) | Datos de prueba para generar los reportes |
| [Consultas](src/consultas.sql) | Las 12 consultas (DQL) de los reportes, cada una con su descripción |
| [PL/SQL](src/PLSQL.sql) | Función `costo_insumos_plato`, procedimiento `cambiar_estado_pedido` y trigger `trg_movements_tipo_origen` |

## Cómo ejecutar los scripts

Los scripts están escritos para **Oracle**. Para evitar errores de dependencias, se ejecutan en este orden:

1. `DDL.sql`: crea las tablas. La primera vez, los `DROP TABLE` del inicio muestran errores ORA-00942 que se pueden ignorar, porque las tablas aún no existen.
2. `DML.sql`: inserta los datos de prueba.
3. `PLSQL.sql`: crea la función, el procedimiento y el trigger.
4. `consultas.sql`: ejecuta los reportes.

## Entregas del proyecto

| Entrega | Contenido |
| --- | --- |
| Entrega 0 | Caso de estudio, requerimientos y acuerdos del equipo |
| Entrega 1 | Modelo entidad-relación (MER) |
| Entrega 2 | Modelo relacional en tercera forma normal |
| Entrega 3 | Scripts DDL, DML, consultas y PL/SQL, y documento de riesgos de IAG |
