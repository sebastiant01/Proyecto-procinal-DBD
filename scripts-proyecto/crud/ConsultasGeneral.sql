-- =============================================================================
-- CONSULTAS DE ANÁLISIS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Géneros con más de una proyección programada
-- Álgebra relacional:
-- τ_(total DESC) (σ_(total > 1) (γ_(genero; COUNT(id_proyeccion)→total, AVG(duracion)→prom) 
--   (σ_(genero≠NULL)(Pelicula) ⋈ Proyeccion)))
-- Explicación: Se hace un INNER JOIN (⋈) entre Pelicula y Proyeccion para obtener
-- solo películas que tienen proyecciones. Se filtra (σ) géneros no nulos, se agrupa (γ)
-- por género contando proyecciones y promediando duración, se seleccionan (σ) los
-- que tienen más de 1 proyección (HAVING), y se ordena (τ) descendentemente.
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    P.genero,
    COUNT(PR.id_proyeccion)  AS total_proyecciones,
    AVG(P.duracion)          AS duracion_promedio_min
FROM Pelicula P
    INNER JOIN Proyeccion PR ON PR.id_pelicula = P.id_pelicula
WHERE P.genero IS NOT NULL
GROUP BY P.genero
HAVING COUNT(PR.id_proyeccion) > 1
ORDER BY total_proyecciones DESC;
GO

-- -----------------------------------------------------------------------------
-- Directores con más de una película dirigida
-- Álgebra relacional:
-- τ_(total DESC, nombre ASC) (σ_(total > 1) (γ_(nombre, edad, pais; COUNT(id_pelicula)→total) 
--   (σ_(pais≠NULL)(Director) ⋈_(id_director) Pelicula)))
-- Explicación: Se hace un INNER JOIN (⋈) natural entre Director y Pelicula usando
-- id_director (FK en Pelicula). El WHERE filtra (σ) directores con país conocido.
-- Se agrupa (γ) por nombre, edad y país contando películas, se filtran (σ HAVING)
-- los que dirigieron más de 1, y se ordena (τ) por cantidad desc y nombre asc.
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    D.nombre                 AS director,
    D.edad,
    D.pais_procedencia,
    COUNT(P.id_pelicula)     AS peliculas_dirigidas
FROM Director D
    INNER JOIN Pelicula P ON P.id_director = D.id_director
WHERE D.pais_procedencia IS NOT NULL
GROUP BY D.nombre, D.edad, D.pais_procedencia
HAVING COUNT(P.id_pelicula) > 1
ORDER BY peliculas_dirigidas DESC, D.nombre ASC;
GO

-- -----------------------------------------------------------------------------
-- Capacidad promedio de salas 2D por ciudad (promedio > 115)
-- Álgebra relacional:
-- T1 ← Ciudad ⋈ PuntoVenta ⋈ Sala ⋈ Sala2D
-- T2 ← γ_(C.nombre; COUNT(id_sala)→total, AVG(capacidad)→prom) (T1)
-- Resultado ← τ_(prom DESC) (σ_(prom > 115) (T2))
-- Explicación: Se encadenan 4 INNER JOINs (⋈) para conectar Ciudad→PuntoVenta→
-- Sala→Sala2D. Se agrupa (γ) por ciudad, se cuentan salas y se promedian capacidades.
-- Se filtran (σ HAVING) ciudades con promedio > 115 y se ordena (τ) descendentemente.
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    C.nombre            AS ciudad,
    COUNT(S2.id_sala)   AS total_salas_2D,
    AVG(S2.capacidad)   AS capacidad_promedio
FROM Ciudad C
    INNER JOIN PuntoVenta PV ON PV.id_ciudad     = C.id_ciudad
    INNER JOIN Sala S        ON S.id_punto_venta = PV.id_punto_venta
    INNER JOIN Sala2D S2     ON S2.id_sala       = S.id_sala
GROUP BY C.nombre
HAVING AVG(S2.capacidad) > 115
ORDER BY capacidad_promedio DESC;
GO

