CREATE TABLE join_obligaciones_productos AS
SELECT 
    oc.*,
    tp.tasa_cartera,
    tp.tasa_operacion_especifica,
    tp.tasa_hipotecario,
    tp.tasa_leasing,
    tp.tasa_sufi,
    tp.tasa_factoring,
    tp.tasa_tarjeta
FROM 
    obligaciones_clientes oc
LEFT JOIN 
    tasas_productos tp 
ON 
    (oc.id_producto LIKE '%' || tp.segmento || '%' OR 
     oc.id_producto LIKE '%' || tp.cod_subsegmento || '%');
--------------------------------------------------------------
-- Muestra los primeros 10 registros
SELECT * FROM join_obligaciones_productos LIMIT 10;  
