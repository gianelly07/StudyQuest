-- ===============================================
-- SCRIPT DE RESETEO - StudyQuestDB
-- ===============================================
-- ⚠️ ADVERTENCIA: Este script elimina TODOS los
-- datos de la base de datos. Usar con cuidado.
-- ===============================================

USE StudyQuestDB;
GO

-- Desactivar restricciones de integridad referencial temporalmente
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

-- Eliminar datos en orden inverso de las dependencias
DELETE FROM comentario;
DELETE FROM archivo_adjunto;
DELETE FROM entrega;
DELETE FROM estudiante_logro;
DELETE FROM racha;
DELETE FROM tarea;
DELETE FROM inscripcion;
DELETE FROM seccion;
DELETE FROM docente_especialidad;
DELETE FROM curso;
DELETE FROM docente;
DELETE FROM estudiante;
DELETE FROM logro;
DELETE FROM especialidad;
DELETE FROM usuario;

GO

-- Reactivar restricciones de integridad referencial
EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL';
GO

-- Opción: Resetear IDENTITY (si las tablas los usan)
-- DBCC CHECKIDENT ('usuario', RESEED, 0);
-- DBCC CHECKIDENT ('docente', RESEED, 0);
-- etc...

PRINT '✓ Base de datos limpiada exitosamente.';
PRINT '✓ Ahora puedes ejecutar StudyQuestDB_Complete.sql nuevamente.';
GO
