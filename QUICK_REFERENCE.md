# 📝 Guía Rápida - StudyQuestDB

Comandos SQL más comunes para trabajar con StudyQuestDB.

## 🔐 Conexión Básica

```sql
-- Usar la base de datos
USE StudyQuestDB;
GO
```

---

## 👥 Operaciones con Usuarios

### Crear un nuevo usuario
```sql
INSERT INTO usuario (id_usuario, nombre, apellido, correo, telefono, fecha_creacion)
VALUES (20, 'Juan', 'García', 'juan@studyquest.com', '999999990', CAST(GETDATE() AS DATE));
```

### Listar todos los usuarios
```sql
SELECT * FROM usuario;
```

### Buscar usuario por correo
```sql
SELECT * FROM usuario WHERE correo = 'mia@studyquest.com';
```

### Actualizar teléfono de usuario
```sql
UPDATE usuario 
SET telefono = '988888888' 
WHERE id_usuario = 10;
```

---

## 🎓 Operaciones con Cursos

### Crear un nuevo curso
```sql
INSERT INTO curso (id_curso, nombre_curso, descipcion, id_docente)
VALUES (11, 'Física', 'Curso de física general', 10);
```

### Listar todos los cursos
```sql
SELECT 
    c.id_curso,
    c.nombre_curso,
    c.descipcion,
    u.nombre AS docente_nombre
FROM curso c
INNER JOIN docente d ON c.id_docente = d.id_docente
INNER JOIN usuario u ON d.id_usuario = u.id_usuario;
```

### Crear una sección de curso
```sql
INSERT INTO seccion (id_seccion, nombre_seccion, periodo, id_curso)
VALUES (11, 'B1', '2025-I', 11);
```

---

## 📚 Operaciones con Tareas

### Crear una tarea
```sql
INSERT INTO tarea (id_tarea, titulo, descripcion, fecha_publicacion, fecha_limite, xp_base, id_seccion)
VALUES (20, 'Quiz 1', 'Evaluación rápida', GETDATE(), DATEADD(DAY, 7, GETDATE()), 50, 10);
```

### Listar todas las tareas
```sql
SELECT 
    t.id_tarea,
    t.titulo,
    t.descripcion,
    t.xp_base,
    s.nombre_seccion,
    c.nombre_curso
FROM tarea t
INNER JOIN seccion s ON t.id_seccion = s.id_seccion
INNER JOIN curso c ON s.id_curso = c.id_curso
ORDER BY t.fecha_limite;
```

### Tareas próximas a vencer
```sql
SELECT 
    t.titulo,
    t.fecha_limite,
    DATEDIFF(DAY, GETDATE(), t.fecha_limite) AS dias_restantes
FROM tarea t
WHERE DATEDIFF(DAY, GETDATE(), t.fecha_limite) <= 3
ORDER BY t.fecha_limite;
```

---

## ✅ Operaciones con Entregas

### Registrar una entrega
```sql
INSERT INTO entrega (id_entrega, fecha_entrega, xp_obtenido, calificacion, id_tarea, id_estudiante)
VALUES (20, GETDATE(), 100, 19.0, 10, 10);
```

### Ver todas las entregas de un estudiante
```sql
SELECT 
    e.id_entrega,
    t.titulo AS tarea,
    e.fecha_entrega,
    e.calificacion,
    e.xp_obtenido
FROM entrega e
INNER JOIN tarea t ON e.id_tarea = t.id_tarea
WHERE e.id_estudiante = 10
ORDER BY e.fecha_entrega DESC;
```

### Ver entregas con calificaciones bajas (< 12)
```sql
SELECT 
    u.nombre,
    u.apellido,
    t.titulo,
    e.calificacion,
    t.fecha_limite,
    CASE 
        WHEN e.fecha_entrega <= t.fecha_limite THEN 'A tiempo'
        ELSE 'Atrasada'
    END AS estado_entrega
FROM entrega e
INNER JOIN estudiante est ON e.id_estudiante = est.id_estudiante
INNER JOIN usuario u ON est.id_usuario = u.id_usuario
INNER JOIN tarea t ON e.id_tarea = t.id_tarea
WHERE e.calificacion < 12
ORDER BY u.nombre;
```

---

## 🏆 Operaciones con XP y Rankings

### Ver XP total de un estudiante
```sql
SELECT 
    u.nombre,
    u.apellido,
    SUM(e.xp_obtenido) AS XP_Total
FROM usuario u
INNER JOIN estudiante est ON u.id_usuario = est.id_usuario
INNER JOIN entrega e ON est.id_estudiante = e.id_estudiante
WHERE est.id_estudiante = 10
GROUP BY u.nombre, u.apellido;
```

