-- =============================================================================
-- Creado por Grupo #1 - Curso de Desarrollo de Bases de Datos G14 - 2026-1
-- =============================================================================
/*
    Script de creación de la base de datos Procinal.
    Incluye tablas para gestión de cines: ciudades, puntos de venta, salas (2D, 3D, VIP),
    empleados, películas, actores, directores, proyecciones y servicios VIP.
    También contiene inserciones de datos de ejemplo y consultas de verificación.
*/
-- =============================================================================

-- =============================================================================
-- CREACIÓN DE BASE DE DATOS
-- =============================================================================
CREATE DATABASE Procinal;
GO

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
-- SALA
-- -----------------------------------------------------------------------------
CREATE TABLE Sala (
    id_sala         INT PRIMARY KEY,
    numero_sala     INT,
    id_punto_venta  INT NOT NULL,
    FOREIGN KEY (id_punto_venta) REFERENCES PuntoVenta(id_punto_venta)
);

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
-- EMPLEADO
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
-- PELICULA
-- -----------------------------------------------------------------------------
CREATE TABLE Pelicula (
    id_pelicula  INT PRIMARY KEY,
    titulo       VARCHAR(200),
    genero       VARCHAR(100),
    duracion     INT
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
-- DIRECTOR
-- -----------------------------------------------------------------------------
CREATE TABLE Director (
    id_director       INT PRIMARY KEY,
    nombre            VARCHAR(100),
    edad              INT,
    pais_procedencia  VARCHAR(100)
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
-- -----------------------------------------------------------------------------
CREATE TABLE ServicioVIP (
    id_servicio      INT PRIMARY KEY,
    nombre_servicio  VARCHAR(100),
    id_punto_venta   INT,
    FOREIGN KEY (id_punto_venta) REFERENCES PuntoVenta(id_punto_venta)
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

-- -----------------------------------------------------------------------------
-- RELACIÓN DIRECTOR - PELICULA
-- -----------------------------------------------------------------------------
CREATE TABLE Dirige (
    id_director  INT,
    id_pelicula  INT,
    PRIMARY KEY (id_director, id_pelicula),
    FOREIGN KEY (id_director) REFERENCES Director(id_director),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula)
);

-- -----------------------------------------------------------------------------
-- ADMINISTRADOR ENCARGADO DE PUNTO DE VENTA
-- -----------------------------------------------------------------------------
CREATE TABLE EncargadoDe (
    id_empleado     INT,
    id_punto_venta  INT,
    PRIMARY KEY (id_empleado, id_punto_venta),
    FOREIGN KEY (id_empleado) REFERENCES Administrador(id_empleado),
    FOREIGN KEY (id_punto_venta) REFERENCES PuntoVenta(id_punto_venta)
);
GO

-- =============================================================================
-- INSERCIONES DE DATOS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CIUDAD
-- -----------------------------------------------------------------------------
INSERT INTO Ciudad (id_ciudad, nombre, zona_geografica, temperatura_media) 
VALUES
    ( 1, 'Bogotá',        'Andina',    14),
    ( 2, 'Medellín',      'Andina',    22),
    ( 3, 'Cali',          'Pacífica',  24),
    ( 4, 'Barranquilla',  'Caribe',    28),
    ( 5, 'Cartagena',     'Caribe',    29),
    ( 6, 'Bucaramanga',   'Andina',    23),
    ( 7, 'Pereira',       'Andina',    21),
    ( 8, 'Manizales',     'Andina',    17),
    ( 9, 'Santa Marta',   'Caribe',    28),
    (10, 'Cúcuta',        'Andina',    28),
    (11, 'Ibagué',        'Andina',    21),
    (12, 'Pasto',         'Andina',    13),
    (13, 'Villavicencio', 'Orinoquía', 26),
    (14, 'Montería',      'Caribe',    27),
    (15, 'Sincelejo',     'Caribe',    27),
    (16, 'Neiva',         'Andina',    26),
    (17, 'Armenia',       'Andina',    20),
    (18, 'Popayán',       'Andina',    18),
    (19, 'Valledupar',    'Caribe',    29),
    (20, 'Tunja',         'Andina',    12),
    (21, 'Riohacha',      'Caribe',    30),  -- Sin sede asignada (para LEFT JOINs)
    (22, 'Leticia',       'Amazónica', 27);  -- Sin sede asignada

-- -----------------------------------------------------------------------------
-- 2. PUNTO DE VENTA
-- -----------------------------------------------------------------------------
INSERT INTO PuntoVenta (id_punto_venta, nombre, direccion, id_ciudad) 
VALUES
    ( 1, 'Procinal Gran Estación',     'Av. Calle 26 # 62-47',       1),
    ( 2, 'Procinal Andino',            'Carrera 11 # 82-71',         1),
    ( 3, 'Procinal Oviedo',            'Carrera 43A # 6 Sur-15',     2),
    ( 4, 'Procinal El Tesoro',         'Calle 7 Sur # 43-223',       2),
    ( 5, 'Procinal Chipichape',        'Av. 6N # 23A-24',            3),
    ( 6, 'Procinal Cosmocentro',       'Carrera 66 # 3-00',          3),
    ( 7, 'Procinal Buenavista',        'Carrera 52 # 98-99',         4),
    ( 8, 'Procinal Portal del Prado',  'Calle 72 # 57-30',           4),
    ( 9, 'Procinal Caribe Plaza',      'Carrera 42 # 30-30',         5),
    (10, 'Procinal Cabecera',          'Carrera 35 # 54-50',         6),
    (11, 'Procinal Pereira Plaza',     'Carrera 13 # 15-60',         7),
    (12, 'Procinal Cable Plaza',       'Carrera 23 # 64-60',         8),
    (13, 'Procinal Buenavista SMR',    'Calle 22 # 4-76',            9),
    (14, 'Procinal Ventura Plaza',     'Av. Libertadores # 10-30',  10),
    (15, 'Procinal Unicentro Ibagué',  'Carrera 5 # 56-50',         11),
    (16, 'Procinal Campanario',        'Calle 25 # 8-60',           12),
    (17, 'Procinal Viva Villavicencio','Carrera 21 # 35-50',        13),
    (18, 'Procinal Nuestro',           'Calle 29 # 8-80',           14),
    (19, 'Procinal Neiva Plaza',       'Carrera 6 # 22-60',         16),
    (20, 'Procinal Unicentro Armenia', 'Calle 21N # 14-80',         17);

-- -----------------------------------------------------------------------------
-- 3. SALA
-- -----------------------------------------------------------------------------
INSERT INTO Sala (id_sala, numero_sala, id_punto_venta) 
VALUES
    -- Salas 2D (id_sala 1-20)
    ( 1, 1,  1), ( 2, 1,  2), ( 3, 1,  3), ( 4, 1,  4), ( 5, 1,  5),
    ( 6, 1,  6), ( 7, 1,  7), ( 8, 1,  8), ( 9, 1,  9), (10, 1, 10),
    (11, 1, 11), (12, 1, 12), (13, 1, 13), (14, 1, 14), (15, 1, 15),
    (16, 1, 16), (17, 1, 17), (18, 1, 18), (19, 1, 19), (20, 1, 20),

    -- Salas 3D (id_sala 21-40)
    (21, 2,  1), (22, 2,  2), (23, 2,  3), (24, 2,  4), (25, 2,  5),
    (26, 2,  6), (27, 2,  7), (28, 2,  8), (29, 2,  9), (30, 2, 10),
    (31, 2, 11), (32, 2, 12), (33, 2, 13), (34, 2, 14), (35, 2, 15),
    (36, 2, 16), (37, 2, 17), (38, 2, 18), (39, 2, 19), (40, 2, 20),

    -- Salas VIP (id_sala 41-60)
    (41, 3,  1), (42, 3,  2), (43, 3,  3), (44, 3,  4), (45, 3,  5),
    (46, 3,  6), (47, 3,  7), (48, 3,  8), (49, 3,  9), (50, 3, 10),
    (51, 3, 11), (52, 3, 12), (53, 3, 13), (54, 3, 14), (55, 3, 15),
    (56, 3, 16), (57, 3, 17), (58, 3, 18), (59, 3, 19), (60, 3, 20);

-- -----------------------------------------------------------------------------
-- 4. SALAS ESPECIALIZADAS (2D, 3D, VIP)
-- -----------------------------------------------------------------------------

-- Inserción de datos en Sala2D
INSERT INTO Sala2D (id_sala, capacidad) 
VALUES
    ( 1, 120), ( 2, 110), ( 3, 130), ( 4, 115), ( 5, 125),
    ( 6, 120), ( 7, 110), ( 8, 130), ( 9, 115), (10, 120),
    (11, 125), (12, 110), (13, 120), (14, 115), (15, 130),
    (16, 110), (17, 120), (18, 115), (19, 125), (20, 110);

-- Inserción de datos en Sala3D
INSERT INTO Sala3D (id_sala, capacidad) 
VALUES
    (21, 100), (22,  90), (23, 105), (24,  95), (25, 100),
    (26,  90), (27, 100), (28, 105), (29,  95), (30, 100),
    (31,  90), (32, 100), (33,  95), (34, 105), (35,  90),
    (36, 100), (37,  95), (38, 105), (39,  90), (40, 100);

-- Inserción de datos en SalaVIP (costo en pesos colombianos)
INSERT INTO SalaVIP (id_sala, costo_por_hora) 
VALUES
    (41, 80000), (42, 75000), (43, 90000), (44, 70000), (45, 85000),
    (46, 80000), (47, 75000), (48, 90000), (49, 70000), (50, 85000),
    (51, 80000), (52, 75000), (53, 90000), (54, 70000), (55, 85000),
    (56, 80000), (57, 75000), (58, 90000), (59, 70000), (60, 85000);

-- -----------------------------------------------------------------------------
-- 5. SERVICIO VIP
-- -----------------------------------------------------------------------------
INSERT INTO ServicioVIP (id_servicio, nombre_servicio, id_punto_venta) 
VALUES
    ( 1, 'Butacas reclinables',                1),
    ( 2, 'Servicio de mesero',                 2),
    ( 3, 'Menú gourmet',                       3),
    ( 4, 'Sonido Dolby Atmos',                 4),
    ( 5, 'Pantalla 4K OLED',                   5),
    ( 6, 'Cocteles con alcohol',               6),
    ( 7, 'Manta y almohada',                   7),
    ( 8, 'Minibar en butaca',                  8),
    ( 9, 'Estacionamiento VIP',                9),
    (10, 'Check-in preferencial',             10),
    (11, 'WiFi exclusivo',                    11),
    (12, 'Snacks premium',                    12),
    (13, 'Sala de espera privada',            13),
    (14, 'Iluminación ambiental',             14),
    (15, 'Temperatura personalizada',         15),
    (16, 'Cargador inalámbrico en butaca',    16),
    (17, 'Silla de masajes',                  17),
    (18, 'Auriculares cancelación de ruido',  18),
    (19, 'Cocteles sin alcohol',              19),
    (20, 'Acceso a sala de juegos pre-función', 20);

-- -----------------------------------------------------------------------------
-- 6. EMPLEADO
-- -----------------------------------------------------------------------------
INSERT INTO Empleado (id_empleado, nombre, cedula, telefono, cargo, id_punto_venta) 
VALUES
    ( 1, 'Laura Martínez',    '1001001001', '3201112233', 'Administrador',  1),
    ( 2, 'Carlos Rodríguez',  '1001001002', '3202223344', 'Cajero',         1),
    ( 3, 'Ana Gómez',         '1001001003', '3203334455', 'Administrador',  2),
    ( 4, 'Pedro Sánchez',     '1001001004', '3204445566', 'Operador',       2),
    ( 5, 'Sofía Herrera',     '1001001005', '3205556677', 'Administrador',  3),
    ( 6, 'Juan Díaz',         '1001001006', '3206667788', 'Cajero',         3),
    ( 7, 'Valentina López',   '1001001007', '3207778899', 'Administrador',  4),
    ( 8, 'Andrés Torres',     '1001001008', '3208889900', 'Operador',       4),
    ( 9, 'Daniela Vargas',    '1001001009', '3209990011', 'Administrador',  5),
    (10, 'Miguel Ríos',       '1001001010', '3210001122', 'Cajero',         5),
    (11, 'Camila Moreno',     '1001001011', '3211112233', 'Administrador',  6),
    (12, 'Santiago Castro',   '1001001012', '3212223344', 'Operador',       6),
    (13, 'Natalia Jiménez',   '1001001013', '3213334455', 'Administrador',  7),
    (14, 'Felipe Ruiz',       '1001001014', '3214445566', 'Cajero',         7),
    (15, 'Isabella Mendoza',  '1001001015', '3215556677', 'Administrador',  8),
    (16, 'Sebastián Navarro', '1001001016', '3216667788', 'Operador',       8),
    (17, 'Mariana Peña',      '1001001017', '3217778899', 'Administrador',  9),
    (18, 'Julián Ramírez',    '1001001018', '3218889900', 'Cajero',         9),
    (19, 'Valeria Suárez',    '1001001019', '3219990011', 'Administrador', 10),
    (20, 'Tomás Álvarez',     '1001001020', '3220001122', 'Operador',      10),
    (21, 'Lucía Ortega',      '1001001021', '3221112233', 'Administrador', 11),
    (22, 'Diego Flores',      '1001001022', '3222223344', 'Cajero',        11),
    (23, 'Gabriela Reyes',    '1001001023', '3223334455', 'Administrador', 12),
    (24, 'Mateo Guerrero',    '1001001024', '3224445566', 'Operador',      12),
    (25, 'Sara Medina',       '1001001025', '3225556677', 'Administrador', 13),
    (26, 'Andrés Castillo',   '1001001026', '3226667788', 'Cajero',        13),
    (27, 'Paola Bermúdez',    '1001001027', '3227778899', 'Administrador', 14),
    (28, 'Ricardo Lozano',    '1001001028', '3228889900', 'Operador',      14),
    (29, 'Diana Ospina',      '1001001029', '3229990011', 'Administrador', 15),
    (30, 'Héctor Palacios',   '1001001030', '3230001122', 'Cajero',        15),
    (31, 'Mónica Agudelo',    '1001001031', '3231112233', 'Administrador', 16),
    (32, 'Esteban Cárdenas',  '1001001032', '3232223344', 'Operador',      16),
    (33, 'Alejandra Muñoz',   '1001001033', '3233334455', 'Administrador', 17),
    (34, 'Camilo Pedraza',    '1001001034', '3234445566', 'Cajero',        17),
    (35, 'Fernanda Cano',     '1001001035', '3235556677', 'Administrador', 18),
    (36, 'Sebastián Gil',     '1001001036', '3236667788', 'Operador',      18),
    (37, 'Juliana Prada',     '1001001037', '3237778899', 'Administrador', 19),
    (38, 'Nicolás Vega',      '1001001038', '3238889900', 'Cajero',        19),
    (39, 'Felipe Arango',     '1001001039', '3239990011', 'Administrador', 20),
    (40, 'Daniela Quintero',  '1001001040', '3240001122', 'Operador',      20);

-- -----------------------------------------------------------------------------
-- 7. ADMINISTRADOR
-- -----------------------------------------------------------------------------
INSERT INTO Administrador (id_empleado, sueldo, numero_hijos) 
VALUES
    ( 1, 4800000, 1), ( 3, 4900000, 0), ( 5, 5100000, 2), ( 7, 4750000, 1),
    ( 9, 5200000, 3), (11, 4850000, 0), (13, 5000000, 2), (15, 4700000, 1),
    (17, 5300000, 0), (19, 4950000, 2), (21, 5050000, 1), (23, 4800000, 0),
    (25, 5150000, 3), (27, 4600000, 0), (29, 4650000, 1), (31, 4700000, 2),
    (33, 4550000, 0), (35, 4850000, 1), (37, 4750000, 0), (39, 4680000, 2);

-- -----------------------------------------------------------------------------
-- 8. PELICULA
-- -----------------------------------------------------------------------------
INSERT INTO Pelicula (id_pelicula, titulo, genero, duracion) 
VALUES
    ( 1, 'Inception',                'Ciencia Ficción', 148),
    ( 2, 'Interstellar',             'Ciencia Ficción', 169),
    ( 3, 'Jurassic Park',            'Aventura',        127),
    ( 4, 'Schindler''s List',        'Drama',           195),
    ( 5, 'Pulp Fiction',             'Thriller',        154),
    ( 6, 'Django Unchained',         'Western',         165),
    ( 7, 'The Departed',             'Crimen',          151),
    ( 8, 'Avatar',                   'Ciencia Ficción', 162),
    ( 9, 'Gladiator',                'Acción',          155),
    (10, 'Blade Runner 2049',        'Ciencia Ficción', 164),
    (11, 'Dune',                     'Ciencia Ficción', 155),
    (12, 'El laberinto del fauno',   'Fantasía',        118),
    (13, 'Roma',                     'Drama',           135),
    (14, 'Parásitos',                'Thriller',        132),
    (15, 'Volver',                   'Drama',           121),
    (16, 'Birdman',                  'Comedia',         119),
    (17, 'El Padrino',               'Crimen',          175),
    (18, 'Se7en',                    'Thriller',        127),
    (19, 'The Grand Budapest Hotel', 'Comedia',         100),
    (20, 'El club de la pelea',      'Thriller',        139),
    (21, 'Requiem for a Dream',      'Drama',           102),  -- Sin proyecciones
    (22, 'Beetlejuice',              'Comedia',          92);  -- Sin proyecciones

-- -----------------------------------------------------------------------------
-- 9. ACTOR
-- -----------------------------------------------------------------------------
INSERT INTO Actor (id_actor, nombre, edad) 
VALUES
    ( 1, 'Leonardo DiCaprio',  49),
    ( 2, 'Cillian Murphy',     48),
    ( 3, 'Uma Thurman',        54),
    ( 4, 'Jamie Foxx',         56),
    ( 5, 'Jeff Goldblum',      72),
    ( 6, 'Liam Neeson',        72),
    ( 7, 'Russell Crowe',      60),
    ( 8, 'Ryan Gosling',       43),
    ( 9, 'Timothée Chalamet',  29),
    (10, 'Doug Jones',         64),
    (11, 'Cate Blanchett',     55),
    (12, 'Song Kang-ho',       57),
    (13, 'Marlon Brando',      80),
    (14, 'Brad Pitt',          61),
    (15, 'Edward Norton',      55),
    (16, 'Tom Hanks',          68),
    (17, 'Meryl Streep',       75),
    (18, 'Michael Keaton',     73),
    (19, 'Ralph Fiennes',      62),
    (20, 'Matt Damon',         53);

-- -----------------------------------------------------------------------------
-- 10. DIRECTOR
-- -----------------------------------------------------------------------------
INSERT INTO Director (id_director, nombre, edad, pais_procedencia) 
VALUES
    ( 1, 'Christopher Nolan',     54, 'Reino Unido'),
    ( 2, 'Steven Spielberg',      77, 'Estados Unidos'),
    ( 3, 'Quentin Tarantino',     61, 'Estados Unidos'),
    ( 4, 'Martin Scorsese',       82, 'Estados Unidos'),
    ( 5, 'James Cameron',         70, 'Canadá'),
    ( 6, 'Ridley Scott',          86, 'Reino Unido'),
    ( 7, 'Denis Villeneuve',      57, 'Canadá'),
    ( 8, 'Guillermo del Toro',    60, 'México'),
    ( 9, 'Alfonso Cuarón',        62, 'México'),
    (10, 'Bong Joon-ho',          55, 'Corea del Sur'),
    (11, 'Pedro Almodóvar',       75, 'España'),
    (12, 'Alejandro G. Iñárritu', 57, 'México'),
    (13, 'Francis Ford Coppola',  85, 'Estados Unidos'),
    (14, 'David Lynch',           78, 'Estados Unidos'),
    (15, 'David Fincher',         62, 'Estados Unidos'),
    (16, 'Wes Anderson',          55, 'Estados Unidos'),
    (17, 'Tim Burton',            66, 'Estados Unidos'),
    (18, 'Robert Zemeckis',       73, 'Estados Unidos'),
    (19, 'Ron Howard',            71, 'Estados Unidos'),
    (20, 'Darren Aronofsky',      55, 'Estados Unidos');

-- -----------------------------------------------------------------------------
-- 11. PROYECCION
-- -----------------------------------------------------------------------------
INSERT INTO Proyeccion (id_proyeccion, fecha_proyeccion, id_sala, id_pelicula) 
VALUES
    ( 1, '2026-03-09 14:00',  1,  1), ( 2, '2026-03-09 17:00', 21,  2),
    ( 3, '2026-03-09 20:00',  2,  3), ( 4, '2026-03-10 14:00', 22,  4),
    ( 5, '2026-03-10 17:00',  3,  5), ( 6, '2026-03-10 20:00', 23,  6),
    ( 7, '2026-03-11 14:00',  4,  7), ( 8, '2026-03-11 17:00', 24,  8),
    ( 9, '2026-03-11 20:00',  5,  9), (10, '2026-03-12 14:00', 25, 10),
    (11, '2026-03-12 17:00',  6, 11), (12, '2026-03-12 20:00', 26, 12),
    (13, '2026-03-13 14:00',  7, 13), (14, '2026-03-13 17:00', 27, 14),
    (15, '2026-03-13 20:00',  8, 15), (16, '2026-03-14 14:00', 28, 16),
    (17, '2026-03-14 17:00',  9, 17), (18, '2026-03-14 20:00', 29, 18),
    (19, '2026-03-15 14:00', 10, 19), (20, '2026-03-15 17:00', 30, 20),
    (21, '2026-03-15 20:00',  1,  1), (22, '2026-03-16 14:00', 21,  5),
    (23, '2026-03-16 17:00',  2, 10), (24, '2026-03-16 20:00', 22, 14),
    (25, '2026-03-17 14:00',  3, 17);

-- -----------------------------------------------------------------------------
-- 12. PROTAGONIZA (RELACIÓN PELICULA - ACTOR)
-- -----------------------------------------------------------------------------
INSERT INTO dbo.Protagoniza (id_pelicula, id_actor) 
VALUES
    ( 1,  1), ( 2,  2), ( 3,  5), ( 4,  6), ( 5,  3),
    ( 6,  4), ( 7, 20), ( 8,  1), ( 9,  7), (10,  8),
    (11,  9), (12, 10), (13, 11), (14, 12), (15, 17),
    (16, 18), (17, 13), (18, 14), (19, 19), (20, 15);

-- -----------------------------------------------------------------------------
-- 13. DIRIGE (RELACIÓN DIRECTOR - PELICULA)
-- -----------------------------------------------------------------------------
INSERT INTO dbo.Dirige (id_director, id_pelicula) 
VALUES
    ( 1,  1), ( 1,  2), ( 2,  3), ( 2,  4), ( 3,  5),
    ( 3,  6), ( 4,  7), ( 5,  8), ( 6,  9), ( 7, 10),
    ( 7, 11), ( 8, 12), ( 9, 13), (10, 14), (11, 15),
    (12, 16), (13, 17), (15, 18), (15, 20), (16, 19),
    (20, 21), (17, 22);

-- -----------------------------------------------------------------------------
-- 14. ENCARGADO DE (RELACIÓN ADMINISTRADOR - PUNTO VENTA)
-- -----------------------------------------------------------------------------
INSERT INTO EncargadoDe (id_empleado, id_punto_venta) 
VALUES
    ( 1,  1), ( 3,  2), ( 5,  3), ( 7,  4), ( 9,  5),
    (11,  6), (13,  7), (15,  8), (17,  9), (19, 10),
    (21, 11), (23, 12), (25, 13), (27, 14), (29, 15),
    (31, 16), (33, 17), (35, 18), (37, 19), (39, 20);
GO

-- =============================================================================
-- CONSULTAS DE ANÁLISIS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Géneros con más de una proyección programada
-- Álgebra relacional:
-- τ_(total DESC) (σ_(total > 1) (γ_(genero; COUNT(id_proyeccion)→total, AVG(duracion)→prom) 
--   (σ_(genero≠NULL)(Pelicula) ⋈ Proyeccion)))
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    P.genero,
    COUNT(PR.id_proyeccion)  AS total_proyecciones,
    AVG(P.duracion)          AS duracion_promedio_min
FROM Pelicula P
    INNER JOIN Proyeccion PR ON PR.id_pelicula = P.id_pelicula
WHERE P.genero IS NOT NULL
GROUP BY P.genero
HAVING COUNT(PR.id_proyeccion) > 1
ORDER BY total_proyecciones DESC;
GO

-- -----------------------------------------------------------------------------
-- Directores con más de una película dirigida
-- Álgebra relacional:
-- τ_(total DESC, nombre ASC) (σ_(total > 1) (γ_(nombre, pais; COUNT(id_pelicula)→total) 
--   (σ_(pais≠NULL)(Director) ⋈ Dirige)))
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    D.nombre                 AS director,
    D.pais_procedencia,
    COUNT(DG.id_pelicula)    AS peliculas_dirigidas
FROM Director D
    INNER JOIN Dirige DG ON DG.id_director = D.id_director
WHERE D.pais_procedencia IS NOT NULL
GROUP BY D.nombre, D.pais_procedencia
HAVING COUNT(DG.id_pelicula) > 1
ORDER BY peliculas_dirigidas DESC, D.nombre ASC;
GO

-- -----------------------------------------------------------------------------
-- Capacidad promedio de salas 2D por ciudad (promedio > 115)
-- Álgebra relacional:
-- T1 ← Ciudad ⋈ PuntoVenta ⋈ Sala ⋈ Sala2D
-- T2 ← γ_(C.nombre; COUNT(id_sala)→total, AVG(capacidad)→prom) (T1)
-- Resultado ← τ_(prom DESC) (σ_(prom > 115) (T2))
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    C.nombre            AS ciudad,
    COUNT(S2.id_sala)   AS total_salas_2D,
    AVG(S2.capacidad)   AS capacidad_promedio
FROM Ciudad C
    INNER JOIN PuntoVenta PV ON PV.id_ciudad     = C.id_ciudad
    INNER JOIN Sala S        ON S.id_punto_venta = PV.id_punto_venta
    INNER JOIN Sala2D S2     ON S2.id_sala       = S.id_sala
GROUP BY C.nombre
HAVING AVG(S2.capacidad) > 115  -- Umbral mínimo de capacidad promedio
ORDER BY capacidad_promedio DESC;
GO

-- -----------------------------------------------------------------------------
-- Puntos de venta con costo VIP promedio mayor a $78.000
-- Álgebra relacional:
-- T1 ← σ_(costo>0) (PuntoVenta ⋈ Ciudad ⋈ Sala ⋈ SalaVIP)
-- T2 ← γ_(PV.nombre, C.nombre; COUNT→salas, AVG(costo)→prom) (T1)
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    PV.nombre                AS punto_venta,
    C.nombre                 AS ciudad,
    COUNT(SV.id_sala)        AS salas_vip,
    AVG(SV.costo_por_hora)   AS costo_promedio_hora
FROM PuntoVenta PV
    INNER JOIN Ciudad C    ON C.id_ciudad      = PV.id_ciudad
    INNER JOIN Sala S      ON S.id_punto_venta = PV.id_punto_venta
    INNER JOIN SalaVIP SV  ON SV.id_sala       = S.id_sala
WHERE SV.costo_por_hora > 0
GROUP BY PV.nombre, C.nombre
HAVING AVG(SV.costo_por_hora) > 78000  -- Umbral mínimo en pesos colombianos
ORDER BY costo_promedio_hora DESC;
GO

-- -----------------------------------------------------------------------------
-- Administradores con sueldo mayor al promedio general
-- Álgebra relacional:
-- Prom ← γ_(AVG(sueldo)→media) (Administrador)
-- T1 ← Empleado ⋈ Administrador ⋈ PuntoVenta
-- T2 ← σ_(sueldo > Prom.media) (T1)
-- Resultado ← τ_(sueldo DESC) (π_(nombre, PV.nombre, sueldo, numero_hijos) (T2))
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    E.nombre        AS empleado,
    PV.nombre       AS punto_venta,
    A.sueldo,
    A.numero_hijos
FROM Empleado E
    INNER JOIN Administrador A ON A.id_empleado     = E.id_empleado
    INNER JOIN PuntoVenta PV   ON PV.id_punto_venta = E.id_punto_venta
WHERE A.sueldo > (SELECT AVG(sueldo) FROM Administrador)
GROUP BY E.nombre, PV.nombre, A.sueldo, A.numero_hijos
HAVING A.sueldo = MAX(A.sueldo)
ORDER BY A.sueldo DESC;
GO

-- =============================================================================
-- CONSULTAS CON DIFERENTES TIPOS DE JOIN
-- =============================================================================

-- -----------------------------------------------------------------------------
-- INNER JOIN: Películas y sus actores protagonistas
-- Álgebra relacional:
-- π_(P.titulo, P.genero, A.nombre, A.edad)
--     (Pelicula P ⋈_(P.id_pelicula=PR.id_pelicula) Protagoniza PR
--         ⋈_(PR.id_actor=A.id_actor) Actor A)
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    P.titulo        AS pelicula,
    P.genero,
    A.nombre        AS actor_protagonista,
    A.edad          AS edad_actor
FROM Pelicula P
    INNER JOIN Protagoniza PR ON PR.id_pelicula = P.id_pelicula
    INNER JOIN Actor A        ON A.id_actor     = PR.id_actor
ORDER BY P.titulo;
GO

-- -----------------------------------------------------------------------------
-- LEFT JOIN: Todas las ciudades, aunque no tengan sede Procinal
-- Álgebra relacional:
-- π_(C.nombre, C.zona_geografica, PV.nombre, PV.direccion)
--     (Ciudad C ⟕_(C.id_ciudad=PV.id_ciudad) PuntoVenta PV)
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    C.nombre            AS ciudad,
    C.zona_geografica,
    PV.nombre           AS punto_venta,
    PV.direccion
FROM Ciudad C
    LEFT JOIN PuntoVenta PV ON PV.id_ciudad = C.id_ciudad
ORDER BY C.nombre;
GO

-- -----------------------------------------------------------------------------
-- RIGHT JOIN: Todos los puntos de venta y su administrador encargado
-- Álgebra relacional:
-- π_(E.nombre, A.sueldo, PV.nombre, C.nombre)
--     ((Empleado E ⋈ Administrador A) ⟖_(A.id_empleado=ED.id_empleado) EncargadoDe ED
--         ⟖_(ED.id_punto_venta=PV.id_punto_venta) PuntoVenta PV ⋈ Ciudad C)
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    E.nombre                AS administrador,
    A.sueldo,
    PV.nombre               AS punto_venta,
    C.nombre                AS ciudad
FROM Empleado E
    INNER JOIN Administrador A  ON A.id_empleado     = E.id_empleado
    RIGHT JOIN EncargadoDe ED   ON ED.id_empleado    = A.id_empleado
    RIGHT JOIN PuntoVenta PV    ON PV.id_punto_venta = ED.id_punto_venta
    INNER JOIN Ciudad C         ON C.id_ciudad       = PV.id_ciudad
ORDER BY PV.nombre;
GO

-- -----------------------------------------------------------------------------
-- FULL JOIN: Todas las películas y todas las proyecciones
-- Álgebra relacional:
-- π_(P.titulo, P.genero, PR.id_proyeccion, PR.fecha_proyeccion)
--     (Pelicula P ⟗_(P.id_pelicula=PR.id_pelicula) Proyeccion PR)
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    P.titulo            AS pelicula,
    P.genero,
    PR.id_proyeccion,
    PR.fecha_proyeccion
FROM Pelicula P
    FULL JOIN Proyeccion PR ON PR.id_pelicula = P.id_pelicula
ORDER BY P.titulo, PR.fecha_proyeccion;
GO

-- -----------------------------------------------------------------------------
-- CROSS JOIN: Combinación total entre géneros y zonas geográficas
-- Álgebra relacional:
-- G ← π_(genero) (σ_(genero≠NULL) (Pelicula))
-- Z ← π_(zona_geografica) (σ_(zona_geografica≠NULL) (Ciudad))
-- Resultado ← τ_(genero, zona_geografica) (G × Z)
-- -----------------------------------------------------------------------------
USE Procinal;
GO

SELECT
    G.genero,
    Z.zona_geografica,
    CONCAT(G.genero, ' - ', Z.zona_geografica) AS combinacion
FROM
    (SELECT DISTINCT genero
     FROM Pelicula
     WHERE genero IS NOT NULL) G
    CROSS JOIN
    (SELECT DISTINCT zona_geografica
     FROM Ciudad
     WHERE zona_geografica IS NOT NULL) Z
ORDER BY G.genero, Z.zona_geografica;
GO

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
GO

-- =============================================================================
-- ELIMINACIÓN DE DATOS Y ESTRUCTURA
-- =============================================================================

-- Eliminación de un registro específico de la tabla Actor
-- Se elimina el actor con id_actor = 16 (Tom Hanks) - sin películas asignadas en Protagoniza
DELETE FROM dbo.Actor 
WHERE id_actor = 16;  -- 16 = Tom Hanks (único actor sin dependencias)
GO

-- Eliminación de la columna zona_geografica de la tabla Ciudad
-- Esta columna es opcional (nullable) y no tiene dependencias de FK
ALTER TABLE dbo.Ciudad 
DROP COLUMN zona_geografica;
GO

-- =============================================================================
-- VERIFICACIONES DE ELIMINACIÓN
-- =============================================================================

-- 5. Verificar que el registro del actor fue eliminado correctamente
-- Si no retorna filas, la eliminación fue exitosa
SELECT id_actor, nombre, edad
FROM dbo.Actor
WHERE id_actor = 16;
GO

-- 6. Verificar que la columna zona_geografica fue eliminada de Ciudad
-- Si no retorna filas, la columna ya no existe
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'Ciudad'
  AND COLUMN_NAME = 'zona_geografica';
GO