-- -----------------------------------------------------------------------------
-- Puntos de venta con costo VIP promedio mayor a $78.000
-- Álgebra relacional:
-- T1 ← σ_(costo>0) (PuntoVenta ⋈ Ciudad ⋈ Sala ⋈ SalaVIP)
-- T2 ← γ_(PV.nombre, C.nombre; COUNT→salas, AVG(costo)→prom) (T1)
-- Resultado ← τ_(prom DESC) (σ_(prom > 78000) (T2))
-- Explicación: Se conectan PuntoVenta, Ciudad, Sala y SalaVIP mediante INNER JOINs (⋈).
-- El WHERE filtra (σ) costos > 0. Se agrupa (γ) por punto de venta y ciudad,
-- se filtran (σ HAVING) los que superan $78.000 promedio y se ordena (τ) por costo desc.
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    PV.nombre                AS punto_venta,
    C.nombre                 AS ciudad,
    COUNT(SV.id_sala)        AS salas_vip,
    AVG(SV.costo_por_hora)   AS costo_promedio_hora
FROM PuntoVenta PV
    INNER JOIN Ciudad C    ON C.id_ciudad      = PV.id_ciudad
    INNER JOIN Sala S      ON S.id_punto_venta = PV.id_punto_venta
    INNER JOIN SalaVIP SV  ON SV.id_sala       = S.id_sala
WHERE SV.costo_por_hora > 0
GROUP BY PV.nombre, C.nombre
HAVING AVG(SV.costo_por_hora) > 78000
ORDER BY costo_promedio_hora DESC;
GO

-- -----------------------------------------------------------------------------
-- Administradores con sueldo mayor al promedio general
-- Álgebra relacional:
-- Prom ← γ_(AVG(sueldo)→media) (Administrador)
-- T1 ← Empleado ⋈ Administrador ⋈ PuntoVenta
-- T2 ← σ_(sueldo > Prom.media) (T1)
-- Resultado ← τ_(sueldo DESC) (π_(nombre, PV.nombre, sueldo, numero_hijos) (T2))
-- Explicación: Primero se calcula el promedio general de sueldos (subconsulta).
-- Se hace INNER JOIN (⋈) entre Empleado, Administrador y PuntoVenta.
-- El WHERE filtra (σ) administradores cuyo sueldo supera el promedio.
-- Se proyectan (π) los campos relevantes y se ordena (τ) por sueldo desc.
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    E.nombre        AS empleado,
    PV.nombre       AS punto_venta,
    A.sueldo,
    A.numero_hijos
FROM Empleado E
    INNER JOIN Administrador A ON A.id_empleado     = E.id_empleado
    INNER JOIN PuntoVenta PV   ON PV.id_punto_venta = E.id_punto_venta
WHERE A.sueldo > (SELECT AVG(sueldo) FROM Administrador)
ORDER BY A.sueldo DESC;
GO

-- -----------------------------------------------------------------------------
-- Géneros con más de una proyección programada (con ROLLUP)
-- Álgebra relacional extendida:
-- τ_(genero, total DESC) (γ_ROLLUP(genero; COUNT(id_proyeccion)→total, AVG(duracion)→prom)
--   (σ_(genero≠NULL)(Pelicula) ⋈ Proyeccion))
-- Explicación: Igual que la consulta original, pero GROUP BY ROLLUP(genero) agrega
-- una fila extra con el agregado global (genero = NULL → gran total). Se usa
-- GROUPING(genero) para distinguir esa fila de géneros realmente nulos, y se
-- reemplaza con la etiqueta 'TOTAL GENERAL'. El HAVING filtra filas de detalle
-- con total > 1, pero se conserva la fila de gran total con OR GROUPING()=1.
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    CASE
        WHEN GROUPING(P.genero) = 1 THEN 'TOTAL GENERAL'
        ELSE P.genero
    END                              AS genero,
    COUNT(PR.id_proyeccion)          AS total_proyecciones,
    AVG(P.duracion)                  AS duracion_promedio_min
FROM Pelicula P
    INNER JOIN Proyeccion PR ON PR.id_pelicula = P.id_pelicula
WHERE P.genero IS NOT NULL
GROUP BY ROLLUP(P.genero)
HAVING COUNT(PR.id_proyeccion) > 1
    OR GROUPING(P.genero) = 1
ORDER BY GROUPING(P.genero) ASC, total_proyecciones DESC;

