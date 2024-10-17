INSERT INTO join_obligaciones_productos (
    radicado,
    num_documento,
    cod_segm_tasa,
    cod_subsegm_tasa,
    cal_interna_tasa,
    id_producto,
    tipo_id_producto,
    valor_inicial,
    fecha_desembolso,
    plazo,
    cod_periodicidad,
    periodicidad,
    tasa_cartera,
    tasa_operacion_especifica,
    tasa_hipotecario,
    tasa_leasing,
    tasa_sufi,
    tasa_factoring,
    tasa_tarjeta
)
SELECT 
    oc.radicado,
    oc.num_documento,
    oc.cod_segm_tasa,
    oc.cod_subsegm_tasa,
    oc.cal_interna_tasa,
    oc.id_producto,
    oc.tipo_id_producto,
    oc.valor_inicial,
    oc.fecha_desembolso,
    oc.plazo,
    oc.cod_periodicidad,
    oc.periodicidad,
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
     oc.id_producto LIKE '%' || tp.cod_subsegmento || '%')
--WHERE 
   -- oc.tipo_id_producto = 'cod_plan - producto';

SELECT 
    oc.radicado,
    oc.num_documento,
    oc.id_producto,
    tp.tasa_cartera,
    tp.tasa_operacion_especifica
FROM 
    obligaciones_clientes oc
LEFT JOIN 
    tasas_productos tp 
ON 
    (oc.id_producto LIKE '%' || tp.segmento || '%' OR 
     oc.id_producto LIKE '%' || tp.cod_subsegmento || '%')
LIMIT 10;  


