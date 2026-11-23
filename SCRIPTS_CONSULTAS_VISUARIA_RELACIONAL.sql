USE Visuara;
GO

PRINT N'CONSULTA 01 - Ultima ubicacion conocida de cada objeto';
SELECT
    o.id_objeto,
    o.nombre_objeto,
    COALESCE(a.nombre_ambiente, N'Sin detecciones') AS ultima_ubicacion,
    CONCAT(u.nombre, N' ', u.apellido) AS usuario_escaneo,
    ultima.fecha_hora AS ultima_deteccion,
    ultima.porcentaje_certeza
FROM dbo.Objeto AS o
OUTER APPLY (
    SELECT TOP (1)
        e.id_ambiente,
        e.id_usuario,
        e.fecha_hora,
        d.porcentaje_certeza
    FROM dbo.Deteccion AS d
    INNER JOIN dbo.Escaneo AS e
        ON d.id_escaneo = e.id_escaneo
    WHERE d.id_objeto = o.id_objeto
    ORDER BY e.fecha_hora DESC, d.id_deteccion DESC
) AS ultima
LEFT JOIN dbo.Ambiente AS a
    ON ultima.id_ambiente = a.id_ambiente
LEFT JOIN dbo.Usuario AS u
    ON ultima.id_usuario = u.id_usuario
ORDER BY o.nombre_objeto;
GO

PRINT N'CONSULTA 02 - Historial de ubicaciones de un objeto';
SELECT
    o.id_objeto,
    o.nombre_objeto,
    a.nombre_ambiente,
    e.fecha_hora,
    d.porcentaje_certeza,
    h.fecha_registro
FROM dbo.HistorialUbicacion AS h
INNER JOIN dbo.Objeto AS o
    ON h.id_objeto = o.id_objeto
INNER JOIN dbo.Deteccion AS d
    ON h.id_deteccion = d.id_deteccion
INNER JOIN dbo.Escaneo AS e
    ON d.id_escaneo = e.id_escaneo
INNER JOIN dbo.Ambiente AS a
    ON e.id_ambiente = a.id_ambiente
WHERE o.id_objeto = 1
ORDER BY e.fecha_hora DESC;
GO

PRINT N'CONSULTA 03 - Los 10 objetos mas detectados';
SELECT TOP (10)
    o.id_objeto,
    o.nombre_objeto,
    c.nombre_categoria,
    COUNT(d.id_deteccion) AS total_detecciones
FROM dbo.Objeto AS o
INNER JOIN dbo.Categoria AS c
    ON o.id_categoria = c.id_categoria
INNER JOIN dbo.Deteccion AS d
    ON o.id_objeto = d.id_objeto
GROUP BY o.id_objeto, o.nombre_objeto, c.nombre_categoria
ORDER BY total_detecciones DESC, o.id_objeto;
GO

PRINT N'CONSULTA 04 - Usuarios con configuraciones de accesibilidad';
SELECT
    u.id_usuario,
    CONCAT(u.nombre, N' ', u.apellido) AS nombre_completo,
    u.tipo_discapacidad,
    c.velocidad_voz_tts,
    c.tono_voz,
    c.volumen_audio,
    c.modo_deteccion
FROM dbo.Usuario AS u
LEFT JOIN dbo.Configuracion AS c
    ON u.id_usuario = c.id_usuario
ORDER BY u.id_usuario;
GO

PRINT N'CONSULTA 05 - Objetos registrados por un usuario';
SELECT
    u.id_usuario,
    CONCAT(u.nombre, N' ', u.apellido) AS usuario,
    o.nombre_objeto,
    c.nombre_categoria,
    o.ubicacion_habitual,
    uo.tipo_vinculo,
    uo.fecha_asociacion
FROM dbo.Usuario AS u
INNER JOIN dbo.UsuarioObjeto AS uo
    ON u.id_usuario = uo.id_usuario
