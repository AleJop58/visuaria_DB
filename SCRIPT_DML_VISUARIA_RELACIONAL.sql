

USE Visuara;
GO
SET NOCOUNT ON;

IF OBJECT_ID(N'dbo.Usuario', N'U') IS NULL
    THROW 50001, 'Primero debes crear las tablas de Visuara.', 1;

IF EXISTS (SELECT 1 FROM dbo.Usuario)
 OR EXISTS (SELECT 1 FROM dbo.Categoria)
 OR EXISTS (SELECT 1 FROM dbo.Dispositivo)
 OR EXISTS (SELECT 1 FROM dbo.Configuracion)
 OR EXISTS (SELECT 1 FROM dbo.Ambiente)
 OR EXISTS (SELECT 1 FROM dbo.Objeto)
 OR EXISTS (SELECT 1 FROM dbo.UsuarioDispositivo)
 OR EXISTS (SELECT 1 FROM dbo.UsuarioObjeto)
 OR EXISTS (SELECT 1 FROM dbo.ImagenReferencia)
 OR EXISTS (SELECT 1 FROM dbo.Escaneo)
 OR EXISTS (SELECT 1 FROM dbo.Deteccion)
 OR EXISTS (SELECT 1 FROM dbo.HistorialUbicacion)
    THROW 50002, 'Las tablas deben estar vacias para cargar los nuevos datos.', 1;

CREATE TABLE #BaseUsuarios (n INT PRIMARY KEY, nombre NVARCHAR(80), apellido NVARCHAR(80));
INSERT INTO #BaseUsuarios (n, nombre, apellido) VALUES
    (1, N'Carlos Eduardo', N'Ramírez Torres'),
    (2, N'María Fernanda', N'López García'),
    (3, N'José Antonio', N'Vargas Flores'),
    (4, N'Lucía Valeria', N'Sánchez Rojas'),
    (5, N'Jorge Luis', N'Mendoza Castro'),
    (6, N'Ana Sofía', N'Pérez Medina'),
    (7, N'Miguel Ángel', N'Quispe Huamán'),
    (8, N'Rosa Elena', N'Chávez Díaz'),
    (9, N'Luis Alberto', N'Fernández Soto'),
    (10, N'Daniela Alejandra', N'Herrera León'),
    (11, N'Pedro Pablo', N'Salazar Vega'),
    (12, N'Andrea Paola', N'Gutiérrez Núñez'),
    (13, N'Ricardo Andrés', N'Flores Paredes'),
    (14, N'Claudia Patricia', N'Navarro Ruiz'),
    (15, N'Juan Carlos', N'Castillo Reyes'),
    (16, N'Verónica Isabel', N'Ramos Silva'),
    (17, N'Sergio Daniel', N'Morales Cruz'),
    (18, N'Karina Milagros', N'Cabrera Campos'),
    (19, N'Fernando Javier', N'Aguilar Rivas'),
    (20, N'Carmen Rosa', N'Ponce Delgado'),
    (21, N'Víctor Hugo', N'Torres Salinas'),
    (22, N'Patricia Beatriz', N'Ortiz Molina'),
    (23, N'Marco Antonio', N'García Espinoza'),
    (24, N'Diana Carolina', N'Cárdenas Romero'),
    (25, N'Héctor Raúl', N'Mendoza Valdez'),
    (26, N'Elizabeth Rocío', N'Rojas Pineda'),
    (27, N'Óscar Alejandro', N'Medina Bravo'),
    (28, N'Gabriela Fernanda', N'León Palacios'),
    (29, N'Eduardo Martín', N'Castro Jiménez'),
    (30, N'Silvia Maribel', N'Tapia Rosales'),
    (31, N'Emilio José', N'Vargas Luna'),
    (32, N'Natalia Isabel', N'Peña Cáceres'),
    (33, N'Manuel Enrique', N'Ruiz Obregón'),
    (34, N'Fiorella Alejandra', N'Soto Delgado'),
    (35, N'César Augusto', N'Arias Gamarra'),
    (36, N'Teresa del Pilar', N'Campos Ríos'),
    (37, N'Álvaro Sebastián', N'Hidalgo Vega'),
    (38, N'Pamela Nicole', N'Velásquez Salas'),
    (39, N'Roberto Carlos', N'Paredes Castro'),
    (40, N'Mónica Patricia', N'Rivera Acosta'),
    (41, N'David Alexander', N'López Navarro'),
    (42, N'Elena Victoria', N'Ramos Villanueva'),
    (43, N'Francisco Javier', N'Torres Benavides'),
    (44, N'Sandra Milagros', N'Espinoza Mora'),
    (45, N'Julio César', N'Córdova Rojas'),
    (46, N'Beatriz Adriana', N'Gómez Palomino'),
    (47, N'Raúl Alberto', N'Huamán Quispe'),
    (48, N'Carolina Andrea', N'Salas Montalvo'),
    (49, N'Jaime Enrique', N'Muñoz Silva'),
    (50, N'Mariana Lucía', N'Villanueva Soto');

