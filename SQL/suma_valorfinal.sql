SELECT 
    num_documento,             
    SUM(valor_final) AS total_valor_final
FROM 
    resultados_finales
WHERE 
    valor_final IS NOT NULL       
GROUP BY 
    num_documento;              