INNER JOIN dbo.Objeto AS o
    ON uo.id_objeto = o.id_objeto
INNER JOIN dbo.Categoria AS c
    ON o.id_categoria = c.id_categoria
WHERE u.id_usuario = 1
ORDER BY o.nombre_objeto;
GO

PRINT N'CONSULTA 06 - Cantidad de objetos propios y compartidos por usuario';
SELECT
    u.id_usuario,
    CONCAT(u.nombre, N' ', u.apellido) AS usuario,
    COUNT(uo.id_objeto) AS total_objetos,
    SUM(CASE WHEN uo.tipo_vinculo = N'Propio' THEN 1 ELSE 0 END) AS objetos_propios,
    SUM(CASE WHEN uo.tipo_vinculo = N'Compartido' THEN 1 ELSE 0 END) AS objetos_compartidos
FROM dbo.Usuario AS u
LEFT JOIN dbo.UsuarioObjeto AS uo
    ON u.id_usuario = uo.id_usuario
GROUP BY u.id_usuario, u.nombre, u.apellido
ORDER BY total_objetos DESC, u.id_usuario;
GO

PRINT N'CONSULTA 07 - Cantidad de objetos por categoria';
SELECT
    c.id_categoria,
    c.nombre_categoria,
    COUNT(o.id_objeto) AS cantidad_objetos
FROM dbo.Categoria AS c
LEFT JOIN dbo.Objeto AS o
    ON c.id_categoria = o.id_categoria
GROUP BY c.id_categoria, c.nombre_categoria
ORDER BY cantidad_objetos DESC, c.nombre_categoria;
GO

PRINT N'CONSULTA 08 - Objetos y cantidad de imagenes de referencia';
SELECT
    o.id_objeto,
    o.nombre_objeto,
    COUNT(i.id_imagen_ref) AS cantidad_imagenes,
    MAX(i.fecha_captura) AS ultima_imagen_registrada
FROM dbo.Objeto AS o
LEFT JOIN dbo.ImagenReferencia AS i
    ON o.id_objeto = i.id_objeto
GROUP BY o.id_objeto, o.nombre_objeto
ORDER BY cantidad_imagenes DESC, o.nombre_objeto;
GO

PRINT N'CONSULTA 09 - Objetos asociados con multiples usuarios';
SELECT
    o.id_objeto,
    o.nombre_objeto,
    c.nombre_categoria,
    COUNT(DISTINCT uo.id_usuario) AS usuarios_asociados
FROM dbo.Objeto AS o
INNER JOIN dbo.Categoria AS c
    ON o.id_categoria = c.id_categoria
INNER JOIN dbo.UsuarioObjeto AS uo
    ON o.id_objeto = uo.id_objeto
GROUP BY o.id_objeto, o.nombre_objeto, c.nombre_categoria
HAVING COUNT(DISTINCT uo.id_usuario) > 1
ORDER BY usuarios_asociados DESC, o.nombre_objeto;
GO

PRINT N'CONSULTA 10 - Cantidad de escaneos realizados por usuario';
SELECT
    u.id_usuario,
    CONCAT(u.nombre, N' ', u.apellido) AS usuario,
    COUNT(e.id_escaneo) AS total_escaneos,
    MIN(e.fecha_hora) AS primer_escaneo,
    MAX(e.fecha_hora) AS ultimo_escaneo
FROM dbo.Usuario AS u
LEFT JOIN dbo.Escaneo AS e
    ON u.id_usuario = e.id_usuario
GROUP BY u.id_usuario, u.nombre, u.apellido
ORDER BY total_escaneos DESC, u.id_usuario;
GO

PRINT N'CONSULTA 11 - Dispositivos mas utilizados';
SELECT
    d.id_dispositivo,
    d.nombre_dispositivo,
    d.tipo_dispositivo,
    d.estado_conexion,
    COUNT(DISTINCT ud.id_usuario) AS usuarios_vinculados,
    COUNT(DISTINCT e.id_escaneo) AS total_escaneos
