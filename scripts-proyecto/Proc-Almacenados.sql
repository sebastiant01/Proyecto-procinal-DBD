USE procinal;
GO

CREATE OR ALTER PROCEDURE dbo.sp_PeliculasPorPuntoVenta
    @id_punto_venta INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        PV.nombre AS punto_venta,
        S.id_sala,
        P.titulo,
        P.genero,
        PR.fecha_proyeccion
    FROM dbo.PuntoVenta AS PV
    INNER JOIN dbo.Sala AS S
        ON PV.id_punto_venta = S.id_punto_venta
    INNER JOIN dbo.Proyeccion AS PR
        ON S.id_sala = PR.id_sala
    INNER JOIN dbo.Pelicula AS P
        ON PR.id_pelicula = P.id_pelicula
    WHERE PV.id_punto_venta = @id_punto_venta
    ORDER BY PR.fecha_proyeccion DESC;
END;
GO

-- Ejecutándolo manualmente con un parámetro estático
EXEC dbo.sp_PeliculasPorPuntoVenta 1;

SELECT * FROM PuntoVenta;

-- Ejecutándolo usando parámetros dinámicos

USE procinal;
GO

DECLARE @punto_venta INT;

SET @punto_venta = 1;

EXEC dbo.sp_PeliculasPorPuntoVenta 
    @id_punto_venta = @punto_venta;
GO