USE procinal;
GO

BEGIN TRY

    INSERT INTO dbo.Proyeccion
    (
        id_proyeccion,
        id_pelicula,
        id_sala,
        fecha_proyeccion
    )
    VALUES
    (
        1000,
        1,
        1,
        GETDATE()
    );

    PRINT 'La proyección se insertó correctamente.';

END TRY

BEGIN CATCH

    PRINT 'Ocurrió un error al insertar la proyección.';

    PRINT 'Mensaje del error: ' + ERROR_MESSAGE();

END CATCH;
GO