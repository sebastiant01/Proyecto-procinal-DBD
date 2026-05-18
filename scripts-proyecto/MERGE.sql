USE procinal;
GO

MERGE dbo.Pelicula AS destino
USING 
(
    SELECT 
        999 AS id_pelicula,
        'Avatar 3' AS titulo,
        'Ciencia ficción' AS genero
) AS origen
ON destino.id_pelicula = origen.id_pelicula

WHEN MATCHED THEN
    UPDATE SET
        destino.titulo = origen.titulo,
        destino.genero = origen.genero

WHEN NOT MATCHED THEN
    INSERT 
    (
        id_pelicula,
        titulo,
        genero
    )
    VALUES 
    (
        origen.id_pelicula,
        origen.titulo,
        origen.genero
    );
GO

SELECT * 
FROM dbo.Pelicula
WHERE id_pelicula = 999;
GO