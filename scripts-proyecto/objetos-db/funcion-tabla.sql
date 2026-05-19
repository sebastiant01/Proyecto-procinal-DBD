USE Procinal
GO

CREATE OR ALTER FUNCTION dbo.fn_EmpleadosPorPuntoVenta
(
    @id_punto_venta INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        e.id_empleado,
        e.nombre                    AS nombre_empleado,
        e.cedula,
        e.telefono,
        e.cargo,
        s.numero_sala               AS sala_asignada,
        pv.nombre                   AS punto_venta,
        c.nombre                    AS ciudad
    FROM dbo.Empleado e
        JOIN dbo.Sala        s  ON e.id_empleado        = s.id_empleado
        JOIN dbo.PuntoVenta  pv ON e.id_punto_venta  = pv.id_punto_venta
        JOIN dbo.Ciudad      c  ON pv.id_ciudad      = c.id_ciudad
    WHERE e.id_punto_venta = @id_punto_venta
);

SELECT * FROM dbo.fn_EmpleadosPorPuntoVenta(1);