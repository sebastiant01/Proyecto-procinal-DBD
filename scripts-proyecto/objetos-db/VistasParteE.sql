-- =============================================================================
-- PARTE E: OBJETOS DE BASE DE DATOS (VISTAS)
-- =============================================================================

USE Procinal;
GO

-- -----------------------------------------------------------------------------
-- 19. Vista Estándar (CREATE VIEW)
-- Vista que consolida la cartelera cruzando proyecciones, películas,
-- directores y el punto de venta. Facilita la consulta sin hacer los JOINs.
-- -----------------------------------------------------------------------------
CREATE OR ALTER VIEW vw_CarteleraCompleta AS
    SELECT 
        P.titulo AS Pelicula,
        D.nombre AS Director,
        S.numero_sala AS Sala,
        PR.fecha_proyeccion AS Horario,
        PV.nombre AS Punto_Venta
    FROM Proyeccion PR
    INNER JOIN Pelicula P ON PR.id_pelicula = P.id_pelicula
    INNER JOIN Director D ON P.id_director = D.id_director
    INNER JOIN Sala S ON PR.id_sala = S.id_sala
    INNER JOIN PuntoVenta PV ON S.id_punto_venta = PV.id_punto_venta;
GO

-- Ejemplo de uso de la vista estándar
SELECT * 
FROM vw_CarteleraCompleta 
WHERE Punto_Venta LIKE '%Estación%';
GO

-- -----------------------------------------------------------------------------
-- 19. Vista Indexada (Alternativa a Vistas Materializadas en SQL Server)
-- IMPORTANTE: Para indexar una vista en SQL Server, DEBE crearse con 
-- SCHEMABINDING (que ancla la vista a la estructura de la tabla) y 
-- todas las funciones/agrupaciones deben ser determinísticas (usar COUNT_BIG).
-- Mejora el rendimiento en lecturas muy frecuentes.
-- -----------------------------------------------------------------------------
CREATE OR ALTER VIEW vw_TotalSalasPorPuntoVenta 
WITH SCHEMABINDING 
AS
    SELECT 
        id_punto_venta,
        COUNT_BIG(*) AS Total_Salas
    FROM dbo.Sala
    GROUP BY id_punto_venta;
    GO

    -- Creación del índice clúster único para materializar la vista físicamente
    -- en el disco.
    CREATE UNIQUE CLUSTERED INDEX UQ_vw_TotalSalas 
    ON vw_TotalSalasPorPuntoVenta (id_punto_venta);
GO

-- Ejemplo de uso de la vista indexada
SELECT * 
FROM vw_TotalSalasPorPuntoVenta
ORDER BY Total_Salas DESC;
GO
