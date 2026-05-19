-- =============================================================================
-- PARTE C: CONSULTAS AVANZADAS (PUNTOS 14 AL 17)
-- =============================================================================

USE Procinal;
GO

-- -----------------------------------------------------------------------------
-- 14. Teoría de Conjuntos: UNION
-- Lista unificada de todos los cargos operativos principales sin duplicados
-- -----------------------------------------------------------------------------
SELECT nombre, cargo
FROM Empleado
WHERE
    cargo = 'Administrador'
UNION
SELECT nombre, cargo
FROM Empleado
WHERE
    cargo = 'Cajero';
GO

-- -----------------------------------------------------------------------------
-- 14. Teoría de Conjuntos: INTERSECT
-- Obtiene los IDs de las ciudades que SÍ tienen un punto de venta.
-- (Intersección entre las ciudades registradas y las que tienen sede)
-- -----------------------------------------------------------------------------
SELECT id_ciudad
FROM Ciudad INTERSECT
SELECT id_ciudad
FROM PuntoVenta;
GO

-- -----------------------------------------------------------------------------
-- 14. Teoría de Conjuntos: EXCEPT
-- Obtiene las ciudades registradas en la base de datos que NO tienen
-- un punto de venta asignado (Ej: Leticia, Riohacha).
-- -----------------------------------------------------------------------------
SELECT id_ciudad, nombre
FROM Ciudad EXCEPT
SELECT C.id_ciudad, C.nombre
FROM Ciudad C
    INNER JOIN PuntoVenta PV ON C.id_ciudad = PV.id_ciudad;
GO

-- -----------------------------------------------------------------------------
-- 15. Operadores Especiales: ANY / ALL
-- Encuentra las películas cuya duración es mayor a TODAS las películas
-- del género 'Comedia'.
-- -----------------------------------------------------------------------------
SELECT titulo, duracion, genero
FROM Pelicula
WHERE
    duracion > ALL (
        SELECT duracion
        FROM Pelicula
        WHERE
            genero = 'Comedia'
    );
GO

-- -----------------------------------------------------------------------------
-- 15. Operadores Especiales: LIKE y comodines
-- Busca empleados cuyo nombre empiece con 'M' y tenga cualquier apellido.
-- El comodín '%' representa cero o más caracteres.
-- -----------------------------------------------------------------------------
SELECT nombre, cargo FROM Empleado WHERE nombre LIKE 'M%';
GO

-- -----------------------------------------------------------------------------
-- 16. Funciones y Conversiones (CAST, CONCAT, GETDATE, SUM)
-- Genera un reporte concatenando texto, calculando totales numéricos
-- y obteniendo la fecha actual del sistema.
-- -----------------------------------------------------------------------------
SELECT
    COUNT(*) AS total_peliculas,
    SUM(duracion) AS duracion_total_minutos,
    CONCAT(
        'Duración total: ',
        CAST(SUM(duracion) AS VARCHAR(10)),
        ' min.'
    ) AS reporte_duracion,
    GETDATE () AS fecha_consulta
FROM Pelicula;
GO

-- -----------------------------------------------------------------------------
-- 17. Cláusulas Avanzadas: CASE en SELECT (Atributo derivado/calculado)
-- Clasifica dinámicamente las salas 2D según su capacidad de sillas.
-- -----------------------------------------------------------------------------
SELECT
    id_sala,
    capacidad,
    CASE
        WHEN capacidad >= 125 THEN 'Sala Extra Grande'
        WHEN capacidad >= 115 THEN 'Sala Mediana'
        ELSE 'Sala Pequeña'
    END AS tipo_sala
FROM Sala2D
ORDER BY capacidad DESC;
GO