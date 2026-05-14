-- ============================================================
-- SCRIPT DE TABLAS DE PRUEBA - SISTEMA PROCINAL
-- Uso: pruebas de instrucciones SQL sin afectar tablas reales
-- ============================================================

-- ============================================================
-- CREACIÓN DE TABLAS DE PRUEBA
-- ============================================================

CREATE TABLE TEST_Ciudad (
    id_ciudad         INTEGER PRIMARY KEY,
    nombre            VARCHAR(100)    NOT NULL,
    zona_geografica   VARCHAR(100)    NOT NULL,
    temperatura_media DECIMAL(10, 2)  NOT NULL
);

CREATE TABLE TEST_PuntoVenta (
    id_punto_venta INTEGER PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    direccion      VARCHAR(200) NOT NULL,
    id_ciudad      INTEGER,
    FOREIGN KEY (id_ciudad) REFERENCES TEST_Ciudad(id_ciudad)
);

CREATE TABLE TEST_Empleado (
    id_empleado    INTEGER PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    cedula         VARCHAR(20)  NOT NULL UNIQUE,
    telefono       VARCHAR(20),
    cargo          VARCHAR(100) NOT NULL,
    id_punto_venta INTEGER,
    FOREIGN KEY (id_punto_venta) REFERENCES TEST_PuntoVenta(id_punto_venta)
);

CREATE TABLE TEST_Sala (
    id_sala        INTEGER PRIMARY KEY,
    numero_sala    INTEGER      NOT NULL,
    tipo           VARCHAR(10)  NOT NULL CHECK (tipo IN ('2D', '3D', 'VIP')),
    capacidad      INTEGER,
    costo_por_hora DECIMAL(10, 2),
    id_punto_venta INTEGER,
    FOREIGN KEY (id_punto_venta) REFERENCES TEST_PuntoVenta(id_punto_venta)
);

CREATE TABLE TEST_Pelicula (
    id_pelicula INTEGER PRIMARY KEY,
    titulo      VARCHAR(200) NOT NULL,
    genero      VARCHAR(100) NOT NULL,
    duracion    INTEGER      NOT NULL
);

CREATE TABLE TEST_Proyeccion (
    id_proyeccion   INTEGER PRIMARY KEY,
    fecha_proyeccion DATE        NOT NULL,
    id_sala          INTEGER,
    id_pelicula      INTEGER,
    FOREIGN KEY (id_sala)    REFERENCES TEST_Sala(id_sala),
    FOREIGN KEY (id_pelicula) REFERENCES TEST_Pelicula(id_pelicula)
);

-- ============================================================
-- INSERCIÓN DE DATOS DE PRUEBA
-- ============================================================

INSERT INTO TEST_Ciudad (id_ciudad, nombre, zona_geografica, temperatura_media) VALUES
(1, 'Ciudad Alpha',   'Zona Norte',  18.50),
(2, 'Ciudad Beta',    'Zona Sur',    22.30),
(3, 'Ciudad Gamma',   'Zona Este',   25.10),
(4, 'Ciudad Delta',   'Zona Oeste',  19.80),
(5, 'Ciudad Epsilon', 'Zona Centro', 27.40);

INSERT INTO TEST_PuntoVenta (id_punto_venta, nombre, direccion, id_ciudad) VALUES
(1, 'Cine Alpha Norte',  'Calle Falsa 123',       1),
(2, 'Cine Beta Sur',     'Avenida Inventada 456', 2),
(3, 'Cine Gamma Este',   'Carrera Test 789',      3),
(4, 'Cine Delta Oeste',  'Transversal Nula 012',  4),
(5, 'Cine Epsilon Centro','Boulevard Demo 345',   5);

INSERT INTO TEST_Empleado (id_empleado, nombre, cedula, telefono, cargo, id_punto_venta) VALUES
(1,  'Empleado Uno',   '100000001', '3001111111', 'Cajero',        1),
(2,  'Empleado Dos',   '100000002', '3002222222', 'Administrador', 1),
(3,  'Empleado Tres',  '100000003', '3003333333', 'Cajero',        2),
(4,  'Empleado Cuatro','100000004', '3004444444', 'Administrador', 2),
(5,  'Empleado Cinco', '100000005', '3005555555', 'Cajero',        3),
(6,  'Empleado Seis',  '100000006', '3006666666', 'Administrador', 3),
(7,  'Empleado Siete', '100000007', '3007777777', 'Cajero',        4),
(8,  'Empleado Ocho',  '100000008', '3008888888', 'Administrador', 4),
(9,  'Empleado Nueve', '100000009', '3009999999', 'Cajero',        5),
(10, 'Empleado Diez',  '100000010', '3000000000', 'Administrador', 5);

INSERT INTO TEST_Sala (id_sala, numero_sala, tipo, capacidad, costo_por_hora, id_punto_venta) VALUES
(1,  1, '2D',  80,   NULL,  1),
(2,  2, '3D',  60,   NULL,  1),
(3,  3, 'VIP', NULL, 50.00, 1),
(4,  1, '2D',  80,   NULL,  2),
(5,  2, '3D',  60,   NULL,  2),
(6,  3, 'VIP', NULL, 60.00, 2),
(7,  1, '2D',  100,  NULL,  3),
(8,  2, '3D',  75,   NULL,  3),
(9,  1, '2D',  90,   NULL,  4),
(10, 2, 'VIP', NULL, 55.00, 4);

INSERT INTO TEST_Pelicula (id_pelicula, titulo, genero, duracion) VALUES
(1, 'Pelicula Alpha',   'Acción',   120),
(2, 'Pelicula Beta',    'Comedia',  95),
(3, 'Pelicula Gamma',   'Drama',    110),
(4, 'Pelicula Delta',   'Terror',   100),
(5, 'Pelicula Epsilon', 'Animación',85),
(6, 'Pelicula Zeta',    'Acción',   130),
(7, 'Pelicula Eta',     'Drama',    115),
(8, 'Pelicula Theta',   'Comedia',  90);

INSERT INTO TEST_Proyeccion (id_proyeccion, fecha_proyeccion, id_sala, id_pelicula) VALUES
(1,  '2025-06-01', 1,  1),
(2,  '2025-06-01', 2,  2),
(3,  '2025-06-02', 4,  3),
(4,  '2025-06-02', 5,  4),
(5,  '2025-06-03', 7,  5),
(6,  '2025-06-03', 8,  6),
(7,  '2025-06-04', 1,  7),
(8,  '2025-06-04', 2,  8),
(9,  '2025-06-05', 4,  1),
(10, '2025-06-05', 9,  2);
