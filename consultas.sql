<<<<<<< HEAD
--SECCIÓN 3: CONSULTAS Y ANÁLISIS 

USE Procinal;
GO

--  CONSULTA 1
--  ¿Cuántas funciones tiene cada película y en cuántas
--  ciudades se está proyectando? Solo las que tienen > 1 función.

--  Álgebra relacional:
--  o funciones>1 ( y titulo,genero; COUNT, COUNT DISTINCT ( PELICULA x PROYECCION x SALA x PUNTOVENTA x CIUDAD ) )

SELECT
    p.titulo,
    p.genero,
    p.duracion                          AS duracion_min,
    COUNT(pr.id_proyeccion)             AS total_funciones,
    COUNT(DISTINCT c.id_ciudad)         AS ciudades_en_cartelera
FROM dbo.PELICULA   p
JOIN dbo.PROYECCION pr ON p.id_pelicula    = pr.id_pelicula
JOIN dbo.SALA       s  ON pr.id_sala       = s.id_sala
JOIN dbo.PUNTOVENTA pv ON s.id_punto_venta = pv.id_punto_venta
JOIN dbo.CIUDAD     c  ON pv.id_ciudad     = c.id_ciudad
WHERE p.duracion > 100
GROUP BY p.titulo, p.genero, p.duracion
HAVING COUNT(pr.id_proyeccion) > 1
ORDER BY total_funciones DESC;
GO
-- Resultado: Películas largas con más demanda de funciones, útil para negociar contratos de distribución.

--  CONSULTA 2
--  ¿Cuál es el aforo total por ciudad sumando salas 2D y 3D?
--  Solo ciudades con más de 200 butacas disponibles.

--  Álgebra relacional:
--  o aforo_total>200 ( y ciudad; SUM(capacidad) (CIUDAD c PUNTOVENTA x o tipo≠'VIP'(SALA) ) )

SELECT
    c.nombre                            AS ciudad,
    c.zona_geografica,
    COUNT(DISTINCT pv.id_punto_venta)   AS num_sedes,
    COUNT(s.id_sala)                    AS salas_comerciales,
    SUM(s.capacidad)                    AS aforo_total_butacas
FROM dbo.CIUDAD     c
JOIN dbo.PUNTOVENTA pv ON c.id_ciudad       = pv.id_ciudad
JOIN dbo.SALA       s  ON pv.id_punto_venta = s.id_punto_venta
WHERE s.tipo IN ('2D','3D')
GROUP BY c.nombre, c.zona_geografica
HAVING SUM(s.capacidad) > 200
ORDER BY aforo_total_butacas DESC;
GO
-- Resultado: Ciudades con mayor capacidad de espectadores; guía para campañas de marketing regional.

--  CONSULTA 3
--  ¿Qué géneros se proyectan más en cada zona geográfica?

--  Álgebra relacional:
--  y zona_geografica, genero; COUNT(*) (CIUDAD x PUNTOVENTA x SALA x PROYECCION x PELICULA )

SELECT
    c.zona_geografica,
    p.genero,
    COUNT(pr.id_proyeccion)             AS total_proyecciones,
    COUNT(DISTINCT c.id_ciudad)         AS ciudades
FROM dbo.PROYECCION pr
JOIN dbo.SALA       s  ON pr.id_sala       = s.id_sala
JOIN dbo.PUNTOVENTA pv ON s.id_punto_venta = pv.id_punto_venta
JOIN dbo.CIUDAD     c  ON pv.id_ciudad     = c.id_ciudad
JOIN dbo.PELICULA   p  ON pr.id_pelicula   = p.id_pelicula
GROUP BY c.zona_geografica, p.genero
ORDER BY c.zona_geografica, total_proyecciones DESC;
GO
-- Resultado: Preferencias de género por región; útil para decidir qué películas adquirir por zona.

--  CONSULTA 4
--  ¿Cuántos servicios VIP ofrece cada sede?
--  Mostrar solo las que tienen al menos 3 servicios.

--  Álgebra relacional:
--  o num_servicios>=3 ( y pv,c; COUNT(sv) (PUNTOVENTA x SALA x SALA_SERVICIO x CIUDAD ) )


SELECT
    pv.nombre                           AS sede,
    c.nombre                            AS ciudad,
    COUNT(DISTINCT ss.id_servicio)      AS num_servicios_vip,
    STRING_AGG(sv.nombre_servicio, ' | ') AS servicios
FROM dbo.SALA          s
JOIN dbo.SALA_SERVICIO ss  ON s.id_sala        = ss.id_sala
JOIN dbo.SERVICIOVIP   sv  ON ss.id_servicio   = sv.id_servicio
JOIN dbo.PUNTOVENTA    pv  ON s.id_punto_venta = pv.id_punto_venta
JOIN dbo.CIUDAD        c   ON pv.id_ciudad     = c.id_ciudad
WHERE s.tipo = 'VIP'
GROUP BY pv.nombre, c.nombre
HAVING COUNT(DISTINCT ss.id_servicio) >= 3
ORDER BY num_servicios_vip DESC;
GO
-- Resultado: Ranking de sedes premium; insumo para definir el precio de la boleta VIP.


--  CONSULTA 5
--  ¿Cuáles administradores tienen sueldo > $4.800.000
--  y cuántos empleados operativos supervisan?

