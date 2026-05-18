USE procinal;
GO

CREATE OR ALTER FUNCTION dbo.fn_TotalProyecciones
(
    @id_pelicula INT
)
RETURNS INT
AS
BEGIN
    DECLARE @total INT;

    SELECT @total = COUNT(*)
    FROM dbo.Proyeccion
    WHERE id_pelicula = @id_pelicula;

    RETURN @total;
END;
GO
SELECT dbo.fn_TotalProyecciones(1) AS total_proyecciones;