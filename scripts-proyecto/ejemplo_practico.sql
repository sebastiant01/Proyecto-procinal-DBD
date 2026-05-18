USE procinal;
GO

/* CREAR TABLA */

CREATE TABLE dbo.UsuarioSeguridad
(
    id_usuario INT PRIMARY KEY,
    nombre VARCHAR(100),
    contraseña VARBINARY(MAX)
);
GO

/*  INSERTAR USUARIO CON CONTRASEÑA ENCRIPTADA */

INSERT INTO dbo.UsuarioSeguridad
(
    id_usuario,
    nombre,
    contraseña
)
VALUES
(
    1,
    'Ana Sofia',

    ENCRYPTBYPASSPHRASE
    (
        'ClaveSuperSegura',
        'MiPassword123'
    )
);
GO

/* CONSULTAR DATOS ENCRIPTADOS */

SELECT * 
FROM dbo.UsuarioSeguridad;
GO

/* DESENCRIPTAR CONTRASEÑA */

SELECT
    id_usuario,
    nombre,

    CONVERT
    (
        VARCHAR(100),

        DECRYPTBYPASSPHRASE
        (
            'ClaveSuperSegura',
            contraseña
        )
    ) AS contraseña_desencriptada

FROM dbo.UsuarioSeguridad;
GO