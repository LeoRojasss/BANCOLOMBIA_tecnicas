ALTER TABLE join_obligaciones_productos ADD COLUMN valor_final REAL;  -- Agregar la columna

UPDATE join_obligaciones_productos
SET valor_final = valor_inicial * COALESCE(tasa_efectiva, 0);  -- Calcular el valor final


-- verificar que el valor_final se haya calculado correctamente

SELECT num_documento, id_producto, valor_inicial, tasa_efectiva, valor_final
FROM join_obligaciones_productos