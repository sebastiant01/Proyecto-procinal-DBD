USE procinal;
GO

-- Encriptación de textos usando ENCRYPTBYPASSPHRASE

DECLARE @texto_original VARCHAR(100);
DECLARE @texto_encriptado VARBINARY(MAX);
DECLARE @texto_desencriptado VARCHAR(100);

SET @texto_original = 'ClaveSegura123';

/* ENCRIPTAR */

SET @texto_encriptado =
    ENCRYPTBYPASSPHRASE
    (
        'MiClaveSecreta',
        @texto_original
    );

/* MOSTRAR TEXTO ENCRIPTADO */

SELECT 
    @texto_original AS texto_original,
    @texto_encriptado AS texto_encriptado;

/* DESENCRIPTAR */

SET @texto_desencriptado =
    CONVERT
    (
        VARCHAR(100),
        DECRYPTBYPASSPHRASE
        (
            'MiClaveSecreta',
            @texto_encriptado
        )
    );

/* MOSTRAR TEXTO DESENCRIPTADO */

SELECT 
    @texto_desencriptado AS texto_desencriptado;
GO

-- Encriptación de texto usando HASHBYTE
USE procinal;
GO

SELECT 
    '123456' AS contraseña_original,

    HASHBYTES
    (
        'SHA2_256',
        '123456'
    ) AS contraseña_encriptada;
GO