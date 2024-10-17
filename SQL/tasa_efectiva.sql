SELECT 
    *,
    CASE 
        WHEN cod_periodicidad = 1 THEN (POWER(1 + tasa_cartera, 1) - 1)
        WHEN cod_periodicidad = 2 THEN (POWER(1 + tasa_cartera, 0.5) - 1)
        WHEN cod_periodicidad = 3 THEN (POWER(1 + tasa_cartera, 1/3) - 1)
        WHEN cod_periodicidad = 6 THEN (POWER(1 + tasa_cartera, 1/6) - 1)
        WHEN cod_periodicidad = 12 THEN (POWER(1 + tasa_cartera, 1/12) - 1)
        ELSE NULL
    END AS tasa_efectiva
FROM 
    join_obligaciones_productos;