-- -----------------------------------------------------------------------------
-- Puntos de venta con costo VIP promedio (con CUBE)
-- Álgebra relacional extendida:
-- γ_CUBE(PV.nombre, C.nombre; COUNT→salas, AVG(costo)→prom)
--   (σ_(costo>0) (PuntoVenta ⋈ Ciudad ⋈ Sala ⋈ SalaVIP))
-- Explicación: CUBE(PV.nombre, C.nombre) genera TODAS las combinaciones posibles
-- de agrupación: (punto_venta, ciudad), solo (ciudad), solo (punto_venta),
-- y el gran total. GROUPING() identifica qué columna está siendo subtotalizada
-- en cada fila para etiquetarla correctamente.
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    CASE
        WHEN GROUPING(PV.nombre) = 1 THEN 'Todos los puntos'
        ELSE PV.nombre
    END                         AS punto_venta,
    CASE
        WHEN GROUPING(C.nombre) = 1 THEN 'Todas las ciudades'
        ELSE C.nombre
    END                         AS ciudad,
    COUNT(SV.id_sala)           AS salas_vip,
    AVG(SV.costo_por_hora)      AS costo_promedio_hora,
    GROUPING(PV.nombre)         AS es_subtotal_punto,
    GROUPING(C.nombre)          AS es_subtotal_ciudad
FROM PuntoVenta PV
    INNER JOIN Ciudad C    ON C.id_ciudad      = PV.id_ciudad
    INNER JOIN Sala S      ON S.id_punto_venta = PV.id_punto_venta
    INNER JOIN SalaVIP SV  ON SV.id_sala       = S.id_sala
WHERE SV.costo_por_hora > 0
GROUP BY CUBE(PV.nombre, C.nombre)
HAVING AVG(SV.costo_por_hora) > 78000
    OR (GROUPING(PV.nombre) = 1 OR GROUPING(C.nombre) = 1)
ORDER BY
    GROUPING(C.nombre) ASC,
    GROUPING(PV.nombre) ASC,
    costo_promedio_hora DESC;

-- =============================================================================
-- CONSULTAS CON DIFERENTES TIPOS DE JOIN
-- =============================================================================

-- -----------------------------------------------------------------------------
-- INNER JOIN: Películas y sus actores protagonistas
-- Álgebra relacional:
-- π_(P.titulo, P.genero, A.nombre, A.edad)
--     (Pelicula P ⋈_(P.id_pelicula=PR.id_pelicula) Protagoniza PR
--         ⋈_(PR.id_actor=A.id_actor) Actor A)
-- Explicación: El INNER JOIN (⋈) combina solo las tuplas que tienen coincidencia
-- en ambas tablas. Solo aparecen películas que tienen actores asignados en
-- Protagoniza, y solo actores que aparecen en alguna película. Las películas
-- sin actor (ej. Requiem, Beetlejuice) y actores sin película (ej. Tom Hanks)
-- quedan excluidos. Se proyectan (π) título, género, nombre y edad del actor.
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    P.titulo        AS pelicula,
    P.genero,
    A.nombre        AS actor_protagonista,
    A.edad          AS edad_actor
FROM Pelicula P
    INNER JOIN Protagoniza PR ON PR.id_pelicula = P.id_pelicula
    INNER JOIN Actor A        ON A.id_actor     = PR.id_actor
ORDER BY P.titulo;
GO

-- -----------------------------------------------------------------------------
-- LEFT JOIN: Todas las ciudades, aunque no tengan sede Procinal
-- Álgebra relacional:
-- π_(C.nombre, C.zona_geografica, PV.nombre, PV.direccion)
--     (Ciudad C ⟕_(C.id_ciudad=PV.id_ciudad) PuntoVenta PV)
-- Explicación: El LEFT JOIN (⟕) preserva TODAS las tuplas de la tabla izquierda
-- (Ciudad), incluso si no tienen coincidencia en PuntoVenta. Las ciudades sin
-- punto de venta (Riohacha, Leticia, Sincelejo, Valledupar, Popayán, Tunja)
-- aparecen con NULL en las columnas de PuntoVenta. Esto permite identificar
-- ciudades donde Procinal aún no tiene presencia.
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    C.nombre            AS ciudad,
    C.zona_geografica,
    PV.nombre           AS punto_venta,
    PV.direccion
