-- ===============================================
-- StudyQuestDB - Base de Datos Gamificada
-- ===============================================
-- Descripción: Sistema de gestión de cursos con
-- gamificación mediante puntos de experiencia (XP),
-- logros y ranking de estudiantes.
-- ===============================================

-- Crear la base de datos
CREATE DATABASE StudyQuestDB;
GO

-- Usar la base de datos
USE StudyQuestDB;
GO

-- ===============================================
-- TABLA: USUARIO
-- ===============================================
CREATE TABLE usuario
(
  id_usuario     INT          NOT NULL,
  nombre         VARCHAR(250) NOT NULL,
  apellido       VARCHAR(250) NOT NULL,
  correo         VARCHAR(150) NOT NULL UNIQUE,
  telefono       VARCHAR(9)   NOT NULL,
  fecha_creacion DATE         NOT NULL,
  PRIMARY KEY (id_usuario)
);

-- ===============================================
-- TABLA: DOCENTE
-- ===============================================
CREATE TABLE docente
(
  id_docente INT NOT NULL,
  id_usuario INT NOT NULL,
  PRIMARY KEY (id_docente),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- ===============================================
-- TABLA: ESTUDIANTE
-- ===============================================
CREATE TABLE estudiante
(
  id_estudiante     INT          NOT NULL,
  codigo_estudiante VARCHAR(15)  NOT NULL UNIQUE,
  carrera           VARCHAR(100) NOT NULL,
  id_usuario        INT          NOT NULL,
  PRIMARY KEY (id_estudiante),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- ===============================================
-- TABLA: ESPECIALIDAD
-- ===============================================
CREATE TABLE especialidad
(
  id_especialidad INT          NOT NULL,
  descripción     VARCHAR(250) NOT NULL,
  PRIMARY KEY (id_especialidad)
);

-- ===============================================
-- TABLA: DOCENTE_ESPECIALIDAD
-- ===============================================
CREATE TABLE docente_especialidad
(
  id_docente      INT NOT NULL,
  id_especialidad INT NOT NULL,
  PRIMARY KEY (id_docente, id_especialidad),
  FOREIGN KEY (id_docente) REFERENCES docente(id_docente),
  FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad)
);

-- ===============================================
-- TABLA: CURSO
-- ===============================================
CREATE TABLE curso
(
  id_curso     INT          NOT NULL,
  nombre_curso VARCHAR(100) NOT NULL,
  descipcion   VARCHAR(250) NOT NULL,
  id_docente   INT          NOT NULL,
  PRIMARY KEY (id_curso),
  FOREIGN KEY (id_docente) REFERENCES docente(id_docente)
);

-- ===============================================
-- TABLA: SECCIÓN
-- ===============================================
CREATE TABLE seccion
(
  id_seccion     INT          NOT NULL,
  nombre_seccion VARCHAR(100) NOT NULL,
  periodo        VARCHAR(50)  NOT NULL,
  id_curso       INT          NOT NULL,
  PRIMARY KEY (id_seccion),
  FOREIGN KEY (id_curso) REFERENCES curso(id_curso)
);

-- ===============================================
-- TABLA: INSCRIPCIÓN
-- ===============================================
CREATE TABLE inscripcion
(
  id_estudiante     INT          NOT NULL,
  id_seccion        INT          NOT NULL,
  fecha_inscripcion DATETIME     NOT NULL,
  estado            VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_estudiante, id_seccion),
  FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante),
  FOREIGN KEY (id_seccion) REFERENCES seccion(id_seccion)
);

-- ===============================================
-- TABLA: TAREA
-- ===============================================
CREATE TABLE tarea
(
  id_tarea          INT          NOT NULL,
  titulo            VARCHAR(250) NOT NULL,
  descripcion       VARCHAR(250) NOT NULL,
  fecha_publicacion DATETIME     NOT NULL,
  fecha_limite      DATETIME     NOT NULL,
  xp_base           INT          NOT NULL,
  id_seccion        INT          NOT NULL,
  PRIMARY KEY (id_tarea),
  FOREIGN KEY (id_seccion) REFERENCES seccion(id_seccion)
);