--  Álgebra relacional:
--  o sueldo>4800000 (ADMINISTRADOR x EMPLEADO x PUNTOVENTA x CIUDAD )
 
SELECT
    e.nombre                            AS administrador,
    c.nombre                            AS ciudad,
    pv.nombre                           AS sede,
    a.sueldo,
    a.numero_hijos,
    (SELECT COUNT(*) FROM dbo.EMPLEADO e2
     WHERE e2.id_punto_venta = pv.id_punto_venta
       AND e2.id_empleado   <> e.id_empleado)  AS colegas_en_sede
FROM dbo.ADMINISTRADOR a
JOIN dbo.EMPLEADO   e  ON a.id_empleado    = e.id_empleado
JOIN dbo.PUNTOVENTA pv ON e.id_punto_venta = pv.id_punto_venta
JOIN dbo.CIUDAD     c  ON pv.id_ciudad     = c.id_ciudad
WHERE a.sueldo > 4800000
ORDER BY a.sueldo DESC;
GO
-- Resultado: Admins mejor pagados con contexto de sede; base para revisión salarial.


--TIPOS DE JOIN

--INNER JOIN
-- Solo películas que tienen proyecciones Y director registrado.
-- Álgebra: PELICULA ⋈ PROYECCION ⋈ DIRECTOR (intersección)
SELECT DISTINCT
    p.titulo, p.genero, p.duracion      AS min,
    d.nombre                            AS director,
    d.pais_procedencia
FROM dbo.PELICULA p
INNER JOIN dbo.PROYECCION pr ON p.id_pelicula = pr.id_pelicula
INNER JOIN dbo.DIRECTOR   d  ON p.id_director = d.id_director
ORDER BY p.titulo;
GO
-- Devuelve solo las películas que tienen al menos una función.
-- Beetlejuice y Requiem for a Dream no aparecen (sin proyecciones).

--LEFT JOIN 
-- Todas las películas, tengan o no funciones programadas.
-- Álgebra: PELICULA X PROYECCION (left outer join)
SELECT
    p.titulo,
    p.genero,
    COUNT(pr.id_proyeccion)             AS funciones_programadas,
    CASE WHEN COUNT(pr.id_proyeccion) = 0
         THEN 'Sin funciones'
         ELSE 'En cartelera'
    END                                 AS estado
FROM dbo.PELICULA p
LEFT JOIN dbo.PROYECCION pr ON p.id_pelicula = pr.id_pelicula
GROUP BY p.titulo, p.genero
ORDER BY funciones_programadas DESC;
GO
-- Las 22 películas aparecen; las 2 sin proyección muestran 0.

--RIGHT JOIN
-- Todas las salas 2D/3D, tengan o no función asignada.
-- Álgebra: PROYECCION X SALA (right outer join)
SELECT
    s.id_sala,
    CONCAT('Sala #', s.numero_sala, ' (', s.tipo, ')') AS sala,
    pv.nombre                           AS sede,
    ISNULL(CAST(pr.id_proyeccion AS VARCHAR), '—')     AS id_funcion,
    ISNULL(p.titulo, '— Sin función asignada —')       AS pelicula
FROM dbo.PROYECCION pr
RIGHT JOIN dbo.SALA       s  ON pr.id_sala        = s.id_sala
RIGHT JOIN dbo.PUNTOVENTA pv ON s.id_punto_venta  = pv.id_punto_venta
LEFT  JOIN dbo.PELICULA   p  ON pr.id_pelicula    = p.id_pelicula
WHERE s.tipo IN ('2D','3D')
ORDER BY pv.nombre, s.numero_sala;
GO
-- Salas sin proyección asignada aparecen con '— Sin función asignada —'.

--FULL OUTER JOIN
-- Actores y películas: ver los que tienen pareja y los que no.
-- Álgebra: ACTOR X PELICULA_ACTOR X PELICULA
SELECT
    ISNULL(a.nombre, '— Sin actor —')  AS actor,
    a.edad,
    ISNULL(p.titulo, '— Sin película —') AS pelicula,
    ISNULL(p.genero, 'N/A')             AS genero
FROM dbo.ACTOR a
FULL OUTER JOIN dbo.PELICULA_ACTOR pa ON a.id_actor     = pa.id_actor
FULL OUTER JOIN dbo.PELICULA       p  ON pa.id_pelicula = p.id_pelicula
ORDER BY a.nombre;
GO
-- Keanu Reeves y Denzel Washington aparecen sin película.
-- Actores con película muestran su relación normalmente.

--CROSS JOIN
-- Todas las combinaciones posibles ciudad × tipo de sala.
-- Útil para análisis de expansión: qué falta en cada ciudad.
-- Álgebra: CIUDAD × {2D, 3D, VIP} (producto cartesiano)
SELECT
    c.nombre                            AS ciudad,
    c.zona_geografica,
    tipos.tipo_sala,
    CONCAT('¿Hay sala ', tipos.tipo_sala,
           ' en ', c.nombre, '?')       AS pregunta_expansion
FROM dbo.CIUDAD c
CROSS JOIN (
    SELECT '2D'  AS tipo_sala UNION ALL
    SELECT '3D'               UNION ALL
    SELECT 'VIP'
) tipos
ORDER BY c.nombre, tipos.tipo_sala;
GO
-- 66 filas (22 ciudades × 3 tipos de sala), incluyendo ciudades sin sede.

PRINT '>>> Sección 3 completa: consultas ejecutadas.';
GO