INSERT INTO dbo.Usuario (nombre, apellido, correo, contrasena, tipo_discapacidad, fecha_registro)
SELECT b.nombre, b.apellido,
       CONCAT(N'visuara', RIGHT('00' + CAST(b.n AS VARCHAR(2)), 2), N'@example.test'),
       CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', CONCAT(N'CLAVE_DEMO_VISUARA_', b.n)), 2),
       CASE WHEN b.n % 2 = 0 THEN N'Congénita' ELSE N'Adquirida' END,
       DATEADD(DAY, b.n - 1, CONVERT(DATETIME2(0), '2026-09-01T08:30:00'))
FROM #BaseUsuarios AS b;

SELECT b.n, u.id_usuario INTO #MapaUsuarios
FROM #BaseUsuarios b JOIN dbo.Usuario u
ON u.correo = CONCAT(N'visuara', RIGHT('00' + CAST(b.n AS VARCHAR(2)), 2), N'@example.test');

CREATE TABLE #BaseCategorias (n INT PRIMARY KEY, categoria NVARCHAR(80), objeto1 NVARCHAR(100), objeto2 NVARCHAR(100), objeto3 NVARCHAR(100));
INSERT INTO #BaseCategorias (n, categoria, objeto1, objeto2, objeto3) VALUES
    (1, N'Llaves', N'Llaves de casa', N'Llaves del automóvil', N'Llaves del depósito'),
    (2, N'Billeteras y monederos', N'Billetera negra', N'Billetera marrón', N'Monedero de cuero'),
    (3, N'Documentos personales', N'Documento de identidad', N'Pasaporte', N'Carné universitario'),
    (4, N'Medicamentos', N'Pastillero semanal', N'Caja de paracetamol', N'Frasco de vitaminas'),
    (5, N'Electrónica portátil', N'Teléfono móvil de repuesto', N'Cargador USB', N'Batería portátil'),
    (6, N'Accesorios de audio', N'Audífonos Bluetooth', N'Auriculares con cable', N'Parlante portátil'),
    (7, N'Controles remotos', N'Control de televisor', N'Control de aire acondicionado', N'Control de proyector'),
    (8, N'Utensilios de cocina', N'Cuchara de acero', N'Espátula de silicona', N'Colador metálico'),
    (9, N'Tazas y vasos', N'Taza de cerámica', N'Vaso térmico', N'Taza medidora'),
    (10, N'Platos', N'Plato hondo', N'Plato llano', N'Plato de postre'),
    (11, N'Recipientes', N'Recipiente hermético', N'Envase de vidrio', N'Frasco plástico'),
    (12, N'Botellas y termos', N'Botella de agua', N'Termo de acero', N'Botella deportiva'),
    (13, N'Alimentos envasados', N'Paquete de arroz', N'Lata de atún', N'Caja de cereal'),
    (14, N'Condimentos', N'Salero', N'Pimentero', N'Frasco de canela'),
    (15, N'Limpieza del hogar', N'Limpiador multiusos', N'Esponja de cocina', N'Detergente líquido'),
    (16, N'Higiene personal', N'Cepillo de dientes', N'Jabón de manos', N'Frasco de champú'),
    (17, N'Cuidado del cabello', N'Peine de bolsillo', N'Cepillo de cabello', N'Secadora de cabello'),
    (18, N'Cuidado de la piel', N'Crema hidratante', N'Protector solar', N'Bálsamo labial'),
    (19, N'Ropa superior', N'Polo azul', N'Camisa blanca', N'Casaca negra'),
    (20, N'Ropa inferior', N'Pantalón jean', N'Short deportivo', N'Falda azul'),
    (21, N'Calzado', N'Zapatillas deportivas', N'Zapatos de vestir', N'Sandalias negras'),
    (22, N'Accesorios de vestir', N'Cinturón negro', N'Gorra azul', N'Bufanda gris'),
    (23, N'Joyería', N'Anillo de plata', N'Pulsera de cuero', N'Cadena dorada'),
    (24, N'Relojes', N'Reloj de pulsera', N'Reloj despertador', N'Cronómetro deportivo'),
    (25, N'Papelería', N'Lapicero azul', N'Resaltador amarillo', N'Lápiz HB'),
    (26, N'Cuadernos y agendas', N'Cuaderno rayado', N'Libreta de notas', N'Agenda personal'),
    (27, N'Libros', N'Novela impresa', N'Diccionario', N'Manual universitario'),
    (28, N'Herramientas manuales', N'Destornillador de cruz', N'Martillo pequeño', N'Llave inglesa'),
    (29, N'Material de ferretería', N'Cinta aislante', N'Caja de tornillos', N'Cinta métrica'),
    (30, N'Costura', N'Aguja de coser', N'Carrete de hilo', N'Tijeras de costura'),
    (31, N'Jardinería', N'Regadera pequeña', N'Pala de jardín', N'Guantes de jardinería'),
    (32, N'Accesorios para mascotas', N'Correa de perro', N'Plato para mascota', N'Cepillo para mascota'),
    (33, N'Artículos deportivos', N'Pelota de fútbol', N'Mancuerna de dos kilos', N'Colchoneta de ejercicio'),
    (34, N'Juegos de mesa', N'Tablero de ajedrez', N'Baraja de cartas', N'Fichas de dominó'),
    (35, N'Juguetes', N'Peluche de oso', N'Auto de juguete', N'Bloques de construcción'),
    (36, N'Fotografía', N'Cámara compacta', N'Trípode pequeño', N'Tarjeta de memoria'),
    (37, N'Informática', N'Mouse inalámbrico', N'Teclado USB', N'Memoria USB'),
    (38, N'Cables y adaptadores', N'Cable HDMI', N'Adaptador USB-C', N'Extensión eléctrica'),
    (39, N'Seguridad doméstica', N'Candado metálico', N'Linterna de emergencia', N'Alarma personal'),
    (40, N'Primeros auxilios', N'Venda elástica', N'Termómetro digital', N'Gasas estériles'),
    (41, N'Decoración del hogar', N'Marco de fotos', N'Florero de cerámica', N'Figura decorativa'),
    (42, N'Iluminación', N'Lámpara de escritorio', N'Bombilla LED', N'Linterna recargable'),
    (43, N'Artículos de dormitorio', N'Almohada blanca', N'Manta ligera', N'Despertador digital'),
    (44, N'Artículos de baño', N'Toalla de mano', N'Papel higiénico', N'Organizador de ducha'),
    (45, N'Lavandería', N'Pinzas de ropa', N'Canasta de ropa', N'Plancha de ropa'),
    (46, N'Artículos de oficina', N'Engrapadora', N'Perforadora', N'Portadocumentos'),
    (47, N'Tarjetas y credenciales', N'Tarjeta de transporte', N'Credencial de trabajo', N'Carné de biblioteca'),
    (48, N'Equipaje de viaje', N'Maleta de cabina', N'Neceser de viaje', N'Etiqueta de equipaje'),
    (49, N'Bolsos y mochilas', N'Mochila escolar', N'Bolso cruzado', N'Cartera pequeña'),
    (50, N'Artículos de comedor', N'Mantel individual', N'Servilletero', N'Jarra de agua');