-- ===============================================
-- TABLA: ENTREGA
-- ===============================================
CREATE TABLE entrega
(
  id_entrega    INT      NOT NULL,
  fecha_entrega DATETIME NOT NULL,
  xp_obtenido   INT      NOT NULL,
  calificacion  FLOAT    NOT NULL,
  id_tarea      INT      NOT NULL,
  id_estudiante INT      NOT NULL,
  PRIMARY KEY (id_entrega),
  FOREIGN KEY (id_tarea) REFERENCES tarea(id_tarea),
  FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante)
);

-- ===============================================
-- TABLA: ARCHIVO_ADJUNTO
-- ===============================================
CREATE TABLE archivo_adjunto
(
  id_archivo     INT          NOT NULL,
  id_tarea       INT          NOT NULL,
  id_entrega     INT          NOT NULL,
  nombre_archivo VARCHAR(250) NOT NULL,
  fecha_subido   DATETIME     NOT NULL,
  PRIMARY KEY (id_archivo),
  FOREIGN KEY (id_tarea) REFERENCES tarea(id_tarea),
  FOREIGN KEY (id_entrega) REFERENCES entrega(id_entrega)
);

-- ===============================================
-- TABLA: COMENTARIO
-- ===============================================
CREATE TABLE comentario
(
  id_comentario INT          NOT NULL,
  contenido     VARCHAR(250) NOT NULL,
  fecha         DATE         NOT NULL,
  id_usuario    INT          NOT NULL,
  id_entrega    INT          NOT NULL,
  PRIMARY KEY (id_comentario),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  FOREIGN KEY (id_entrega) REFERENCES entrega(id_entrega)
);

-- ===============================================
-- TABLA: LOGRO
-- ===============================================
CREATE TABLE logro
(
  id_logro     INT          NOT NULL,
  nombre       VARCHAR(250) NOT NULL,
  descripcipon VARCHAR(250) NOT NULL,
  xp_bonus     INT          NOT NULL,
  PRIMARY KEY (id_logro)
);

-- ===============================================
-- TABLA: ESTUDIANTE_LOGRO
-- ===============================================
CREATE TABLE estudiante_logro
(
  id_estudiante  INT  NOT NULL,
  id_logro       INT  NOT NULL,
  fecha_obtenida DATE NOT NULL,
  PRIMARY KEY (id_estudiante, id_logro),
  FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante),
  FOREIGN KEY (id_logro) REFERENCES logro(id_logro)
);

-- ===============================================
-- TABLA: RACHA
-- ===============================================
CREATE TABLE racha
(
  id_racha               INT  NOT NULL,
  fecha_inicio           DATE NOT NULL,
  fecha_ultima_actividad DATE NOT NULL,
  id_estudiante          INT  NOT NULL,
  PRIMARY KEY (id_racha),
  FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante)
);

-- ===============================================
-- DATOS DE EJEMPLO
-- ===============================================

-- Insertar Usuarios
INSERT INTO usuario (id_usuario, nombre, apellido, correo, telefono, fecha_creacion)
VALUES 
(10, 'Mia', 'Bobadilla', 'mia@studyquest.com', '999999999', CAST(GETDATE() AS DATE)),
(11, 'Alex', 'Ramos', 'alex@studyquest.com', '999999998', CAST(GETDATE() AS DATE)),
(12, 'Zoe', 'Alarcón', 'zoe@studyquest.com', '999999997', CAST(GETDATE() AS DATE));

-- Insertar Docente
INSERT INTO docente (id_docente, id_usuario) 
VALUES (10, 10);

-- Insertar Curso
INSERT INTO curso (id_curso, nombre_curso, descipcion, id_docente)
VALUES (10, 'Matemática Gamificada', 'Curso con retos y XP', 10);

-- Insertar Sección
INSERT INTO seccion (id_seccion, nombre_seccion, periodo, id_curso)
VALUES (10, 'A1', '2025-I', 10);

-- Insertar Estudiantes
INSERT INTO estudiante (id_estudiante, codigo_estudiante, carrera, id_usuario)
VALUES 
(10, 'EST001', 'Ingeniería', 11),
(11, 'EST002', 'Ingeniería', 12);