### Ver top 5 estudiantes por XP en un curso
```sql
SELECT TOP 5
    u.nombre,
    u.apellido,
    SUM(e.xp_obtenido) AS XP_Total
FROM usuario u
INNER JOIN estudiante est ON u.id_usuario = est.id_usuario
INNER JOIN entrega e ON est.id_estudiante = e.id_estudiante
INNER JOIN tarea t ON e.id_tarea = t.id_tarea
INNER JOIN seccion s ON t.id_seccion = s.id_seccion
INNER JOIN curso c ON s.id_curso = c.id_curso
WHERE c.id_curso = 10
GROUP BY u.nombre, u.apellido
ORDER BY XP_Total DESC;
```

### Usar la función de ranking
```sql
SELECT * FROM fn_RankingUsuariosPorCurso(10);
```

---

## 📊 Estadísticas y Reportes

### Promedio de calificación por tarea
```sql
SELECT 
    t.titulo,
    COUNT(*) AS cantidad_entregas,
    ROUND(AVG(e.calificacion), 2) AS promedio,
    MIN(e.calificacion) AS minimo,
    MAX(e.calificacion) AS maximo
FROM tarea t
INNER JOIN entrega e ON t.id_tarea = e.id_tarea
GROUP BY t.id_tarea, t.titulo
ORDER BY t.titulo;
```

### Tasa de entrega por curso
```sql
SELECT 
    c.nombre_curso,
    COUNT(DISTINCT e.id_estudiante) AS estudiantes_entregaron,
    COUNT(DISTINCT est.id_estudiante) AS total_estudiantes,
    ROUND(100.0 * COUNT(DISTINCT e.id_estudiante) / COUNT(DISTINCT est.id_estudiante), 2) AS porcentaje
FROM curso c
INNER JOIN seccion s ON c.id_curso = s.id_curso
INNER JOIN tarea t ON s.id_seccion = t.id_seccion
LEFT JOIN entrega e ON t.id_tarea = e.id_tarea
INNER JOIN inscripcion ins ON s.id_seccion = ins.id_seccion
INNER JOIN estudiante est ON ins.id_estudiante = est.id_estudiante
GROUP BY c.id_curso, c.nombre_curso;
```

### Estudiantes sin entregas
```sql
SELECT 
    u.nombre,
    u.apellido,
    est.codigo_estudiante
FROM estudiante est
INNER JOIN usuario u ON est.id_usuario = u.id_usuario
LEFT JOIN entrega e ON est.id_estudiante = e.id_estudiante
WHERE e.id_entrega IS NULL;
```

---

## 🔍 Consultas de Búsqueda Avanzada

### Buscar tareas por palabra clave
```sql
SELECT * FROM tarea 
WHERE titulo LIKE '%algebra%' 
   OR descripcion LIKE '%algebra%'
ORDER BY fecha_publicacion DESC;
```

### Ver actividad de un estudiante en el último mes
```sql
SELECT 
    t.titulo,
    e.fecha_entrega,
    e.calificacion,
    e.xp_obtenido
FROM entrega e
INNER JOIN tarea t ON e.id_tarea = t.id_tarea
WHERE e.id_estudiante = 10
  AND DATEDIFF(DAY, e.fecha_entrega, GETDATE()) <= 30
ORDER BY e.fecha_entrega DESC;
```

---

## ✏️ Actualizar Datos

### Cambiar calificación de una entrega
```sql
UPDATE entrega 
SET calificacion = 18.5, xp_obtenido = 120
WHERE id_entrega = 10;
```

### Cambiar estado de inscripción
```sql
UPDATE inscripcion 
SET estado = 'Activo'
WHERE id_estudiante = 10 AND id_seccion = 10;
```

---

## 🗑️ Eliminar Datos

### Eliminar una entrega (si no tiene comentarios/archivos)
```sql
DELETE FROM entrega 
WHERE id_entrega = 20;
```

### Eliminar un estudiante de una sección
```sql
DELETE FROM inscripcion 
WHERE id_estudiante = 10 AND id_seccion = 10;
```

⚠️ **Nota**: Respetar las restricciones de clave foránea. Algunos registros pueden no poder eliminarse si tienen dependencias.

---

## 💡 Tips Útiles

### Ver estructura de una tabla
```sql
EXEC sp_columns 'usuario';
-- O en SSMS: Expandir Databases > StudyQuestDB > Tables > Tabla > Columns
```

### Contar registros en todas las tablas
```sql
SELECT 
    OBJECT_NAME(OBJECT_ID) AS tabla,
    SUM(rows) AS cantidad_filas
FROM sys.dm_db_partition_stats
WHERE database_id = DB_ID()
GROUP BY OBJECT_ID
ORDER BY cantidad_filas DESC;
```

### Ver todas las funciones disponibles
```sql
SELECT name, type FROM sys.objects 
WHERE type = 'TF' OR type = 'IF'
ORDER BY name;
```

---

## 📞 Soporte

Si necesitas ayuda con un query específico, documenta:
1. Qué quieres hacer
2. Qué datos esperas obtener
3. Qué error recibiste (si aplica)