INSERT INTO dbo.Categoria (nombre_categoria, descripcion)
SELECT categoria, CONCAT(N'Grupo de pertenencias domésticas: ', LOWER(categoria))
FROM #BaseCategorias;

SELECT b.n, c.id_categoria INTO #MapaCategorias
FROM #BaseCategorias b JOIN dbo.Categoria c
ON c.nombre_categoria = b.categoria;

CREATE TABLE #BaseDispositivos (n INT PRIMARY KEY, nombre NVARCHAR(100), tipo NVARCHAR(50));
INSERT INTO #BaseDispositivos (n, nombre, tipo) VALUES
    (1, N'Samsung Galaxy A54', N'Celular'),
    (2, N'Samsung Galaxy S23', N'Celular'),
    (3, N'Samsung Galaxy A34', N'Celular'),
    (4, N'Samsung Galaxy A55', N'Celular'),
    (5, N'Xiaomi Redmi Note 12', N'Celular'),
    (6, N'Xiaomi Redmi Note 13', N'Celular'),
    (7, N'Xiaomi Redmi 12', N'Celular'),
    (8, N'Xiaomi 13T', N'Celular'),
    (9, N'Motorola Moto G54', N'Celular'),
    (10, N'Motorola Moto G84', N'Celular'),
    (11, N'Motorola Edge 40', N'Celular'),
    (12, N'Apple iPhone 12', N'Celular'),
    (13, N'Apple iPhone 13', N'Celular'),
    (14, N'Apple iPhone 14', N'Celular'),
    (15, N'Apple iPhone 15', N'Celular'),
    (16, N'Huawei P30', N'Celular'),
    (17, N'Huawei Nova 11', N'Celular'),
    (18, N'Honor 90', N'Celular'),
    (19, N'Honor X8b', N'Celular'),
    (20, N'OPPO Reno10', N'Celular'),
    (21, N'OPPO A78', N'Celular'),
    (22, N'realme 11 Pro', N'Celular'),
    (23, N'realme C55', N'Celular'),
    (24, N'vivo V29', N'Celular'),
    (25, N'vivo Y36', N'Celular'),
    (26, N'Google Pixel 7', N'Celular'),
    (27, N'Google Pixel 8', N'Celular'),
    (28, N'Samsung Galaxy S24', N'Celular'),
    (29, N'POCO X5 Pro', N'Celular'),
    (30, N'OnePlus Nord 3', N'Celular'),
    (31, N'Samsung Galaxy A14', N'Celular'),
    (32, N'Samsung Galaxy A24', N'Celular'),
    (33, N'Samsung Galaxy A35', N'Celular'),
    (34, N'Samsung Galaxy S22', N'Celular'),
    (35, N'Samsung Galaxy S21 FE', N'Celular'),
    (36, N'Apple iPhone SE (2022)', N'Celular'),
    (37, N'Apple iPhone 11', N'Celular'),
    (38, N'Apple iPhone 16', N'Celular'),
    (39, N'Xiaomi Redmi Note 11', N'Celular'),
    (40, N'POCO M5', N'Celular'),
    (41, N'Xiaomi Redmi 10C', N'Celular'),
    (42, N'Motorola Moto G32', N'Celular'),
    (43, N'Motorola Moto G14', N'Celular'),
    (44, N'realme 10', N'Celular'),
    (45, N'OPPO A57', N'Celular'),
    (46, N'Ray-Ban Meta Wayfarer', N'Lentes inteligentes'),
    (47, N'Ray-Ban Meta Headliner', N'Lentes inteligentes'),
    (48, N'Envision Glasses', N'Lentes inteligentes'),
    (49, N'Logitech BRIO 4K', N'Cámara externa'),
    (50, N'Logitech C920', N'Cámara externa');

