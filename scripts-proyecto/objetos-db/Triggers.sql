USE procinal;
GO

/* Crear la tabla solo si NO existe */
IF OBJECT_ID('dbo.AuditoriaProyeccion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.AuditoriaProyeccion
    (
        id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
        id_proyeccion INT,
        id_pelicula INT,
        id_sala INT,
        fecha_proyeccion DATETIME,
        accion VARCHAR(50),
        fecha_registro DATETIME DEFAULT GETDATE()
    );
END;
GO

-- Trigger AFTER

/* Crear o actualizar el trigger */
CREATE OR ALTER TRIGGER dbo.trg_AuditoriaInsertProyeccion
ON dbo.Proyeccion
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AuditoriaProyeccion
    (
        id_proyeccion,
        id_pelicula,
        id_sala,
        fecha_proyeccion,
        accion
    )
    SELECT
        I.id_proyeccion,
        I.id_pelicula,
        I.id_sala,
        I.fecha_proyeccion,
        'INSERT'
    FROM inserted AS I;
END;
GO

INSERT INTO dbo.Proyeccion
(
    id_proyeccion,
    id_pelicula,
    id_sala,
    fecha_proyeccion
)
VALUES
(
    999,
    1,
    1,
    GETDATE()
);
GO

SELECT * FROM dbo.AuditoriaProyeccion;
GO

-- Trigger INSTEAD OF

CREATE OR ALTER TRIGGER trg_ImpedirEliminarAdministrador
ON dbo.Empleado
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS
    (
        SELECT 1 FROM deleted
        WHERE cargo = 'Administrador'
    )
    BEGIN
        PRINT 'Operación cancelada: no se puede eliminar un administrador directamente.';
    END
END;
