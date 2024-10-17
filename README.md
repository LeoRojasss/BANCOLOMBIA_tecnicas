# Análisis de Obligaciones y Tasas SQL

## Introducción

Este proyecto tiene como objetivo analizar las obligaciones de los clientes y calcular las tasas efectivas asociadas a estas obligaciones. Se utilizan datos provenientes de dos archivos: `obligaciones_clientes.xlsx` y `tasas_productos.xlsx`. El análisis se realiza utilizando SQL, y los resultados finales se presentan en un formato estructurado.

## Archivos Utilizados

- **obligaciones_clientes.xlsx**: Contiene información sobre las obligaciones de los clientes, incluyendo detalles como el valor, producto, plazo, y otros datos relevantes.
  
- **tasas_productos.xlsx**: Contiene las tasas de interés correspondientes a cada producto, que se utilizarán para calcular las tasas efectivas.

## Metodología

### Paso 1: Agregar Tasa Correspondiente

Se realiza un `JOIN` entre las tablas de obligaciones y tasas para agregar la tasa correspondiente a cada obligación del cliente.

```sql
CREATE TABLE join_obligaciones_productos AS
SELECT 
    oc.*,
    tp.tasa_cartera,
    ...
FROM 
    obligaciones_clientes oc
LEFT JOIN 
    tasas_productos tp 
ON 
    (oc.id_producto LIKE '%' || tp.segmento || '%' OR 
     oc.id_producto LIKE '%' || tp.cod_subsegmento || '%');
```
### Paso 2: Calcular Tasa Efectiva

Se calcula la tasa efectiva utilizando la siguiente fórmula:

\[ te = (1 + t)^{\frac{1}{n}} - 1 \]

Donde:
- \(te\): Tasa efectiva
- \(t\): Tasa (por ejemplo, `tasa_cartera`)
- \(n\): \(n = \frac{12}{\text{periodicidad}}\)

#### SQL Utilizado

```sql
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
```
### Paso 3: Calcular Valor Final

En este paso, se calcula el valor final multiplicando la tasa efectiva por el valor inicial. Este cálculo se realiza para cada obligación de cliente.

#### SQL Utilizado

1. **Agregar la columna `valor_final`** a la tabla `join_obligaciones_productos`:

```sql
ALTER TABLE join_obligaciones_productos ADD COLUMN valor_final REAL;  -- Agregar la columna para el valor final
```
### Paso 4: Sumar Valor Final por Cliente

En este paso, se suma el valor final de todas las obligaciones por cliente. Esto permite obtener un total de las obligaciones de cada cliente en la tabla `join_obligaciones_productos`.

#### SQL Utilizado

```sql
SELECT 
    num_documento,               
    SUM(valor_final) AS total_valor_final
FROM 
    join_obligaciones_productos
GROUP BY 
    num_documento;       -- Agrupa por cliente
```

# Análisis de Obligaciones y Tasas PYTHON

El proyecto se divide en los siguientes pasos principales:

1. **Cargar archivos de datos**: Se cargan dos archivos XLSX: `obligaciones_clientes.xlsx` y `tasas_productos.xlsx`, que contienen la información de las obligaciones de los clientes y las tasas correspondientes para cada tipo de producto.
   
2. **Procesamiento de la columna `id_producto`**: Se extrae el nombre del producto desde el campo `id_producto` para facilitar el mapeo con la tabla de tasas.

3. **Asignación de tasas**: Las tasas de interés se asignan a cada producto utilizando una función de mapeo.

4. **Cálculo de tasa efectiva**: La tasa nominal se convierte en una tasa efectiva usando la fórmula planteada

   Donde \( t \) es la tasa nominal y \( n \) depende de la periodicidad del pago.

5. **Cálculo del valor final**: Se multiplica la tasa efectiva por el valor inicial de cada obligación para obtener el valor final.

6. **Sumar el valor final por cliente**: Finalmente, se suma el valor final de todas las obligaciones por cliente, agrupando por el número de documento del cliente (`num_documento`).

## Archivos

- `obligaciones_clientes.xlsx`: Contiene la información de las obligaciones de los clientes.
- `tasas_productos.xlsx`: Contiene la tasa de interés correspondiente a cada tipo de producto.
- `resultado_obligaciones.xlsx`: Archivo generado con los valores finales calculados para cada cliente.
