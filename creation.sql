CREATE DATABASE Procinal;
GO

USE Procinal;
GO

-- =========================
-- CIUDAD
-- =========================
CREATE TABLE Ciudad (
    id_ciudad INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    zona_geografica VARCHAR(100),
    temperatura_media DECIMAL(5,2)
);

-- =========================
-- PUNTO DE VENTA
-- =========================
CREATE TABLE PuntoVenta (
    id_punto_venta INT PRIMARY KEY,
    nombre VARCHAR(100),
    direccion VARCHAR(200),
    id_ciudad INT NOT NULL,
    FOREIGN KEY (id_ciudad) REFERENCES Ciudad(id_ciudad)
);

-- =========================
-- SALA
-- =========================
CREATE TABLE Sala (
    id_sala INT PRIMARY KEY,
    numero_sala INT,
    id_punto_venta INT NOT NULL,
    FOREIGN KEY (id_punto_venta) REFERENCES PuntoVenta(id_punto_venta)
);

-- =========================
-- ESPECIALIZACION SALAS
-- =========================

CREATE TABLE Sala2D (
    id_sala INT PRIMARY KEY,
    capacidad INT,
    FOREIGN KEY (id_sala) REFERENCES Sala(id_sala)
);

CREATE TABLE Sala3D (
    id_sala INT PRIMARY KEY,
    capacidad INT,
    FOREIGN KEY (id_sala) REFERENCES Sala(id_sala)
);

CREATE TABLE SalaVIP (
    id_sala INT PRIMARY KEY,
    costo_por_hora DECIMAL(10,2),
    FOREIGN KEY (id_sala) REFERENCES Sala(id_sala)
);

-- =========================
-- EMPLEADO
-- =========================
CREATE TABLE Empleado (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(100),
    cedula VARCHAR(20),
    telefono VARCHAR(20),
    cargo VARCHAR(50),
    id_punto_venta INT,
    FOREIGN KEY (id_punto_venta) REFERENCES PuntoVenta(id_punto_venta)
);

-- =========================
-- ADMINISTRADOR (SUBTIPO)
-- =========================
CREATE TABLE Administrador (
    id_empleado INT PRIMARY KEY,
    sueldo DECIMAL(10,2),
    numero_hijos INT,
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

-- =========================
-- PELICULA
-- =========================
CREATE TABLE Pelicula (
    id_pelicula INT PRIMARY KEY,
    titulo VARCHAR(200),
    genero VARCHAR(100),
    duracion INT
);

-- =========================
-- ACTOR
-- =========================
CREATE TABLE Actor (
    id_actor INT PRIMARY KEY,
    nombre VARCHAR(100),
    edad INT
);

-- =========================
-- DIRECTOR
-- =========================
CREATE TABLE Director (
    id_director INT PRIMARY KEY,
    nombre VARCHAR(100),
    edad INT,
    pais_procedencia VARCHAR(100)
);

-- =========================
-- PROYECCION
-- =========================
CREATE TABLE Proyeccion (
    id_proyeccion INT PRIMARY KEY,
    fecha_proyeccion DATETIME,
    id_sala INT,
    id_pelicula INT,
    FOREIGN KEY (id_sala) REFERENCES Sala(id_sala),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula)
);

-- =========================
-- SERVICIO VIP
-- =========================
CREATE TABLE ServicioVIP (
    id_servicio INT PRIMARY KEY,
    nombre_servicio VARCHAR(100),
    id_punto_venta INT,
    FOREIGN KEY (id_punto_venta) REFERENCES PuntoVenta(id_punto_venta)
);

-- =========================
-- RELACION N:M PELICULA - ACTOR
-- =========================
CREATE TABLE Protagoniza (
    id_pelicula INT,
    id_actor INT,
    PRIMARY KEY (id_pelicula, id_actor),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula),
    FOREIGN KEY (id_actor) REFERENCES Actor(id_actor)
);

-- =========================
-- RELACION DIRECTOR - PELICULA
-- =========================
CREATE TABLE Dirige (
    id_director INT,
    id_pelicula INT,
    PRIMARY KEY (id_director, id_pelicula),
    FOREIGN KEY (id_director) REFERENCES Director(id_director),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula)
);

-- =========================
-- ADMINISTRADOR ENCARGADO DE PUNTO DE VENTA
-- =========================
CREATE TABLE EncargadoDe (
    id_empleado INT,
    id_punto_venta INT,
    PRIMARY KEY (id_empleado, id_punto_venta),
    FOREIGN KEY (id_empleado) REFERENCES Administrador(id_empleado),
    FOREIGN KEY (id_punto_venta) REFERENCES PuntoVenta(id_punto_venta)
);