INSERT INTO dbo.Dispositivo (nombre_dispositivo, tipo_dispositivo, estado_conexion)
SELECT nombre, tipo, N'Conectado' FROM #BaseDispositivos;

SELECT b.n, d.id_dispositivo INTO #MapaDispositivos
FROM #BaseDispositivos b JOIN dbo.Dispositivo d
ON d.nombre_dispositivo = b.nombre;

INSERT INTO dbo.Configuracion (id_usuario, velocidad_voz_tts, tono_voz, volumen_audio, modo_deteccion)
SELECT u.id_usuario, CAST(0.85 + (u.n % 7) * 0.15 AS DECIMAL(4,2)),
       CASE u.n % 3 WHEN 0 THEN N'Agudo' WHEN 1 THEN N'Medio' ELSE N'Grave' END,
       45 + (u.n % 10) * 5,
       CASE WHEN u.n % 2 = 0 THEN N'Automático' ELSE N'Manual' END
FROM #MapaUsuarios u;

INSERT INTO dbo.Ambiente (id_usuario, nombre_ambiente, numero_piso)
SELECT u.id_usuario, a.nombre,
       CASE WHEN a.nombre = N'Dormitorio' THEN 2 ELSE 1 END
FROM #MapaUsuarios u
CROSS JOIN (VALUES (N'Sala'), (N'Cocina'), (N'Dormitorio')) AS a(nombre);

