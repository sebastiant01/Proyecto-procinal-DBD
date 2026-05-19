USE Procinal;
GO

-- =============================================================================
-- DEFINICIÓN DE TABLAS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- CIUDAD
-- -----------------------------------------------------------------------------
CREATE TABLE Ciudad (
    id_ciudad          INT PRIMARY KEY,
    nombre             VARCHAR(100) NOT NULL,
    zona_geografica    VARCHAR(100),
    temperatura_media  DECIMAL(5,2)
);

-- -----------------------------------------------------------------------------
-- PUNTO DE VENTA
-- -----------------------------------------------------------------------------
CREATE TABLE PuntoVenta (
    id_punto_venta  INT PRIMARY KEY,
    nombre          VARCHAR(100),
    direccion       VARCHAR(200),
    id_ciudad       INT NOT NULL,
    FOREIGN KEY (id_ciudad) REFERENCES Ciudad(id_ciudad)
);

-- -----------------------------------------------------------------------------
-- EMPLEADO
-- (Se crea antes de Sala porque Sala ahora referencia a Empleado)
-- -----------------------------------------------------------------------------
CREATE TABLE Empleado (
    id_empleado     INT PRIMARY KEY,
    nombre          VARCHAR(100),
    cedula          VARCHAR(20),
    telefono        VARCHAR(20),
    cargo           VARCHAR(50),
    id_punto_venta  INT,
    FOREIGN KEY (id_punto_venta) REFERENCES PuntoVenta(id_punto_venta)
);

-- -----------------------------------------------------------------------------
-- ADMINISTRADOR (SUBTIPO DE EMPLEADO)
-- -----------------------------------------------------------------------------
CREATE TABLE Administrador (
    id_empleado    INT PRIMARY KEY,
    sueldo         DECIMAL(10,2),
    numero_hijos   INT,
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

-- -----------------------------------------------------------------------------
-- SALA
-- Incluye id_empleado (FK) para la relación 1:1 EncargadoDe del MER
-- -----------------------------------------------------------------------------
CREATE TABLE Sala (
    id_sala         INT PRIMARY KEY,
    numero_sala     INT,
    id_punto_venta  INT NOT NULL,
    id_empleado     INT,
    FOREIGN KEY (id_punto_venta) REFERENCES PuntoVenta(id_punto_venta),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);
GO

-- Índice único filtrado: garantiza relación 1:1 solo cuando hay empleado asignado
-- (permite múltiples NULLs en id_empleado para salas VIP sin encargado)
CREATE UNIQUE NONCLUSTERED INDEX UQ_Sala_Empleado
ON Sala (id_empleado)
WHERE id_empleado IS NOT NULL;
GO

-- -----------------------------------------------------------------------------
-- ESPECIALIZACIÓN DE SALAS
-- -----------------------------------------------------------------------------

-- Sala 2D: sala estándar con capacidad definida
CREATE TABLE Sala2D (
    id_sala    INT PRIMARY KEY,
    capacidad  INT,
    FOREIGN KEY (id_sala) REFERENCES Sala(id_sala)
);

-- Sala 3D: sala con tecnología 3D y capacidad definida
CREATE TABLE Sala3D (
    id_sala    INT PRIMARY KEY,
    capacidad  INT,
    FOREIGN KEY (id_sala) REFERENCES Sala(id_sala)
);

-- Sala VIP: sala premium con costo por hora
CREATE TABLE SalaVIP (
    id_sala         INT PRIMARY KEY,
    costo_por_hora  DECIMAL(10,2),
    FOREIGN KEY (id_sala) REFERENCES Sala(id_sala)
);

-- -----------------------------------------------------------------------------
-- DIRECTOR
-- Incluye edad (corrección del profesor al MR optimizado)
-- -----------------------------------------------------------------------------
CREATE TABLE Director (
    id_director       INT PRIMARY KEY,
    nombre            VARCHAR(100),
    edad              INT,
    pais_procedencia  VARCHAR(100)
);

-- -----------------------------------------------------------------------------
-- PELICULA
-- Incluye id_director (FK) — relación 1:N según MR optimizado
-- -----------------------------------------------------------------------------
CREATE TABLE Pelicula (
    id_pelicula  INT PRIMARY KEY,
    titulo       VARCHAR(200),
    genero       VARCHAR(100),
    duracion     INT,
    id_director  INT,
    FOREIGN KEY (id_director) REFERENCES Director(id_director)
);

-- -----------------------------------------------------------------------------
-- ACTOR
-- -----------------------------------------------------------------------------
CREATE TABLE Actor (
    id_actor  INT PRIMARY KEY,
    nombre    VARCHAR(100),
    edad      INT
);

-- -----------------------------------------------------------------------------
-- PROYECCION
-- -----------------------------------------------------------------------------
CREATE TABLE Proyeccion (
    id_proyeccion     INT PRIMARY KEY,
    fecha_proyeccion  DATETIME,
    id_sala           INT,
    id_pelicula       INT,
    FOREIGN KEY (id_sala) REFERENCES Sala(id_sala),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula)
);

-- -----------------------------------------------------------------------------
-- SERVICIO VIP
-- Ya NO tiene FK a PuntoVenta (según MR optimizado)
-- -----------------------------------------------------------------------------
CREATE TABLE ServicioVIP (
    id_servicio      INT PRIMARY KEY,
    nombre_servicio  VARCHAR(100)
);

-- -----------------------------------------------------------------------------
-- RELACIÓN N:M SALA_VIP - SERVICIO_VIP (tabla intermedia según MR optimizado)
-- -----------------------------------------------------------------------------
CREATE TABLE SalaServicio (
    id_sala      INT,
    id_servicio  INT,
    PRIMARY KEY (id_sala, id_servicio),
    FOREIGN KEY (id_sala) REFERENCES SalaVIP(id_sala),
    FOREIGN KEY (id_servicio) REFERENCES ServicioVIP(id_servicio)
);

-- -----------------------------------------------------------------------------
-- RELACIÓN N:M PELICULA - ACTOR
-- -----------------------------------------------------------------------------
CREATE TABLE Protagoniza (
    id_pelicula  INT,
    id_actor     INT,
    PRIMARY KEY (id_pelicula, id_actor),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula),
    FOREIGN KEY (id_actor) REFERENCES Actor(id_actor)
);