FROM dbo.Dispositivo AS d
LEFT JOIN dbo.UsuarioDispositivo AS ud
    ON d.id_dispositivo = ud.id_dispositivo
LEFT JOIN dbo.Escaneo AS e
    ON d.id_dispositivo = e.id_dispositivo
GROUP BY d.id_dispositivo, d.nombre_dispositivo, d.tipo_dispositivo, d.estado_conexion
ORDER BY total_escaneos DESC, d.nombre_dispositivo;
GO

PRINT N'CONSULTA 12 - Promedio de certeza segun iluminacion';
SELECT
    e.nivel_iluminacion,
    COUNT(d.id_deteccion) AS total_detecciones,
    CAST(AVG(CAST(d.porcentaje_certeza AS DECIMAL(10,2))) AS DECIMAL(5,2)) AS promedio_certeza,
    MIN(d.porcentaje_certeza) AS certeza_minima,
    MAX(d.porcentaje_certeza) AS certeza_maxima
FROM dbo.Escaneo AS e
INNER JOIN dbo.Deteccion AS d
    ON e.id_escaneo = d.id_escaneo
GROUP BY e.nivel_iluminacion
ORDER BY promedio_certeza DESC;
GO

PRINT N'CONSULTA 13 - Detecciones con certeza inferior al 90 por ciento';
SELECT
    d.id_deteccion,
    CONCAT(u.nombre, N' ', u.apellido) AS usuario,
    COALESCE(o.nombre_objeto, N'Objeto no identificado') AS objeto,
    d.porcentaje_certeza,
    e.nivel_iluminacion,
    a.nombre_ambiente,
    e.fecha_hora
FROM dbo.Deteccion AS d
INNER JOIN dbo.Escaneo AS e
    ON d.id_escaneo = e.id_escaneo
INNER JOIN dbo.Usuario AS u
    ON e.id_usuario = u.id_usuario
INNER JOIN dbo.Ambiente AS a
    ON e.id_ambiente = a.id_ambiente
LEFT JOIN dbo.Objeto AS o
    ON d.id_objeto = o.id_objeto
WHERE d.porcentaje_certeza < 90
ORDER BY d.porcentaje_certeza ASC;
GO

PRINT N'CONSULTA 14 - Estado de escaneos y cantidad de detecciones';
SELECT
    e.id_escaneo,
    CONCAT(u.nombre, N' ', u.apellido) AS usuario,
    a.nombre_ambiente,
    e.fecha_hora,
    COUNT(d.id_deteccion) AS cantidad_detecciones,
    CASE
        WHEN COUNT(d.id_deteccion) = 0 THEN N'Sin detecciones'
        ELSE N'Con detecciones'
    END AS estado_escaneo
FROM dbo.Escaneo AS e
INNER JOIN dbo.Usuario AS u
    ON e.id_usuario = u.id_usuario
INNER JOIN dbo.Ambiente AS a
    ON e.id_ambiente = a.id_ambiente
LEFT JOIN dbo.Deteccion AS d
    ON e.id_escaneo = d.id_escaneo
GROUP BY e.id_escaneo, u.nombre, u.apellido, a.nombre_ambiente, e.fecha_hora
ORDER BY e.fecha_hora DESC;
GO

PRINT N'CONSULTA 15 - Integridad entre detecciones e historial';
SELECT
    COUNT(*) AS total_detecciones,
    SUM(CASE WHEN d.id_objeto IS NULL THEN 1 ELSE 0 END) AS objetos_no_identificados,
    SUM(CASE WHEN d.id_objeto IS NOT NULL AND h.id_historial IS NULL THEN 1 ELSE 0 END) AS detecciones_sin_historial,
    SUM(CASE WHEN h.id_historial IS NOT NULL AND h.id_objeto <> d.id_objeto THEN 1 ELSE 0 END) AS historiales_inconsistentes