SELECT u.n, a.id_ambiente, a.nombre_ambiente INTO #MapaAmbientes
FROM dbo.Ambiente a JOIN #MapaUsuarios u ON u.id_usuario = a.id_usuario;

SELECT c.n AS numero_categoria, x.posicion, x.nombre_objeto INTO #BaseObjetos
FROM #BaseCategorias c
CROSS APPLY (VALUES (1, c.objeto1), (2, c.objeto2), (3, c.objeto3)) x(posicion, nombre_objeto);

INSERT INTO dbo.Objeto (id_categoria, nombre_objeto, descripcion_fisica, ubicacion_habitual)
SELECT cm.id_categoria, b.nombre_objeto,
       CONCAT(b.nombre_objeto, N'; artículo personal de tamaño ',
              CASE b.posicion WHEN 1 THEN N'pequeño' WHEN 2 THEN N'mediano' ELSE N'variable' END,
              N' y de uso cotidiano.'),
       CASE b.posicion WHEN 1 THEN N'Mueble de entrada'
            WHEN 2 THEN N'Repisa de sala' ELSE N'Cajón del dormitorio' END
FROM #BaseObjetos b JOIN #MapaCategorias cm ON cm.n = b.numero_categoria;

SELECT b.numero_categoria, b.posicion, o.id_objeto INTO #MapaObjetos
FROM #BaseObjetos b
JOIN #MapaCategorias cm ON cm.n = b.numero_categoria
JOIN dbo.Objeto o ON o.id_categoria = cm.id_categoria AND o.nombre_objeto = b.nombre_objeto;

INSERT INTO dbo.UsuarioDispositivo (id_usuario, id_dispositivo, fecha_vinculacion, estado_vinculacion)
SELECT u.id_usuario, d.id_dispositivo,
       DATEADD(MINUTE, u.n * 4 + v.k, CONVERT(DATETIME2(0), '2026-10-01T09:00:00')),
       N'Activo'
FROM #MapaUsuarios u
CROSS JOIN (VALUES (1),(2),(3)) v(k)
JOIN #MapaDispositivos d ON d.n = ((u.n + v.k - 2) % 50) + 1;

INSERT INTO dbo.UsuarioObjeto (id_usuario, id_objeto, fecha_asociacion, tipo_vinculo)
SELECT u.id_usuario, o.id_objeto,
       DATEADD(MINUTE, o.id_objeto + v.k, CONVERT(DATETIME2(0), '2026-10-02T09:00:00')),
       CASE WHEN v.k = 1 THEN N'Propio' ELSE N'Compartido' END
FROM #MapaObjetos o
CROSS JOIN (VALUES (1),(2),(3)) v(k)
JOIN #MapaUsuarios u ON u.n = ((o.numero_categoria + v.k - 2) % 50) + 1;

INSERT INTO dbo.ImagenReferencia (id_objeto, ruta_archivo, fecha_captura)
SELECT o.id_objeto,
       CONCAT(N'/visuara/referencias/', o.id_objeto, N'_', v.vista, N'.jpg'),
       DATEADD(MINUTE, o.id_objeto * 3 + v.k, CONVERT(DATETIME2(0), '2026-10-03T09:00:00'))
FROM #MapaObjetos o
CROSS JOIN (VALUES (1,N'frontal'),(2,N'lateral'),(3,N'superior')) v(k,vista);

INSERT INTO dbo.Escaneo (id_usuario, id_dispositivo, id_ambiente, fecha_hora, nivel_iluminacion)
SELECT u.id_usuario, d.id_dispositivo, a.id_ambiente,
       DATEADD(MINUTE, u.n * 10 + v.k * 3, CONVERT(DATETIME2(0), '2026-11-15T08:00:00')),
       CASE v.k WHEN 1 THEN N'Alta' WHEN 2 THEN N'Media' ELSE N'Baja' END
FROM #MapaUsuarios u
CROSS JOIN (VALUES (1,N'Sala'), (2,N'Cocina'), (3,N'Dormitorio')) v(k,nombre)
JOIN #MapaAmbientes a ON a.n = u.n AND a.nombre_ambiente = v.nombre
JOIN #MapaDispositivos d ON d.n = ((u.n + v.k - 2) % 50) + 1;

