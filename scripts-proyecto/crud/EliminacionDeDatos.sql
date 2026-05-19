-- =============================================================================
-- ELIMINACIÓN DE DATOS Y ESTRUCTURA
-- =============================================================================
USE Procinal
GO

-- Eliminación de un registro específico de la tabla Actor
-- Se elimina el actor con id_actor = 16 (Tom Hanks) - sin películas asignadas en Protagoniza
DELETE FROM dbo.Actor 
WHERE id_actor = 16;
GO

-- Eliminación de la columna zona_geografica de la tabla Ciudad
ALTER TABLE dbo.Ciudad 
DROP COLUMN zona_geografica;
GO

-- Eliminación con instrucciones especiales

-- Borra la tabla junto sus datos (la ejecución dependerá si tuvo FKs o Check Constraints en esta)
DROP TABLE dbo.CIUDAD_PRUEBA;

-- Borra la BD
DROP DATABASE Procinal;

-- Borra TODOS los registros de la tabla
TRUNCATE TABLE dbo.Ciudad;

-- =============================================================================
-- VERIFICACIONES DE ELIMINACIÓN
-- =============================================================================

-- 5. Verificar que el registro del actor fue eliminado correctamente
SELECT id_actor, nombre, edad
FROM dbo.Actor
WHERE id_actor = 16;
GO

-- 6. Verificar que la columna zona_geografica fue eliminada de Ciudad
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'Ciudad'
  AND COLUMN_NAME = 'zona_geografica';
GO