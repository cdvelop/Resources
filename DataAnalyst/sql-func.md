# Funciones SQL:

## Funciones de agregación en análisis de datos electorales

Las funciones de agregación en SQL son herramientas poderosas para el análisis de datos electorales. Aquí se explica cómo se pueden utilizar en un escenario real:

1. COUNT: Para contar el número total de votos

```sql
SELECT COUNT(*) AS total_votos FROM votos;
```


2. SUM: Para sumar los votos de un candidato o partido específico

```sql
SELECT partido, SUM(votos) AS votos_totales
FROM resultados
GROUP BY partido;
```


3. AVG: Para calcular el promedio de participación por distrito

```sql
SELECT distrito, AVG(participacion) AS participacion_promedio
FROM estadisticas
GROUP BY distrito;
```

4. MAX y MIN: Para identificar los distritos con mayor y menor participación

```sql
SELECT 
    MAX(participacion) AS max_participacion,
    MIN(participacion) AS min_participacion
FROM estadisticas;
```

5. GROUP BY con múltiples funciones: Para un análisis más detallado por región

```sql
SELECT 
    region,
    COUNT(DISTINCT distrito) AS num_distritos,
    SUM(votos_validos) AS total_votos_validos,
    AVG(participacion) AS participacion_promedio
FROM resultados
GROUP BY region;
```

6. HAVING: Para filtrar resultados agregados

```sql
SELECT partido, COUNT(*) AS distritos_ganados
FROM resultados
WHERE posicion = 1
GROUP BY partido
HAVING COUNT(*) > 5;
```

Estas consultas permiten analizar patrones de votación, participación electoral y distribución de votos, proporcionando insights valiosos para el análisis político y electoral.


7. Funciones de ventana: Para análisis comparativo y ranking

Las funciones de ventana como ROW_NUMBER, RANK y DENSE_RANK son herramientas poderosas en el análisis de datos electorales, permitiendo realizar comparaciones y rankings dentro de grupos específicos. Aquí se describe su utilidad con ejemplos:

```sql
-- ROW_NUMBER: Para asignar un número único a cada fila dentro de una partición

SELECT 
    distrito,
    partido,
    votos,
    ROW_NUMBER() OVER (PARTITION BY distrito ORDER BY votos DESC) AS posicion
FROM resultados;

-- RANK: Para asignar un ranking con saltos en caso de empates
SELECT 
    partido,
    votos,
    RANK() OVER (ORDER BY votos DESC) AS ranking_nacional
FROM (
    SELECT partido, SUM(votos) AS votos
    FROM resultados
    GROUP BY partido
) AS votos_totales;

-- DENSE_RANK: Para asignar un ranking sin saltos en caso de empates
SELECT 
    region,
    partido,
    participacion,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY participacion DESC) AS ranking_regional
FROM resultados;
```

Estas funciones de ventana permiten:

1. Asignar posiciones a candidatos dentro de cada distrito.
2. Crear rankings nacionales de partidos por total de votos.
3. Generar rankings regionales de participación electoral.

Su uso facilita la identificación de patrones, comparaciones entre diferentes niveles geográficos y el análisis de desempeño electoral de manera más detallada y contextualizada.