INSERT INTO dbo.Deteccion (id_escaneo, id_objeto, porcentaje_certeza, mensaje_audio)
SELECT e.id_escaneo, o.id_objeto,
       CAST(86.00 + ((u.n + o.posicion * 5 + v.k * 3) % 140) / 10.0 AS DECIMAL(5,2)),
       CONCAT(ob.nombre_objeto, N' detectado en ', a.nombre_ambiente, N'.')
FROM dbo.Escaneo e
JOIN #MapaUsuarios u ON u.id_usuario = e.id_usuario
JOIN #MapaAmbientes a ON a.id_ambiente = e.id_ambiente
CROSS APPLY (VALUES (CASE a.nombre_ambiente WHEN N'Sala' THEN 1
                                            WHEN N'Cocina' THEN 2 ELSE 3 END)) v(k)
JOIN #MapaObjetos o ON o.numero_categoria = ((u.n - v.k + 50) % 50) + 1
JOIN dbo.Objeto ob ON ob.id_objeto = o.id_objeto
JOIN dbo.UsuarioObjeto uo ON uo.id_usuario = u.id_usuario AND uo.id_objeto = o.id_objeto;

INSERT INTO dbo.HistorialUbicacion (id_objeto, id_deteccion, fecha_registro)
SELECT d.id_objeto, d.id_deteccion, e.fecha_hora
FROM dbo.Deteccion d
JOIN dbo.Escaneo e ON e.id_escaneo = d.id_escaneo
WHERE d.id_objeto IS NOT NULL;

DROP TABLE #BaseUsuarios;
DROP TABLE #BaseCategorias;
DROP TABLE #BaseDispositivos;
DROP TABLE #BaseObjetos;
DROP TABLE #MapaUsuarios;
DROP TABLE #MapaCategorias;
DROP TABLE #MapaDispositivos;
DROP TABLE #MapaAmbientes;
DROP TABLE #MapaObjetos;

SELECT 'Usuario' AS Tabla, COUNT(*) AS Registros FROM dbo.Usuario
UNION ALL SELECT 'Categoria', COUNT(*) FROM dbo.Categoria
UNION ALL SELECT 'Dispositivo', COUNT(*) FROM dbo.Dispositivo
UNION ALL SELECT 'Configuracion', COUNT(*) FROM dbo.Configuracion
UNION ALL SELECT 'Ambiente', COUNT(*) FROM dbo.Ambiente
UNION ALL SELECT 'Objeto', COUNT(*) FROM dbo.Objeto
UNION ALL SELECT 'UsuarioDispositivo', COUNT(*) FROM dbo.UsuarioDispositivo
UNION ALL SELECT 'UsuarioObjeto', COUNT(*) FROM dbo.UsuarioObjeto
UNION ALL SELECT 'ImagenReferencia', COUNT(*) FROM dbo.ImagenReferencia
UNION ALL SELECT 'Escaneo', COUNT(*) FROM dbo.Escaneo
UNION ALL SELECT 'Deteccion', COUNT(*) FROM dbo.Deteccion
UNION ALL SELECT 'HistorialUbicacion', COUNT(*) FROM dbo.HistorialUbicacion
ORDER BY Tabla;

SELECT TOP (50) u.id_usuario, u.nombre, u.apellido, u.correo,
       COUNT(DISTINCT e.id_escaneo) AS escaneos
FROM dbo.Usuario u LEFT JOIN dbo.Escaneo e ON u.id_usuario = e.id_usuario
GROUP BY u.id_usuario, u.nombre, u.apellido, u.correo
ORDER BY u.id_usuario;

SELECT TOP (30) u.nombre, u.apellido, a.nombre_ambiente,
       o.nombre_objeto, d.porcentaje_certeza, e.fecha_hora
FROM dbo.Deteccion d
JOIN dbo.Objeto o ON o.id_objeto = d.id_objeto
JOIN dbo.Escaneo e ON e.id_escaneo = d.id_escaneo
JOIN dbo.Usuario u ON u.id_usuario = e.id_usuario
JOIN dbo.Ambiente a ON a.id_ambiente = e.id_ambiente
ORDER BY e.fecha_hora, u.id_usuario, o.nombre_objeto;
GO