FROM dbo.Deteccion AS d
LEFT JOIN dbo.HistorialUbicacion AS h
    ON d.id_deteccion = h.id_deteccion;
GO

CREATE OR ALTER PROCEDURE dbo.sp_UltimaUbicacionObjeto
    @IdObjeto INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        o.id_objeto,
        o.nombre_objeto,
        a.nombre_ambiente AS ultima_ubicacion,
        e.fecha_hora AS fecha_deteccion,
        d.porcentaje_certeza
    FROM dbo.Objeto AS o
    OUTER APPLY (
        SELECT TOP (1)
            det.id_escaneo,
            det.porcentaje_certeza
        FROM dbo.Deteccion AS det
        INNER JOIN dbo.Escaneo AS esc
            ON det.id_escaneo = esc.id_escaneo
        WHERE det.id_objeto = o.id_objeto
        ORDER BY esc.fecha_hora DESC, det.id_deteccion DESC
    ) AS d
    LEFT JOIN dbo.Escaneo AS e
        ON d.id_escaneo = e.id_escaneo
    LEFT JOIN dbo.Ambiente AS a
        ON e.id_ambiente = a.id_ambiente
    WHERE o.id_objeto = @IdObjeto;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_EscaneosPorUsuario
    @IdUsuario INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        e.id_escaneo,
        e.fecha_hora,
        a.nombre_ambiente,
        d.nombre_dispositivo,
        e.nivel_iluminacion,
        COUNT(det.id_deteccion) AS total_detecciones
    FROM dbo.Escaneo AS e
    INNER JOIN dbo.Ambiente AS a
        ON e.id_ambiente = a.id_ambiente
    INNER JOIN dbo.Dispositivo AS d
        ON e.id_dispositivo = d.id_dispositivo
    LEFT JOIN dbo.Deteccion AS det
        ON e.id_escaneo = det.id_escaneo
    WHERE e.id_usuario = @IdUsuario
    GROUP BY e.id_escaneo, e.fecha_hora, a.nombre_ambiente,
             d.nombre_dispositivo, e.nivel_iluminacion
    ORDER BY e.fecha_hora DESC;
END;
GO

CREATE OR ALTER FUNCTION dbo.fn_CantidadEscaneosUsuario
(
    @IdUsuario INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Cantidad INT;

    SELECT @Cantidad = COUNT(*)
    FROM dbo.Escaneo
    WHERE id_usuario = @IdUsuario;

    RETURN @Cantidad;
END;
GO

CREATE OR ALTER FUNCTION dbo.fn_PromedioCertezaObjeto
(
    @IdObjeto INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @Promedio DECIMAL(5,2);

    SELECT @Promedio = CAST(AVG(CAST(porcentaje_certeza AS DECIMAL(10,2))) AS DECIMAL(5,2))
    FROM dbo.Deteccion
    WHERE id_objeto = @IdObjeto;

    RETURN @Promedio;
END;
GO

PRINT N'PROCEDIMIENTO 01 - Ejecucion de ejemplo';
EXEC dbo.sp_UltimaUbicacionObjeto @IdObjeto = 1;
GO

PRINT N'PROCEDIMIENTO 02 - Ejecucion de ejemplo';
EXEC dbo.sp_EscaneosPorUsuario @IdUsuario = 1;
GO

PRINT N'FUNCION 01 - Ejecucion de ejemplo';
SELECT
    id_usuario,
    nombre,
    apellido,
    dbo.fn_CantidadEscaneosUsuario(id_usuario) AS total_escaneos
FROM dbo.Usuario;
GO

PRINT N'FUNCION 02 - Ejecucion de ejemplo';
SELECT
    o.id_objeto,
    o.nombre_objeto,
    dbo.fn_PromedioCertezaObjeto(o.id_objeto) AS promedio_certeza
FROM dbo.Objeto AS o
ORDER BY o.id_objeto;
GO
