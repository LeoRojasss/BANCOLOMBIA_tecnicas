ALTER TABLE join_obligaciones_productos ADD COLUMN tasa_efectiva REAL;  -- Agregar la columna

UPDATE join_obligaciones_productos
SET tasa_efectiva = 
    CASE 
        WHEN cod_periodicidad = 1 THEN COALESCE(tasa_cartera, 0)  -- Mensual, tasa efectiva es la misma
        WHEN cod_periodicidad = 2 THEN (POWER(1 + COALESCE(tasa_cartera, 0), 0.5) - 1)  -- Bimestral
        WHEN cod_periodicidad = 3 THEN (POWER(1 + COALESCE(tasa_cartera, 0), 1.0/3) - 1)  -- Trimestral
        WHEN cod_periodicidad = 6 THEN (POWER(1 + COALESCE(tasa_cartera, 0), 1.0/6) - 1)  -- Semestral
        WHEN cod_periodicidad = 12 THEN (POWER(1 + COALESCE(tasa_cartera, 0), 1.0/12) - 1)  -- Anual
        ELSE NULL
    END;
-----------------
--verificar que la columna tasa_efectiva se haya calculado correctamente
SELECT num_documento, id_producto, tasa_cartera, tasa_efectiva, periodicidad
FROM join_obligaciones_productos

