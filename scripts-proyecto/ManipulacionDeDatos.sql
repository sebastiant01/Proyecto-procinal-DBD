-- =============================================================================
-- MANIPULACIÓN DE DATOS Y ESTRUCTURA
-- =============================================================================
USE Procinal;
GO

-- Actualización del título de película
UPDATE Pelicula 
SET titulo = 'Inception: El Origen' 
WHERE id_pelicula = 1;
GO

-- Eliminación de columna temperatura_media de Ciudad
ALTER TABLE Ciudad 
DROP COLUMN temperatura_media;
GO

-- Modificación del tamaño de la columna cargo en Empleado
ALTER TABLE Empleado 
ALTER COLUMN cargo VARCHAR(100);
GO

-- Adición de columna clasificacion a Pelicula
ALTER TABLE Pelicula 
ADD clasificacion VARCHAR(15);
GO

-- =============================================================================
-- VERIFICACIONES
-- =============================================================================

-- 1. Verificar que el título de la película fue actualizado
SELECT id_pelicula, titulo
FROM Pelicula
WHERE id_pelicula = 1;
GO

-- 2. Verificar que la columna temperatura_media fue eliminada de Ciudad
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Ciudad'
  AND COLUMN_NAME = 'temperatura_media';
GO

-- 3. Verificar que el tamaño de la columna cargo cambió a VARCHAR(100)
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Empleado'
  AND COLUMN_NAME = 'cargo';
GO

-- 4. Verificar que la columna clasificacion fue agregada a Pelicula
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Pelicula'
  AND COLUMN_NAME = 'clasificacion';