FROM Ciudad C
    LEFT JOIN PuntoVenta PV ON PV.id_ciudad = C.id_ciudad
ORDER BY C.nombre;
GO

-- -----------------------------------------------------------------------------
-- RIGHT JOIN: Todas las salas y su empleado encargado (si tiene)
-- Álgebra relacional:
-- π_(E.nombre, E.cargo, S.id_sala, S.numero_sala, PV.nombre, C.nombre)
--     (Empleado E ⟖_(E.id_empleado=S.id_empleado) Sala S
--         ⋈ PuntoVenta PV ⋈ Ciudad C)
-- Explicación: El RIGHT JOIN (⟖) preserva TODAS las tuplas de la tabla derecha
-- (Sala), incluso salas sin empleado asignado. Las 20 salas VIP (id_sala 41-60)
-- tienen id_empleado = NULL, por lo que aparecen con NULL en las columnas de
-- Empleado. Las salas 2D y 3D sí muestran su empleado encargado. Los INNER JOINs
-- posteriores traen el punto de venta y la ciudad de cada sala.
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    E.nombre                AS empleado_encargado,
    E.cargo,
    S.id_sala,
    S.numero_sala,
    PV.nombre               AS punto_venta,
    C.nombre                AS ciudad
FROM Empleado E
    RIGHT JOIN Sala S        ON S.id_empleado     = E.id_empleado
    INNER JOIN PuntoVenta PV ON PV.id_punto_venta = S.id_punto_venta
    INNER JOIN Ciudad C      ON C.id_ciudad       = PV.id_ciudad
ORDER BY PV.nombre, S.numero_sala;
GO

-- -----------------------------------------------------------------------------
-- FULL JOIN: Todas las películas y todas las proyecciones
-- Álgebra relacional:
-- π_(P.titulo, P.genero, PR.id_proyeccion, PR.fecha_proyeccion)
--     (Pelicula P ⟗_(P.id_pelicula=PR.id_pelicula) Proyeccion PR)
-- Explicación: El FULL JOIN (⟗) preserva TODAS las tuplas de AMBAS tablas.
-- Las películas sin proyección (Requiem for a Dream, Beetlejuice) aparecen
-- con NULL en las columnas de Proyeccion. Si hubiera proyecciones huérfanas
-- (sin película válida), aparecerían con NULL en las columnas de Pelicula.
-- Esto permite detectar tanto películas no programadas como proyecciones
-- sin película asociada.
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    P.titulo            AS pelicula,
    P.genero,
    PR.id_proyeccion,
    PR.fecha_proyeccion
FROM Pelicula P
    FULL JOIN Proyeccion PR ON PR.id_pelicula = P.id_pelicula
ORDER BY P.titulo, PR.fecha_proyeccion;
GO

-- -----------------------------------------------------------------------------
-- CROSS JOIN: Combinación total entre géneros y zonas geográficas
-- Álgebra relacional:
-- G ← π_(genero) (σ_(genero≠NULL) (Pelicula))
-- Z ← π_(zona_geografica) (σ_(zona_geografica≠NULL) (Ciudad))
-- Resultado ← τ_(genero, zona_geografica) (G × Z)
-- Explicación: El CROSS JOIN (×) genera el producto cartesiano entre los géneros
-- distintos de Pelicula y las zonas geográficas distintas de Ciudad. Cada género
-- se combina con cada zona, produciendo todas las combinaciones posibles.
-- Con 9 géneros y 4 zonas se generan 9×4 = 36 filas. Útil para análisis de
-- cobertura: qué combinaciones género-zona existen o podrían existir.
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    G.genero,
    Z.zona_geografica,
    CONCAT(G.genero, ' - ', Z.zona_geografica) AS combinacion
FROM
    (SELECT DISTINCT genero
     FROM Pelicula
     WHERE genero IS NOT NULL) G
    CROSS JOIN
    (SELECT DISTINCT zona_geografica
     FROM Ciudad
     WHERE zona_geografica IS NOT NULL) Z
ORDER BY G.genero, Z.zona_geografica;