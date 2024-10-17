SELECT 
    num_documento,               -- O radicado, dependiendo de cómo identificas a los clientes
    SUM(valor_final) AS total_valor_final
FROM 
    join_obligaciones_productos
GROUP BY 
    num_documento;               -- Agrupa por cliente
    
    -- me daba ansiedad porque no habian tantos valores ajajaja
    SELECT num_documento, COUNT(*) AS count 
FROM join_obligaciones_productos 
GROUP BY num_documento 
HAVING COUNT(*) > 1;  

