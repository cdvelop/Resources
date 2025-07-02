# Preguntas para la entrevista técnica:

## Enfoque en SQL Avanzado:

* Consultas complejas:

1. Describa cómo realizaría una consulta para identificar las mesas de votación con mayor número de votos nulos, agrupando los resultados por región:

   Para realizar esta consulta, podríamos utilizar la siguiente estructura SQL:

```sql
   SELECT 
       r.nombre_region,
       m.id_mesa,
       COUNT(*) as votos_nulos
   FROM 
       votos v
   JOIN 
       mesas m ON v.id_mesa = m.id_mesa
   JOIN 
       regiones r ON m.id_region = r.id_region
   WHERE 
       v.tipo_voto = 'nulo'
   GROUP BY 
       r.nombre_region, m.id_mesa
   ORDER BY 
       r.nombre_region, votos_nulos DESC
```

   Esta consulta:
   - Cuenta los votos nulos por mesa y región
   - Utiliza JOINs para relacionar las tablas de votos, mesas y regiones
   - Agrupa los resultados por región y mesa
   - Ordena los resultados por región y número de votos nulos en orden descendente

2. Cómo se realizaría una consulta para identificar tendencias de voto en base a la edad de los electores y su ubicación geográfica:

   - Para esta consulta, podríamos utilizar la siguiente estructura SQL:

 ```sql  
   SELECT 
       r.nombre_region,
       CASE 
           WHEN e.edad BETWEEN 18 AND 30 THEN '18-30'
           WHEN e.edad BETWEEN 31 AND 50 THEN '31-50'
           WHEN e.edad BETWEEN 51 AND 70 THEN '51-70'
           ELSE '70+'
       END AS grupo_edad,
       c.nombre_candidato,
       COUNT(*) as total_votos
   FROM 
       votos v
   JOIN 
       electores e ON v.id_elector = e.id_elector
   JOIN 
       mesas m ON v.id_mesa = m.id_mesa
   JOIN 
       regiones r ON m.id_region = r.id_region
   JOIN 
       candidatos c ON v.id_candidato = c.id_candidato
   WHERE 
       v.tipo_voto = 'válido'
   GROUP BY 
       r.nombre_region, 
       grupo_edad, 
       c.nombre_candidato
   ORDER BY 
       r.nombre_region, 
       grupo_edad, 
       total_votos DESC
   ```

   Esta consulta:
   - Agrupa a los electores en rangos de edad
   - Cuenta los votos válidos por región, grupo de edad y candidato
   - Utiliza JOINs para relacionar las tablas de votos, electores, mesas, regiones y candidatos
   - Ordena los resultados por región, grupo de edad y total de votos en orden descendente

Estas consultas proporcionarán una visión detallada de los patrones de votación, permitiendo identificar tanto las mesas con mayor número de votos nulos como las tendencias de voto basadas en la edad y ubicación geográfica de los electores.


3. Para filtrar los datos por un rango de fechas específico, se puede modificar la consulta anterior agregando una cláusula WHERE adicional. Asumiendo que existe una columna fecha_voto en la tabla votos, la consulta quedaría así:

```sql
SELECT 
    r.nombre_region,
    CASE 
        WHEN e.edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN e.edad BETWEEN 31 AND 50 THEN '31-50'
        WHEN e.edad BETWEEN 51 AND 70 THEN '51-70'
        ELSE '70+'
    END AS grupo_edad,
    c.nombre_candidato,
    COUNT(*) as total_votos
FROM 
    votos v
JOIN 
    electores e ON v.id_elector = e.id_elector
JOIN 
    mesas m ON v.id_mesa = m.id_mesa
JOIN 
    regiones r ON m.id_region = r.id_region
JOIN 
    candidatos c ON v.id_candidato = c.id_candidato
WHERE 
    v.tipo_voto = 'válido'
    AND v.fecha_voto BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY 
    r.nombre_region, 
    grupo_edad, 
    c.nombre_candidato
ORDER BY 
    r.nombre_region, 
    grupo_edad, 
    total_votos DESC
```

Esta modificación:
- Agrega una condición AND v.fecha_voto BETWEEN '2023-01-01' AND '2023-12-31' en la cláusula WHERE
- Filtra los votos para incluir solo aquellos realizados entre el 1 de enero y el 31 de diciembre de 2023
- Mantiene la estructura y funcionalidad del resto de la consulta

Puedes ajustar las fechas '2023-01-01' y '2023-12-31' según el rango específico que necesites analizar.