-- Insertar Tareas
INSERT INTO tarea (id_tarea, titulo, descripcion, fecha_publicacion, fecha_limite, xp_base, id_seccion)
VALUES
(10, 'Misión 1', 'Resolver ejercicios', GETDATE(), GETDATE(), 100, 10),
(11, 'Misión 2', 'Crear resumen', GETDATE(), GETDATE(), 150, 10),
(12, 'Misión 3', 'Examen corto', GETDATE(), GETDATE(), 200, 10);

-- Insertar Entregas
INSERT INTO entrega (id_entrega, fecha_entrega, xp_obtenido, calificacion, id_tarea, id_estudiante)
VALUES
(10, GETDATE(), 100, 18.5, 10, 10),
(11, GETDATE(), 150, 19.0, 11, 10),
(12, GETDATE(), 200, 17.0, 12, 11);

-- ===============================================
-- FUNCIONES DE CONSULTA
-- ===============================================

-- FUNCIÓN 1: Ranking de usuarios por curso
CREATE FUNCTION fn_RankingUsuariosPorCurso(@id_curso INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        u.id_usuario,
        u.nombre,
        u.apellido,
        SUM(e.xp_obtenido) AS XP_Total,
        RANK() OVER (ORDER BY SUM(e.xp_obtenido) DESC) AS Ranking
    FROM usuario u
    INNER JOIN estudiante est ON u.id_usuario = est.id_usuario
    INNER JOIN entrega e ON est.id_estudiante = e.id_estudiante
    INNER JOIN tarea t ON e.id_tarea = t.id_tarea
    INNER JOIN seccion s ON t.id_seccion = s.id_seccion
    INNER JOIN curso c ON s.id_curso = c.id_curso
    WHERE c.id_curso = @id_curso
    GROUP BY u.id_usuario, u.nombre, u.apellido
);
GO

-- FUNCIÓN 2: Puntos por tarea
CREATE FUNCTION fn_PuntosPorTarea()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        t.id_tarea,
        t.titulo,
        COUNT(e.id_entrega) AS cantidad_entregas,
        t.xp_base,
        SUM(t.xp_base) AS total_xp_tarea
    FROM tarea t
    LEFT JOIN entrega e ON e.id_tarea = t.id_tarea
    GROUP BY t.id_tarea, t.titulo, t.xp_base
);
GO

-- FUNCIÓN 3: Mejor alumno por curso
CREATE FUNCTION fn_MejorAlumnoPorCurso(@id_curso INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        u.nombre AS nombre_alumno,
        c.nombre_curso AS nombre_curso,
        SUM(t.xp_base) AS total_xp
    FROM curso c
    INNER JOIN seccion s ON s.id_curso = c.id_curso
    INNER JOIN tarea t ON t.id_seccion = s.id_seccion
    INNER JOIN entrega e ON e.id_tarea = t.id_tarea
    INNER JOIN estudiante est ON est.id_estudiante = e.id_estudiante
    INNER JOIN usuario u ON u.id_usuario = est.id_usuario
    WHERE c.id_curso = @id_curso
    GROUP BY u.nombre, c.nombre_curso
);
GO

-- ===============================================
-- CONSULTAS ÚTILES DE EJEMPLO
-- ===============================================

-- Ver ranking de un curso específico
-- SELECT * FROM fn_RankingUsuariosPorCurso(10);

-- Ver puntos por tarea
-- SELECT * FROM fn_PuntosPorTarea();

-- Ver mejor alumno de un curso
-- SELECT * FROM fn_MejorAlumnoPorCurso(10);

-- Obtener XP total por estudiante y curso
-- SELECT 
--     u.id_usuario,
--     u.nombre,
--     u.apellido,
--     c.nombre_curso,
--     SUM(e.xp_obtenido) AS XP_Total
-- FROM usuario u
-- INNER JOIN estudiante est ON u.id_usuario = est.id_usuario
-- INNER JOIN entrega e ON est.id_estudiante = e.id_estudiante
-- INNER JOIN tarea t ON e.id_tarea = t.id_tarea
-- INNER JOIN seccion s ON t.id_seccion = s.id_seccion
-- INNER JOIN curso c ON s.id_curso = c.id_curso
-- GROUP BY u.id_usuario, u.nombre, u.apellido, c.nombre_curso;
