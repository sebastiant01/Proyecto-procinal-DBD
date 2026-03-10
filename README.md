# Procinal — Base de Datos de Cadena de Cines

> Proyecto académico del curso **Desarrollo de Bases de Datos G14 — 2026-1** (Grupo #1).

## Descripción

Este repositorio contiene el diseño, implementación y consultas SQL de la base de datos **Procinal**, que modela la operación de una cadena de cines en Colombia. Abarca desde la definición del esquema relacional normalizado en **Tercera Forma Normal (3FN)** hasta la inserción de datos de prueba y un conjunto de consultas analíticas.

---

## Estructura del repositorio

```
├── procinal.sql                        # Script completo: DDL + datos + consultas
├── README.md                           # Este archivo
└── modelos/
    ├── cine.erdplus                    # Modelo Entidad-Relación (MER) original
    ├── Cine-MR.erdplus                 # Modelo Relacional (MR) inicial
    └── Cine-MR-Actualizado.erdplus     # MR optimizado según 3FN (versión final)
```

Los archivos `.erdplus` se abren con [ERDPlus](https://erdplus.com/).

---

## Modelo de datos

### Entidades principales

| Entidad | Descripción |
|---|---|
| **Ciudad** | Ciudades colombianas donde operan sedes. |
| **PuntoVenta** | Sedes/cines de Procinal, vinculados a una ciudad. |
| **Empleado** | Personal de cada sede (cajeros, operadores, administradores). |
| **Administrador** | Subtipo de Empleado con sueldo y número de hijos. |
| **Sala** | Sala de proyección perteneciente a un punto de venta. |
| **Sala2D / Sala3D / SalaVIP** | Especialización de salas (herencia). |
| **Director** | Directores de cine. |
| **Pelicula** | Catálogo de películas con género, duración y director. |
| **Actor** | Actores que protagonizan películas. |
| **Proyeccion** | Funciones programadas (película + sala + fecha/hora). |
| **ServicioVIP** | Servicios premium ofrecidos en salas VIP. |

### Relaciones clave

| Relación | Tipo | Implementación |
|---|---|---|
| Director → Película | 1:N | FK `id_director` en `Pelicula` |
| Película ↔ Actor | N:M | Tabla intermedia `Protagoniza` |
| SalaVIP ↔ ServicioVIP | N:M | Tabla intermedia `SalaServicio` |
| Sala → Empleado (encargado) | 1:1 | FK `id_empleado` en `Sala` con restricción `UNIQUE` |
| PuntoVenta → Ciudad | N:1 | FK `id_ciudad` en `PuntoVenta` |
| Sala → PuntoVenta | N:1 | FK `id_punto_venta` en `Sala` |
| Empleado → PuntoVenta | N:1 | FK `id_punto_venta` en `Empleado` |

### Diagrama relacional simplificado

```
Ciudad 1──N PuntoVenta 1──N Sala ──┬── Sala2D
                │                  ├── Sala3D
                │                  └── SalaVIP ──N:M── ServicioVIP
                │                       │
                └──N Empleado ──1:1─────┘
                       │
                       └── Administrador (subtipo)

Director 1──N Pelicula N:M Actor
                  │
             Proyeccion (Pelicula + Sala + Fecha)
```

---

## Normalización y decisiones de diseño (3FN)

El MR fue optimizado a **Tercera Forma Normal** aplicando las siguientes correcciones al diseño original:

| # | Cambio | Justificación |
|---|---|---|
| 1 | `Pelicula` tiene `id_director` (FK) directamente | La relación Director→Película es 1:N, no N:M. Se elimina la tabla `Dirige`. |
| 2 | `Sala` tiene `id_empleado` (FK) con `UNIQUE` | La relación EncargadoDe es 1:1. Se elimina la tabla `EncargadoDe`. |
| 3 | `ServicioVIP` ya no tiene FK a `PuntoVenta` | El servicio es independiente del punto de venta; la asociación se hace a través de `SalaServicio`. |
| 4 | Se crea `SalaServicio` (tabla intermedia) | Relación N:M entre `SalaVIP` y `ServicioVIP`. |
| 5 | `Director` conserva campo `edad` | Corrección indicada por el profesor. |

---

## Datos de prueba

El script incluye datos realistas para probar las consultas:

| Tabla | Registros | Datos representativos |
|---|---|---|
| Ciudad | 22 | Ciudades colombianas (incluye 2 sin sede para pruebas de LEFT JOIN) |
| PuntoVenta | 20 | Sedes reales de Procinal en distintas ciudades |
| Empleado | 40 | 2 empleados por sede (admin + cajero/operador) |
| Administrador | 20 | Todos los empleados con cargo "Administrador" |
| Sala | 60 | 20 salas 2D + 20 salas 3D + 20 salas VIP |
| Director | 20 | Directores reconocidos internacionalmente |
| Pelicula | 22 | Películas de diversos géneros |
| Actor | 20 | Actores de Hollywood y cine internacional |
| Proyeccion | 25 | Funciones programadas entre el 9 y 17 de marzo de 2026 |
| ServicioVIP | 20 | Servicios premium (butacas reclinables, Dolby Atmos, etc.) |
| SalaServicio | 60 | Asignaciones de servicios a salas VIP |
| Protagoniza | 20 | Relación película–actor |

---

## Consultas incluidas

El script contiene consultas organizadas en tres bloques:

### 1. Consultas analíticas con `GROUP BY` / `HAVING`

- Géneros con más de una proyección programada.
- Directores con más de una película dirigida.
- Capacidad promedio de salas 2D por ciudad (filtro > 115).
- Puntos de venta con costo VIP promedio mayor a $78.000.
- Administradores con sueldo superior al promedio general.

### 2. Consultas con diferentes tipos de `JOIN`

| Tipo | Propósito |
|---|---|
| `INNER JOIN` | Películas y sus actores protagonistas. |
| `LEFT JOIN` | Todas las ciudades, incluso sin sede Procinal. |
| `RIGHT JOIN` | Puntos de venta y su empleado encargado de sala. |
| `FULL JOIN` | Todas las películas y todas las proyecciones (incluidas sin cruce). |
| `CROSS JOIN` | Combinación de géneros × zonas geográficas. |

### 3. Operaciones DML y DDL de manipulación

- `UPDATE` — Renombrar película (*Inception → Inception: El Origen*).
- `ALTER TABLE DROP COLUMN` — Eliminar `temperatura_media` de `Ciudad`.
- `ALTER TABLE ALTER COLUMN` — Ampliar `cargo` de `VARCHAR(50)` a `VARCHAR(100)`.
- `ALTER TABLE ADD` — Agregar columna `clasificacion` a `Pelicula`.
- `DELETE` — Eliminar un actor sin relaciones (Tom Hanks, id 16).
- Verificaciones de cada operación con consultas a `INFORMATION_SCHEMA`.

---

## Requisitos

- **SQL Server** 2016 o superior (el script usa `GO` como separador de lotes).
- Herramienta cliente: SQL Server Management Studio (SSMS), Azure Data Studio, o cualquier cliente compatible con T-SQL.
- [ERDPlus](https://erdplus.com/) para visualizar los modelos `.erdplus`.

## Ejecución

1. Abrir el archivo `procinal.sql` en SSMS o Azure Data Studio.
2. Ejecutar el script completo — creará la base de datos `Procinal`, todas las tablas, insertará los datos y ejecutará las consultas.
3. Para explorar los modelos, importar los archivos de `modelos/` en [erdplus.com](https://erdplus.com/).

---

## Autores

**Grupo #1** — Curso de Desarrollo de Bases de Datos G14, 2026-1
