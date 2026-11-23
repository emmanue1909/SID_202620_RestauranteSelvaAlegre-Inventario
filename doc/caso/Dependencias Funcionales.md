# Simples

id_order $\rightarrow$ hour, status, date, total_price

id_order_detail $\rightarrow$ plate_quantity

id_plate $\rightarrow$ name, price, description

id_plate_details $\rightarrow$ quantity, restaurant_price, unit_of_measurement

id_employee $\rightarrow$ name, email, phone, salary, zone

nit $\rightarrow$ name, phone, email

id_ingredient $\rightarrow$ name, unit_of_measurement, minimum_stock, current_stock

id_purchase_supplier  $\rightarrow$ date, total_price

id_purchase_supplier_detail $\rightarrow$ quantity, price, unit_of_measurement

id_movement $\rightarrow$ date, type

# Reglas del negocio

id_order_detail $\rightarrow$ id_order 

id_order_detail $\rightarrow$ id_plate

id_order $\rightarrow$ id_employee

id_purchase_supplier $\rightarrow$ nit

id_plate_details $\rightarrow$ id_ingredient

id_purchase_supplier_detail $\rightarrow$ id_purchase_supplier

id_purchase_supplier $\rightarrow$ id_movement

id_order $\rightarrow$ id_movement

id_movement $\rightarrow$ id_employee

PENDiENTES:

REVISAR HASTA 3FN (2FN Y 1FN CHECK)
REVISAR LOSLESSJOIN Y CONSEVACION DE DEPENDENCIAS