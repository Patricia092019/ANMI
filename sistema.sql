-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 24-05-2021 a las 17:41:19
-- Versión del servidor: 10.1.21-MariaDB
-- Versión de PHP: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistema`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_precio_producto` (IN `n_cantidad` INT, IN `n_precio` DECIMAL(10,2), IN `codigo` INT)  BEGIN
DECLARE nueva_existencia int;
DECLARE nuevo_total decimal(10,2);
DECLARE nuevo_precio decimal(10,2);

DECLARE cant_actual int;
DECLARE pre_actual decimal(10,2);

DECLARE actual_existencia int;
DECLARE actual_precio decimal(10,2);

SELECT precio, existencia INTO actual_precio, actual_existencia FROM producto WHERE codproducto = codigo;

SET nueva_existencia = actual_existencia + n_cantidad;
SET nuevo_total = n_precio;
SET nuevo_precio = nuevo_total;

UPDATE producto SET existencia = nueva_existencia, precio = nuevo_precio WHERE codproducto = codigo;

SELECT nueva_existencia, nuevo_precio;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_detalle_temp` (`codigo` INT, `cantidad` INT, `token_user` VARCHAR(50))  BEGIN
DECLARE precio_actual decimal(10,2);
SELECT precio INTO precio_actual FROM producto WHERE codproducto = codigo;
INSERT INTO detalle_temp(token_user, codproducto, cantidad, precio_venta) VALUES (token_user, codigo, cantidad, precio_actual);
SELECT tmp.correlativo, tmp.codproducto, p.descripcion, tmp.cantidad, tmp.precio_venta FROM detalle_temp tmp INNER JOIN producto p ON tmp.codproducto = p.codproducto WHERE tmp.token_user = token_user;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `data` ()  BEGIN
DECLARE usuarios int;
DECLARE clientes int;
DECLARE proveedores int;
DECLARE productos int;
DECLARE ventas int;
SELECT COUNT(*) INTO usuarios FROM usuario;
SELECT COUNT(*) INTO clientes FROM cliente;
SELECT COUNT(*) INTO proveedores FROM proveedor;
SELECT COUNT(*) INTO productos FROM producto;
SELECT COUNT(*) INTO ventas FROM factura WHERE fecha > CURDATE();

SELECT usuarios, clientes, proveedores, productos, ventas;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `del_detalle_temp` (`id_detalle` INT, `token` VARCHAR(50))  BEGIN
DELETE FROM detalle_temp WHERE correlativo = id_detalle;
SELECT tmp.correlativo, tmp.codproducto, p.descripcion, tmp.cantidad, tmp.precio_venta FROM detalle_temp tmp INNER JOIN producto p ON tmp.codproducto = p.codproducto WHERE tmp.token_user = token;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procesar_venta` (IN `cod_usuario` INT, IN `cod_cliente` INT, IN `token` VARCHAR(50))  BEGIN
DECLARE factura INT;
DECLARE registros INT;
DECLARE total DECIMAL(10,2);
DECLARE nueva_existencia int;
DECLARE existencia_actual int;

DECLARE tmp_cod_producto int;
DECLARE tmp_cant_producto int;
DECLARE a int;
SET a = 1;

CREATE TEMPORARY TABLE tbl_tmp_tokenuser(
	id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cod_prod BIGINT,
    cant_prod int);
SET registros = (SELECT COUNT(*) FROM detalle_temp WHERE token_user = token);
IF registros > 0 THEN
INSERT INTO tbl_tmp_tokenuser(cod_prod, cant_prod) SELECT codproducto, cantidad FROM detalle_temp WHERE token_user = token;
INSERT INTO factura (usuario,codcliente) VALUES (cod_usuario, cod_cliente);
SET factura = LAST_INSERT_ID();

INSERT INTO detallefactura(nofactura,codproducto,cantidad,precio_venta) SELECT (factura) AS nofactura, codproducto, cantidad,precio_venta FROM detalle_temp WHERE token_user = token;
WHILE a <= registros DO
	SELECT cod_prod, cant_prod INTO tmp_cod_producto,tmp_cant_producto FROM tbl_tmp_tokenuser WHERE id = a;
    SELECT existencia INTO existencia_actual FROM producto WHERE codproducto = tmp_cod_producto;
    SET nueva_existencia = existencia_actual - tmp_cant_producto;
    UPDATE producto SET existencia = nueva_existencia WHERE codproducto = tmp_cod_producto;
    SET a=a+1;
END WHILE;
SET total = (SELECT SUM(cantidad * precio_venta) FROM detalle_temp WHERE token_user = token);
UPDATE factura SET totalfactura = total WHERE nofactura = factura;
DELETE FROM detalle_temp WHERE token_user = token;
TRUNCATE TABLE tbl_tmp_tokenuser;
SELECT * FROM factura WHERE nofactura = factura;
ELSE
SELECT 0;
END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `idcliente` int(11) NOT NULL,
  `dni` int(8) NOT NULL,
  `nombre` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `telefono` int(15) NOT NULL,
  `direccion` varchar(200) COLLATE utf8_spanish_ci NOT NULL,
  `usuario_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`idcliente`, `dni`, `nombre`, `telefono`, `direccion`, `usuario_id`) VALUES
(1, 123456, 'Público en General', 89999, 'S/D2222', 1),
(2, 123789, 'Angel sifuentes', 925491523, 'Lima', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion`
--

CREATE TABLE `configuracion` (
  `id` int(11) NOT NULL,
  `dni` int(11) NOT NULL,
  `nombre` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `razon_social` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `telefono` int(11) NOT NULL,
  `email` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `direccion` text COLLATE utf8_spanish_ci NOT NULL,
  `igv` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `configuracion`
--

INSERT INTO `configuracion` (`id`, `dni`, `nombre`, `razon_social`, `telefono`, `email`, `direccion`, `igv`) VALUES
(1, 1, 'Almacén Nacional de Medicamentos e Insumos (ANMI)', 'ANMI', 22210227, 'almacenmedicamentoshn@gmail.com', 'Tegucigalpa, Honduras', '1.18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallefactura`
--

CREATE TABLE `detallefactura` (
  `correlativo` bigint(20) NOT NULL,
  `nofactura` bigint(20) NOT NULL,
  `codproducto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `detallefactura`
--

INSERT INTO `detallefactura` (`correlativo`, `nofactura`, `codproducto`, `cantidad`, `precio_venta`) VALUES
(1, 1, 1, 10, '50.00'),
(2, 1, 2, 5, '10.00'),
(4, 2, 1, 5, '50.00'),
(5, 3, 4, 1, '13.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_temp`
--

CREATE TABLE `detalle_temp` (
  `correlativo` int(11) NOT NULL,
  `token_user` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `codproducto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entradas`
--

CREATE TABLE `entradas` (
  `correlativo` int(11) NOT NULL,
  `codproducto` int(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cantidad` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `usuario_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `entradas`
--

INSERT INTO `entradas` (`correlativo`, `codproducto`, `fecha`, `cantidad`, `precio`, `usuario_id`) VALUES
(1, 1, '2021-05-19 08:44:57', 0, '20.00', 1),
(2, 1, '2021-05-19 08:45:29', -100, '20.00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE `factura` (
  `nofactura` int(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario` int(11) NOT NULL,
  `codcliente` int(11) NOT NULL,
  `totalfactura` decimal(10,2) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `factura`
--

INSERT INTO `factura` (`nofactura`, `fecha`, `usuario`, `codcliente`, `totalfactura`, `estado`) VALUES
(1, '2021-03-09 10:20:19', 1, 1, '550.00', 1),
(2, '2021-03-09 10:30:47', 1, 1, '250.00', 1),
(3, '2021-03-09 10:33:05', 1, 2, '13.00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hospitales`
--

CREATE TABLE `hospitales` (
  `id_hospital` int(11) NOT NULL,
  `Hospital` varchar(50) NOT NULL,
  `mqprogramados` int(11) NOT NULL,
  `Mqabastecido` int(11) NOT NULL,
  `abastecimiento` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Volcado de datos para la tabla `hospitales`
--

INSERT INTO `hospitales` (`id_hospital`, `Hospital`, `mqprogramados`, `Mqabastecido`, `abastecimiento`) VALUES
(1, 'Anibal Murillo Escobar', 208, 181, '87'),
(2, 'Atlantida', 225, 178, '79'),
(3, 'Enrique Aguilar Cerrato', 236, 194, '82'),
(4, 'Gabriela Alvarado', 204, 182, '89'),
(5, 'Leonardo MartÃ­nez Valenzuela', 236, 191, '81'),
(6, 'Manuel de JesÃºs Subirana', 244, 195, '80'),
(7, 'Mario Catarino Rivas', 267, 208, '78'),
(8, 'Mario Mendoza', 63, 56, '89'),
(9, 'Occidente', 280, 249, '89'),
(10, 'El Progreso', 258, 179, '69'),
(11, 'Puerto CortÃ©s', 239, 203, '85'),
(12, 'Puerto Lempira', 230, 194, '84'),
(13, 'RoatÃ¡n', 247, 180, '73'),
(14, 'Roberto Suazo CÃ³rdova', 213, 190, '89'),
(15, 'Salvador Paredes', 249, 230, '92'),
(16, 'San Felipe', 258, 182, '71'),
(17, 'San Francisco', 243, 179, '74'),
(18, 'San Isidro', 245, 190, '78'),
(19, 'San Marcos de Ocotepeque', 225, 179, '80'),
(20, 'Santa BÃ¡rbara', 163, 131, '80'),
(21, 'Santa Rosita', 133, 128, '96'),
(22, 'Santa Teresa', 215, 173, '80'),
(23, 'Sur', 284, 258, '91'),
(24, 'Tela', 199, 183, '92'),
(25, 'Juan Manuel GÃ¡lvez', 212, 167, '79'),
(26, 'INCP Torax', 163, 149, '91'),
(27, 'Hospital Santo Hermano pedro', 700, 500, '71'),
(28, 'Hospital Fundaniquen', 500, 300, '60');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `codproducto` int(11) NOT NULL,
  `codigo` varchar(20) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion` varchar(200) COLLATE utf8_spanish_ci NOT NULL,
  `proveedor` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `existencia` int(11) NOT NULL,
  `usuario_id` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`codproducto`, `codigo`, `descripcion`, `proveedor`, `precio`, `existencia`, `usuario_id`) VALUES
(1, '123AA', 'GELATINA', 1, '20.00', 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `codproveedor` int(11) NOT NULL,
  `proveedor` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `contacto` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `telefono` int(11) NOT NULL,
  `direccion` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `usuario_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`codproveedor`, `proveedor`, `contacto`, `telefono`, `direccion`, `usuario_id`) VALUES
(1, 'Open', '123456', 925491523, 'Lima', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `regiones`
--

CREATE TABLE `regiones` (
  `id_region` int(11) NOT NULL,
  `Region` varchar(50) NOT NULL,
  `mqprogramados` int(11) NOT NULL,
  `Mqabastecido` int(11) NOT NULL,
  `abastecimiento` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `regiones`
--

INSERT INTO `regiones` (`id_region`, `Region`, `mqprogramados`, `Mqabastecido`, `abastecimiento`) VALUES
(1, 'Region Olancho', 300, 200, '67'),
(3, 'Region Cortes', 150, 140, '93'),
(4, 'Region Atlantida', 180, 120, '67'),
(5, 'Region La Paz', 150, 100, '67'),
(10, 'Region Colon', 200, 150, '75'),
(11, 'Region Santa Barbara', 200, 100, '50'),
(12, 'Region El Paraiso', 200, 130, '65'),
(13, 'Region Francisco Morazan', 300, 200, '67'),
(14, 'Region Comayagua', 180, 150, '83'),
(15, 'Region Islas de la Bahia', 100, 95, '95'),
(16, 'Region Valle', 190, 140, '74'),
(17, 'Region Choluteca', 250, 230, '92'),
(18, 'Region Metropolitana D.C.', 300, 230, '77'),
(19, 'Region Metropolitana S.P.S.', 290, 250, '86'),
(20, 'Region Lempira', 180, 170, '94'),
(22, 'Region x', 200, 150, '75'),
(23, 'Region Comayagua', 11, 11, '100');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `idrol` int(11) NOT NULL,
  `rol` varchar(50) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`idrol`, `rol`) VALUES
(1, 'Administrador'),
(2, 'Usuario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tablero`
--

CREATE TABLE `tablero` (
  `codigo` varchar(15) NOT NULL,
  `medicamento` varchar(255) NOT NULL,
  `up` varchar(10) NOT NULL,
  `programado` int(11) NOT NULL,
  `cpm` int(11) NOT NULL,
  `existencia` int(11) NOT NULL,
  `transito` int(11) NOT NULL,
  `cobertura` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tablero`
--

INSERT INTO `tablero` (`codigo`, `medicamento`, `up`, `programado`, `cpm`, `existencia`, `transito`, `cobertura`) VALUES
('A01AA0100', 'FLUORURO de sodio 2.2 mg', 'TAB', 2841486, 236791, 745400, 0, '3.1'),
('A01AB91', 'NISTATINA 100.000 UI/mL', 'FCO', 77252, 6438, 39280, 0, '6.1'),
('A01AB09', 'MICONAZOL 2%', 'TUB', 979, 82, 749, 0, '9.2'),
('A02AB1002', 'HIDROXIDO DE ALUMINIO  185-200mg + HIDROXIDO DE  MAGNESIO 200 mg/5mL', 'FCS', 357382, 29782, 307089, 421824, '10.3'),
('A02BA0200', 'RANITIDINA (clorhidato) 25mg/mL ', 'AMP', 618988, 51582, 480723, 0, '9.3'),
('A02BA0201', 'RANITIDINA  (clorhidrato)  75 mg/5ml', 'FCO', 800, 67, 0, 0, '0'),
('A02BA0202', 'RANITIDINA  (clorhidrato) 150 mg', 'TAB', 750000, 62500, 0, 5640266, '0'),
('A02BC0100', 'OMEPRAZOL  20mg', 'CAP', 9445091, 787091, 208600, 0, '0.3'),
('A02BC0101', 'OMEPRAZOL   40mg', 'VIAL', 242236, 20186, 0, 0, '0'),
('A02BC05', 'ESOMEPRAZOL 10mg', 'SOB', 71056, 5921, 0, 0, '0'),
('A03BA01', 'ATROPINA (sulfato) 1mg/1mL', 'AMP', 35670, 2973, 2960, 0, '1'),
('A03BA0300', 'HIOSCINA (butilbromuro) 10mg ', 'TAB', 2429625, 202469, 564160, 0, '2.8'),
('A03BA0301', 'HIOSCINA (butilbromuro) 20mg/mL ', 'AMP/VIAL', 219640, 18303, 3000, 120000, '0.2'),
('A03FA0100', 'METOCLOPRAMIDA 5 mg/ml', 'AMP/VIAL', 290349, 24196, 36732, 87749, '1.5'),
('A03FA0101', 'METOCLOPRAMIDA 10 mg', 'TAB', 1199123, 99927, 0, 642723, '0'),
('A04AA01', 'ONDANSETRON  (clorhidrato) 2mg/mL', 'AMP/VIAL', 65670, 5473, 36258, 35000, '6.6'),
('A04AD12', 'APREPITANT 125mg ', 'CAP', 3504, 292, 1532, 0, '5.2'),
('A06AD11', 'LACTULOSA 10 g/15 mL', 'FCO ', 25270, 2106, 4059, 0, '1.9'),
('A06AG0100', 'FOSFATO (S?dico Monob?sica) 16g + FOSFATO (s?dico dib?sico) 6g ', 'FCO', 1309, 109, 0, 0, '0'),
('A06AG0101', 'FOSFATO (S?dico Monob?sica) 19g + FOSFATO (s?dico dib?sico) 7g', 'FCO', 5367, 447, 4285, 0, '9.6'),
('A06AG0103', 'FOSFATO (S?dico Monob?sica) 9.5g + FOSFATO (s?dico dib?sico) 3.5g ', 'FCO', 0, 0, 3068, 0, '0'),
('A07AA06', 'PAROMOMICINA 750mg', 'VIAL', 0, 0, 0, 0, '0'),
('A07BA01', 'CARBON ACTIVADO 50g', 'FCO ', 1066, 89, 186, 0, '2.1'),
('A07CA00', 'SALES  DE  REHIDRATACION  ORAL 20.5  g/  LPOLVO (Formula OMS)', 'SOB', 2860949, 238412, 1518973, 11800, '6.4'),
('A07FA0200', 'Saccharomyces boulardii (CNCM I-745) 250 mg', 'SOBRE', 169441, 14120, 0, 0, '0'),
('A10AB01', 'INSULINA CRISTALINA 100 Ul/mL', 'VIAL', 13621, 1135, 2, 0, '0'),
('A10AC01', 'INSULINA ISOFANICA HUMANA NPH 100 UI/mL', 'VIAL', 344950, 28746, 51373, 208, '1.8'),
('A10BA02', 'METFORMINA (clorhidrato) 850 mg', 'TAB', 22802312, 1900193, 1651530, 3096000, '0.9'),
('A10BB01', 'GLIBENCLAMIDA 5 mg', 'TAB ', 12532099, 1044342, 3207498, 0, '3.1'),
('A11AA0300', 'MULTIVITAMINAS PRENATALES', 'TAB/CAP', 16554833, 1379569, 2528950, 0, '1.8'),
('A11AA0301', 'MULTIVITAMINAS ADULTOS', 'TAB/CAP', 16727923, 1393994, 3848000, 2722433, '2.8'),
('A11AA0302', 'MULTIVITAMINAS PEDIATRICAS ', 'FCO ', 631031, 52586, 558739, 0, '10.6'),
('A11CA01', 'RETINOL (Vitamina A)  (palmitato) 200', '000 U.I.,C', 1421922, 118494, 0, 0, '0'),
('A11CA0201', 'RETINOL (Vitamina A)  (palmitato) 100', '000 U.I.,C', 545314, 45443, 0, 0, '0'),
('A11CC03', 'ALFACALCIDOL (Vitamina D3) 0.25mcg', 'TB', 9450, 788, 8340, 0, '10.6'),
('A11CC0301', 'ALFACALCIDOL (Vitamina D3) 1.0 mcg', 'TB', 8860, 738, 0, 0, '0'),
('A11CC05', 'COLECALCIFEROL (Vitamina D3) 0.25 mcg', 'CAP', 0, 0, 0, 0, '0'),
('A11DA0100', 'TIAMINA (Vitamina B1) (clorhidrato) 100 mg/mL', 'VIAL ', 179741, 14978, 44661, 0, '3'),
('A11DA0101', 'TIAMINA (Vitamina B1) (clorhidrato) 100mg', 'TAB', 1258918, 104910, 605010, 70288, '5.8'),
('A11HA02', 'PIRIDOXINA (Vitamina B6) (clorhidrato) 50 mg', 'TAB/CAP', 578737, 48228, 170, 0, '0'),
('A12AA0300', 'CALCIO (gluconato) 10% ', 'AMP', 57455, 4788, 0, 0, '0'),
('A12AA0401', 'CALCIO(carbonato) 600mg (elemental)', 'TAB ', 168739, 14062, 0, 0, '0'),
('A12AX00', 'CALCIO (carbonato) 600mg (elemental) + VITAMINA D 200 UI', 'TAB', 2407687, 200641, 1154870, 0, '5.8'),
('A12CB01', 'ZINC (sulfato) 2mg/mL', 'FCO ', 250844, 20904, 11572, 0, '0.6'),
('B01AA03', 'WARFARINA (s?dica) 5 mg', 'TAB', 81139, 6762, 44639, 0, '6.6'),
('B01AB01', 'HEPARINA (s?dica)  5', '000UI/mL,V', 17531, 1461, 0, 0, '0'),
('B01AB0500', 'ENOXAPARINA (s?dica) 40mg/0.4ml  (4000 UI) (libre de preservantes) ', 'JE', 134568, 11214, 18028, 58447, '1.6'),
('B01AB0501', 'ENOXAPARINA (s?dica) 60mg/0.6ml (libre de preservantes)', 'JE', 31352, 2613, 0, 10764, '0'),
('B01AC04', 'CLOPIDOGREL (bisulfato) 75mg ', 'TAB', 757770, 63148, 337460, 199990, '5.3'),
('B01AC06', 'ACIDO ACETIL SALICILICO 100mg', 'TAB', 11395430, 949619, 615990, 4612408, '0.6'),
('B01AD01', 'ESTREPTOQUINASA 1.5millones de UI', 'VIAL', 60, 5, 17, 0, '3.4'),
('B02AA02', 'ACIDO TRANEXAMICO 500 mg / 5 ml', 'AM', 3764, 314, 0, 0, '0'),
('B02BA0100', 'VITAMINA K1 (Fitomenadiona) 1 mg/1mL ', 'AMP', 0, 0, 0, 0, '0'),
('B02BA0102', 'VITAMINA K1 (Fitomenadiona) 10mg/1mL ', 'AMP', 90416, 7535, 7733, 5009, '1'),
('B02BD02', 'FACTOR ANTIHEMOFILICO HUMANO (Factor VIII) 250-500UI', 'VIAL', 11442, 954, 0, 0, '0'),
('B02BD04', 'FACTOR IX (250 - 600 UI)', 'VIAL/JE', 400, 33, 0, 0, '0'),
('B02BD05', 'FACTOR VII 1 - 5 mg (Eq 50 - 250 KUI)', 'VIAL', 600, 50, 0, 0, '0'),
('B03AA0701', 'HIERRO (sulfato) 300mg (equivalente a 60mg de hierro elemental)', 'TB / GG', 15836392, 1319699, 748790, 12875000, '0.6'),
('B03AA0702', 'HIERRO (sulfato) 125mg/ml (equivalente a 25mg  de hierro elemental)', 'FCO', 491712, 40976, 178903, 5923, '4.4'),
('B03AC0000', 'HIERRO SACAROSA 20 mg / ml', 'AM', 4797, 400, 0, 0, '0'),
('B03BB0100', 'ACIDO FOLICO 1 mg', 'TAB', 20825227, 1735436, 3171910, 12540000, '1.8'),
('B03BB0101', 'ACIDO FOLICO 5 mg', 'TAB', 8516760, 709730, 979200, 26919, '1.4'),
('B03XA0100', 'ERITROPOYETINA beta recombinante humana 2', '000UI ,VIA', 136460, 11372, 0, 0, '0'),
('B03XA0101', 'ERITROPOYETINA alfa recombinante humana 2', '000UI ,VIA', 56938, 4745, 1314, 0, '0.3'),
('B05AA01', 'ALB?MINA HUMANA 25% (250mg/ml)', 'FCO', 33362, 2780, 9103, 0, '3.3'),
('B05AA0102', 'ALB?MINA HUMANA 20% (200mg/ml)', 'FCO', 0, 0, 0, 0, '0'),
('B05BA01', 'AMINO?CIDOS esenciales y no esenciales + DEXTROSA al 50%', 'VIAL/BOL', 840, 70, 0, 0, '0'),
('B05BA0101', ' AMINOACIDOS SIN ELECTROLITOS 10 % SIN DEXTROSA 500 ML', 'VIAL/BOL', 0, 0, 0, 0, '0'),
('B05BA02', 'L?PIDOS 10%', 'VIAL', 384, 32, 0, 0, '0'),
('B05BA0300', 'DEXTROSA EN AGUA 10% en 250 mL', 'BOL', 52496, 4375, 4903, 0, '1.1'),
('B05BA0301', 'DEXTROSA EN AGUA 10% en 500 mL', 'BOL', 56745, 4729, 16541, 0, '3.5'),
('B05BA0302', 'DEXTROSA EN AGUA 5% en 1000 mL', 'BOL', 31028, 2586, 8696, 0, '3.4'),
('B05BA0303', 'DEXTROSA EN AGUA 5% en 250 mL', 'BOL', 45824, 3819, 12769, 0, '3.3'),
('B05BA0304', 'DEXTROSA EN AGUA 5% en 500 mL', 'BOL', 79721, 6643, 26301, 51, '4'),
('B05BA0305', 'DEXTROSA EN AGUA 50% en 50 mL', 'VIAL/BOL', 38207, 3184, 944, 0, '0.3'),
('B05BB0200', 'DEXTROSA 5% + CLORURO DE SODIO 0.3%  en 250 mL', 'BOL', 10899, 908, 21809, 0, '24'),
('B05BB0201', 'DEXTROSA 5% + CLORURO DE SODIO 0.3% en  500 mL', 'BOL', 75900, 6325, 34368, 0, '5.4'),
('B05BB0202', 'DEXTROSA 5% + CLORURO DE SODIO 0.45% en  500 mL', 'BOL', 170529, 14211, 82931, 0, '5.8'),
('B05BB0203', 'DEXTROSA 5% + CLORURO DE SODIO 0.45% en 1000 mL', 'BOL', 123517, 10293, 28748, 0, '2.8'),
('B05BB0204', 'DEXTROSA 5% + CLORURO DE SODIO 0.9% en 250 mL', 'BOL', 14639, 1220, 17924, 0, '14.7'),
('B05BB0205', 'DEXTROSA 5% + CLORURO DE SODIO 0.9% en 500 mL', 'BOL', 185867, 15489, 15965, 0, '1'),
('B05BB0206', 'LACTATO de sodio + electrolitos mixtos (soluci?n Hartman) 1000 mL', 'BOL', 418600, 34883, 443452, 0, '12.7'),
('B05BC01', 'MANITOL 20%', 'VIAL/BOL', 9957, 830, 2677, 0, '3.2'),
('B05DB0000', 'SOLUCI?N PARA DI?LISIS PERITONEAL 1.5% en 2000mL', 'BOLSA', 0, 0, 0, 0, '0'),
('B05DB0001', 'SOLUCI?N PARA DI?LISIS PERITONEAL 1.5% en 5000 mL', 'BOL', 0, 0, 0, 0, '0'),
('B05DB0002', 'SOLUCI?N PARA DI?LISIS PERITONEAL 4.25% en 2000 mL', 'BOLSA', 0, 0, 0, 0, '0'),
('B05DB0003', 'SOLUCI?N PARA DI?LISIS PERITONEAL 4.25% en 5000 mL', 'BOLSA', 0, 0, 0, 0, '0'),
('B05XA01', 'POTASIO (cloruro) 20 mEq/10 mL', 'AMP/VIAL', 111939, 9328, 5168, 17, '0.6'),
('B05XA02', 'SODIO (bicarbonato) 7.5% (equivalente a 0.892meq/mL)', 'VIAL/BOL', 11600, 967, 5287, 0, '5.5'),
('B05XA0300', 'SODIO (cloruro) 0.45% en 500 mL', 'BOL ', 83077, 6923, 135617, 0, '19.6'),
('B05XA0301', 'SODIO (cloruro) 0.9% en 1000 mL', 'BOL', 506472, 42206, 185969, 0, '4.4'),
('B05XA0302', 'SODIO (cloruro) 0.9% en 250 mL', 'BOL', 260479, 21707, 84879, 0, '3.9'),
('B05XA0303', 'SODIO (cloruro) 0.9% en 500 mL', 'BOL', 603978, 50331, 121529, 3018, '2.4'),
('B05XA05', 'MAGNESIO (sulfato heptahidrato) 10% (100mg/mL)', 'AMP', 197526, 16460, 55466, 0, '3.4'),
('C01AA0500', 'DIGOXINA 0.05 mg/ml', 'FCO', 522, 44, 0, 0, '0'),
('C01AA0501', 'DIGOXINA 0.25 mg', 'TAB', 517622, 43135, 301100, 19737, '7'),
('C01AA0502', 'DIGOXINA 0.25 mg/mL', 'AMP', 8160, 680, 4772, 0, '7'),
('C01BD0100', 'AMIODARONA (clorhidrato) 50mg/mL', 'AMP', 9466, 789, 0, 0, '0'),
('C01BD0101', 'AMIODARONA (clorhidrato) 200 mg', 'TAB', 221233, 18436, 28310, 0, '1.5'),
('C01CA03', 'NORADRENALINA (Norepinefrina) 1mg/ml', 'AMP', 26606, 2217, 0, 0, '0'),
('C01CA04', 'DOPAMINA (clorhidrato)  40mg/mL', 'VIAL', 22649, 1887, 15720, 0, '8.3'),
('C01CA07', 'DOBUTAMINA (clorhidrato) 12.5mg/mL', 'VIAL ', 14869, 1239, 10944, 0, '8.8'),
('C01CA24', 'ADRENALINA (clorhidrato) 1:1000/1mL (1mg/mL)', 'AMP', 74754, 6230, 48535, 0, '7.8'),
('C01CA26', 'EFEDRINA (sulfato) 25mg/mL', 'AMP', 16286, 1357, 87, 8397, '0.1'),
('C01DA02', 'NITROGLICERINA 5mg/ml ', 'VIAL', 664, 55, 0, 0, '0'),
('C01DA08', 'ISOSORBIDE (dinitrato) 5 mg ', 'TAB', 36567, 3047, 9500, 0, '3.1'),
('C01DA14', 'ISOSORBIDE (mononitrato) 20 mg ', 'TAB', 955052, 79588, 627772, 0, '7.9'),
('C01EB10', 'ADENOSINA 3mg/ml ', 'VIAL', 2233, 186, 0, 0, '0'),
('C02AB01', 'ALFAMETILDOPA 500 mg', 'TAB', 780188, 65016, 181317, 0, '2.8'),
('C02DB0200', 'HIDRALAZINA (clorhidrato) 20 mg/mL', 'AMP', 15683, 1307, 0, 0, '0'),
('C02DB0201', 'HIDRALAZINA (clorhidrato) 50 mg', 'TAB', 45644, 3804, 25184, 0, '6.6'),
('C02DD01', 'NITROPRUSIATO de sodio 50mg/ml', 'VIAL', 812, 68, 0, 0, '0'),
('C03AA03', 'HIDROCLOROTIAZIDA 25 mg', 'TAB ', 9364295, 780358, 5724200, 90000, '7.3'),
('C03CA0100', 'FUROSEMIDA 10mg/mL ', 'AMP/VIAL', 407908, 33992, 178702, 0, '5.3'),
('C03CA0101', 'FUROSEMIDA 40 mg', 'TAB', 6755626, 562969, 0, 3700000, '0'),
('C03DA01', 'ESPIRONOLACTONA 100 mg ', 'TAB', 765205, 63767, 424082, 10000, '6.7'),
('C05AX03', 'ANTIHEMORROIDAL', 'TUB', 83640, 6970, 0, 0, '0'),
('C05BX01', 'DOBESILATO DE CALCIO 500mg', 'CAP', 3387099, 282258, 0, 956110, '0'),
('C07AA05', 'PROPRANOLOL 40 mg', 'TAB', 3248790, 270732, 639280, 0, '2.4'),
('C07AB0700', 'BISOPROLOL (fumarato o hemifumarato) 2.5mg', 'TAB', 1788340, 149028, 627700, 13200, '4.2'),
('C07AB0701', 'BISOPROLOL (fumarato o hemifumarato) 10mg ', 'TAB', 4455398, 371283, 427000, 5900, '1.2'),
('C08CA01', 'AMLODIPINO (besilato) 10mg', 'TAB', 4538698, 378225, 0, 91000, '0'),
('C08CA0500', 'NIFEDIPINA 10 mg', 'TAB/CAP', 79516, 6626, 0, 0, '0'),
('C08CA0501', 'NIFEDIPINA 20 mg', 'TAB/CAP', 1320432, 110036, 0, 500000, '0'),
('C08DA01', 'VERAPAMILO  (clorhidrato) 120mg', 'TAB', 0, 0, 198160, 0, '0'),
('C08DA0100', 'VERAPAMILO (clorhidrato) 240 mg', 'TB', 49253, 4104, 0, 0, '0'),
('C09AA0200', 'ENALAPRIL (maleato) 5 mg', 'TAB', 167484, 13957, 0, 0, '0'),
('C09AA0201', 'ENALAPRIL (maleato) 20mg', 'TAB', 11017121, 918093, 5881780, 0, '6.4'),
('C09BA02', 'ENALAPRIL (maleato) 1.25mg/ml', 'VIAL', 10482, 873, 142, 0, '0.2'),
('C09CA04', 'IRBESARTAN 300mg', 'TAB', 19814933, 1651244, 1476980, 0, '0.9'),
('C10AA0500', 'ATORVASTATINA 10mg', 'TAB', 407843, 33987, 378700, 0, '11.1'),
('C10AA0501', 'ATORVASTATINA 40mg', 'TAB', 5093804, 424484, 0, 0, '0'),
('D01AC08', 'KETOCONAZOL 2%', 'TUB', 243221, 20268, 178956, 0, '8.8'),
('D02AC00', 'PETROLATO S?LIDO (parafina blanda)', 'TA', 18750, 1563, 9283, 0, '5.9'),
('D02AF00', '?CIDO SALICILICO  3%-5%', 'TA', 490, 41, 0, 0, '0'),
('D04AX00', 'CALAMINA + ?XIDO DE ZINC al 8% (equivalente a 8g/100mL)', 'FCO', 132119, 11010, 12170, 0, '1.1'),
('D05AX5200', 'CALCIPOTRIOL (monohidrato) + Betametasona (dipropionato) 50mcg+0.5mg ', 'FCO', 1642, 137, 905, 0, '6.6'),
('D05AX5201', 'CALCIPOTRIOL (monohidrato) + Betametasona (dipropionato) 50mcg+0.5mg ', 'TUB', 2424, 202, 581, 0, '2.9'),
('D06AX04', 'POLIMIXINA B 5000 UI. + NEOMICINA 3.5g + BACITRACINA 400 UI ', 'TUB', 82637, 6886, 36546, 0, '5.3'),
('D06BA01', 'SULFADIAZINA DE PLATA 10 mg/g (1%)', 'TUB', 50709, 4226, 20467, 0, '4.8'),
('D07AA02', 'HIDROCORTISONA  (acetato) al 1% (equivalente a 10mg/g)', 'TUB', 195573, 16298, 7040, 18121, '0.4'),
('D07AC01', 'BETAMETASONA (valerato) 0.1% ', 'TUB', 146487, 12207, 11952, 59916, '1'),
('D07AD01', 'CLOBETASOL 0.05%', 'TUB', 4249, 354, 4526, 0, '12.8'),
('D08AC02', 'CLORHEXIDINA (gluconato) 20% V/V', 'GAL', 14340, 1195, 4883, 0, '4.1'),
('D08AC52', 'CLORHEXIDINA (gluconato) 1.5%+CETRIMIDA 15%', 'GAL', 8932, 744, 2317, 0, '3.1'),
('D08AG02', 'YODO 10% + polivinil pirrolidona (yodo povidona)', 'FCO ', 50751, 4229, 32932, 0, '7.8'),
('D08AX00', 'GLUTARALDEHIDO 2% ', 'GAL', 1357, 113, 665, 0, '5.9'),
('G01AF01', 'METRONIDAZOL 0.75%', 'TUB', 94279, 7857, 38122, 4700, '4.9'),
('G01AF02', 'CLOTRIMAZOL 500 mg', 'OV', 614015, 51168, 355250, 0, '6.9'),
('G02AB01', 'ERGONOVINA (maleato)   (metilergometrina) 0.2 mg/1mL', 'AMP', 17885, 1490, 0, 0, '0'),
('G02AD06', 'MISOPROSTOL 200 mcg', 'TAB', 51870, 4323, 23626, 0, '5.5'),
('G02BA02', 'T de COBRE', ' (T Cu 380', 0, 0, 0, 0, '0'),
('G02BB0000', 'CONDON masculino', 'unidad', 0, 0, 22400, 0, '0'),
('G02BB0001', 'CONDON FEMENINO', 'SOBRE', 0, 0, 0, 0, '0'),
('G02CB03', 'CABERGOLINA 0.5 mg ', 'TAB', 568, 47, 2, 0, '0'),
('G03AA05', 'NORETISTERONA (enantato) 50mg + ESTRADIOL (valerato) 5mg', 'AM/JE', 0, 0, 0, 0, '0'),
('G03AA07', 'ETINILESTRADIOL 0.03mg + L-NORGESTREL 0.15mg', 'unidad', 0, 0, 129771, 0, '0'),
('G03AC0300', 'L- NORGESTREL 35 mcg ', 'unidad', 0, 0, 0, 0, '0'),
('G03AC0301', 'LEVONORGESTREL 52mg', 'UNIDAD', 0, 0, 0, 0, '0'),
('G03AC0600', 'MEDROXIPROGESTERONA (acetato) 10 mg', 'unidad', 0, 0, 0, 0, '0'),
('G03AC0601', 'MEDROXIPROGESTERONA (acetato) 150mg/mL', 'unidad', 0, 0, 0, 0, '0'),
('G03AC08', 'ETONORGESTREL 68 mg ', 'unidad', 132, 11, 0, 0, '0'),
('G03CA57', 'ESTROGENOS CONJUGADOS 0.625 mg', 'TAB', 1615, 135, 6851, 0, '50.9'),
('G03XA01', 'DANAZOL 200mg', 'CAP', 9204, 767, 0, 0, '0'),
('G04BD04', 'OXIBUTININA 5 mg', 'TAB', 20760, 1730, 16020, 0, '9.3'),
('G04CA01', 'ALFUZOCINA (clorhidrato) 10 mg', 'TAB', 130360, 10863, 0, 0, '0'),
('H01AC01', 'SOMATROPINA 5 - 12 mg', 'JE', 0, 0, 808, 0, '0'),
('H01BB02', 'OXITOCINA 10 UI', 'AMP', 259753, 21646, 0, 0, '0'),
('H01CB02', 'OCTREOTIDO 0.05mg/ml', 'AMP', 3441, 287, 0, 0, '0'),
('H02AB0200', 'DEXAMETASONA (fosfato) 4mg ', 'TAB', 30000, 2500, 0, 0, '0'),
('H02AB0201', 'DEXAMETASONA (fosfato) 4mg/mL', 'VIAL ', 457381, 38115, 0, 1054560, '0'),
('H02AB0202', 'DEXAMETASONA (fosfato) 4mg/2mL', 'AMP', 0, 0, 2500, 67648, '0'),
('H02AB0400', 'METILPREDNISOLONA (succinato s?dico) 40mg', 'VIAL', 20930, 1744, 13000, 0, '7.5'),
('H02AB0401', 'METILPREDNISOLONA (succinato s?dico) 500mg', 'VIAL', 0, 0, 0, 0, '0'),
('H02AB0402', 'METILPREDNISOLONA (succinato s?dico) 1 g', 'VIAL', 1440, 120, 0, 0, '0'),
('H02AB06', 'PREDNISOLONA BASE  (como fosfato s?dico)15mg/5mL', 'FCO', 9932, 828, 5354, 0, '6.5'),
('H02AB0700', 'PREDNISONA 5 mg', 'TAB', 1926909, 160576, 430320, 0, '2.7'),
('H02AB0701', 'PREDNISONA 50 mg ', 'TAB', 561823, 46819, 511362, 0, '10.9'),
('H02AB0900', 'HIDROCORTISONA (succinato s?dico) 100 mg', 'VIAL', 273313, 22776, 216729, 18483, '9.5'),
('H02AB0901', 'HIDROCORTISONA (succinato s?dico) 500 mg', 'VIAL', 187672, 15639, 0, 0, '0'),
('H03AA01', 'LEVOTIROXINA  (s?dica)  100 mcg', 'TAB', 2075902, 172992, 161350, 0, '0.9'),
('H03BA02', 'PROPILTIOURACILO 50 mg', 'TAB', 1042441, 86870, 312760, 0, '3.6'),
('J01AA02', 'DOXICICLINA (clorhidrato o hiclato) 100mg', 'CAP', 975773, 81314, 297300, 0, '3.7'),
('J01AA12', 'TIGECICLINA 50mg/5ml Polvo IV', 'VIAL', 1200, 100, 0, 0, '0'),
('J01CA01', 'AMPICILINA (anhidra o s?dica) 1g', 'VIAL', 268100, 22342, 276644, 4000, '12.4'),
('J01CA0400', 'AMOXICILINA (trihidrato) 250 mg/ 5mL', 'FCO ', 1008634, 84053, 326800, 53959, '3.9'),
('J01CA0401', 'AMOXICILINA (trihidrato) 500 mg', 'CAP', 14914931, 1242911, 1692100, 0, '1.4'),
('J01CA0405', 'AMOXICILINA+ACIDO CLAVULANICO 200 MG + 28.5 MG', '', 0, 0, 0, 0, '0'),
('J01CF0100', 'DICLOXACILINA (s?dica) 125 mg/5mL', 'FCO ', 200555, 16713, 63138, 0, '3.8'),
('J01CF0101', 'DICLOXACILINA (s?dica) 500 mg', 'CAP', 2569430, 214119, 1664537, 0, '7.8'),
('J01CF04', 'OXACILINA (s?dica) 1g', 'VIAL', 318613, 26551, 63000, 0, '2.4'),
('J01CR01', 'AMPICILINA 1g + SULBACTAM 500mg', 'VIAL', 93859, 7822, 28720, 0, '3.7'),
('J01CR0200', 'AMOXICILINA (trihidrato) 250mg + Acido Clavul?nico (como clavulanato de potasio) 62.5mg/5mL', 'FCO', 81437, 6786, 60093, 0, '8.9'),
('J01CR0201', 'AMOXICILINA (trihidrato)  875 mg + Acido Clavul?nico (como clavulanato de potasio) 125 mg.', 'TAB/CAP', 1201585, 100132, 421280, 435733, '4.2'),
('J01CR05', 'PIPERACILINA (s?dica) 4g + TAZOBACTAM (s?dico) 500mg ', 'VIAL', 124968, 10414, 0, 0, '0'),
('J01DB01', 'CEFALEXINA (monohidrato) 500 mg', 'CAP', 1085583, 90465, 19100, 350374, '0.2'),
('J01DB03 1', 'CEFALOTINA 1g', 'VIAL', 0, 0, 0, 0, '0'),
('J01DB04', 'CEFAZOLINA (s?dica) 1g ', 'FCO', 12238, 1020, 7791, 0, '7.6'),
('J01DC01', 'CEFOXITINA (s?dica) 1g', 'VIAL', 16660, 1388, 58709, 0, '42.3'),
('J01DD0102', 'CEFOTAXIMA (s?dica)  1g', 'Vial', 9940, 828, 19260, 0, '23.3'),
('J01DD02', 'CEFTAZIDIMA ( pentahidrato) 1g', 'VIAL', 67504, 5625, 1937, 0, '0.3'),
('J01DD0400', 'CEFTRIAXONA (s?dica) 250 mg  ', 'VIAL', 230326, 19194, 210788, 0, '11'),
('J01DD0401', 'CEFTRIAXONA (s?dica) 1g', 'VIAL', 965914, 80493, 294110, 68892, '3.7'),
('J01DD08', 'CEFIXIMA (trihidrato)100mg/5mL', 'FCO', 11146, 929, 1552, 0, '1.7'),
('J01DH02', 'MEROPENEM 500mg ', 'FCO', 39794, 3316, 0, 0, '0'),
('J01DH51', 'IMIPENEM (monohidrato) 500mg + CILASTATINA (s?dica) 500mg.', 'VIAL', 116513, 9709, 0, 0, '0'),
('J01EC02', 'SULFADIAZINA 500mg', 'TAB', 3400, 283, 0, 0, '0'),
('J01EE0100', 'TRIMETOPRIM 40 mg + SULFAMETOXAZOL 200mg/5mL', 'FCO ', 486618, 40552, 219744, 0, '5.4'),
('J01EE0101', 'TRIMETOPRIM 160 mg + SULFAMETOXAZOL 800mg', 'TAB', 3806764, 317230, 1067300, 1686932, '3.4'),
('J01FA0101', 'ERITROMICINA (estearato o etilsuccinato) 500 mg (no estolato)', 'TAB', 952570, 79381, 0, 798433, '0'),
('J01FA0102', 'ERITROMICINA (etilsuccinato) 250mg/5mL (no estolato)', 'FCO', 150469, 12539, 69530, 0, '5.5'),
('J01FA0900', 'CLARITROMICINA 250mg/5ml ', 'FCO', 21504, 1792, 5277, 0, '2.9'),
('J01FA0901', 'CLARITROMICINA 500mg', 'TAB/CAP', 167492, 13958, 104260, 0, '7.5'),
('J01FA1000', 'AZITROMICINA (dihidrato) 200mg/5mL', 'FCO ', 352509, 29376, 159000, 2125, '5.4'),
('J01FA1001', 'AZITROMICINA (anhidra o dihidrato) 500mg', 'TAB/CAP', 2069194, 172433, 992932, 546498, '5.8'),
('J01FA1002', 'AZITROMICINA  500mg ', 'VIAL', 1410, 118, 133, 0, '1.1'),
('J01FF0100', 'CLINDAMICINA (palmitato)  75mg/5mL', 'FCO ', 4888, 407, 11081, 0, '27.2'),
('J01FF0101', 'CLINDAMICINA (fosfato) 150mg/mL', 'AMP', 380927, 31744, 58922, 20, '1.9'),
('J01FF0102', 'CLINDAMICINA (clorhidrato) 300 mg', 'CAP', 701790, 58483, 0, 0, '0'),
('J01GA01', 'ESTREPTOMICINA 1g', 'VIAL', 0, 0, 0, 0, '0'),
('J01GB03', 'GENTAMICINA (sulfato) 40mg/mL', 'VIAL ', 275897, 22991, 60805, 0, '2.6'),
('J01GB04', 'KANAMICINA (sulfato) 1 g', 'VIAL', 0, 0, 300, 0, '0'),
('J01GB0600', 'AMIKACINA (sulfato) 50mg/mL', 'VIAL', 81747, 6812, 12535, 0, '1.8'),
('J01GB0601', 'AMIKACINA (sulfato) 250mg/mL', 'VIAL', 95310, 7943, 35303, 67065, '4.4'),
('J01MA0200', 'CIPROFLOXACINA (lactato) 400mg', 'FCO', 0, 0, 0, 0, '0'),
('J01MA0201', 'CIPROFLOXACINA (clorhidrato) 500 mg', 'TAB', 2267110, 188926, 1332190, 0, '7.1'),
('J01MA0203', 'CIPROFLOXACINA (lactato) 200mg', 'VIAL', 16448, 1371, 21563, 9740, '15.7'),
('J01MA12', 'LEVOFLOXACINA 250mg.', 'TB', 0, 0, 0, 0, '0'),
('J01MA1200', 'LEVOFLOXACINA (hemihidrato)750 mg', 'TAB', 197614, 16468, 85920, 450, '5.2'),
('J01MA1201', 'LEVOFLOXACINA 750 mg ', 'VIAL/BOL ', 0, 0, 0, 0, '0'),
('J01MA1202', 'LEVOFLOXACINA 500 mg ', 'VIAL/BOL ', 17631, 1469, 0, 10700, '0'),
('J01MA1203', 'LEVOFLOXACINA 500 MG', 'TB', 0, 0, 14000, 0, '0'),
('J01MA1400', 'MOXIFLOXACION 400 MG', 'TB', 0, 0, 24100, 0, '0'),
('J01XA01', 'VANCOMICINA (clorhidrato) 500 mg', 'VIAL', 106053, 8838, 32294, 0, '3.7'),
('J01XB0200', 'POLIMIXINA B 500', '000 UI,VIA', 1200, 100, 11, 0, '0.1'),
('J01XE01', 'NITROFURANTO?NA 100mg ', 'TAB', 334760, 27897, 68184, 0, '2.4'),
('J01XX0800', 'LINEZOLID 600 MG', 'TB', 0, 0, 16116, 0, '0'),
('J02AA0100', 'ANFOTERICINA B (desoxicolato so?dico o complejo liposomal) 50 mg ', 'FCS', 0, 0, 43, 0, '0'),
('J02AA0101', 'ANFOTERICINA B 50mg', 'VIAL', 1064, 89, 150, 0, '1.7'),
('J02AC0100', 'FLUCONAZOL 2mg/mL', 'VIAL', 9138, 762, 394, 0, '0.5'),
('J02AC0101', 'FLUCONAZOL 10mg/mL', 'FCO ', 2523, 210, 0, 0, '0'),
('J02AC0102', 'FLUCONAZOL 150mg', 'CAP', 370245, 30854, 243550, 0, '7.9'),
('J02AC02', 'ITRACONAZOL 100mg', 'TB', 0, 0, 0, 0, '0'),
('J02AC03', 'VORICONAZOL 200 MG.', 'TB', 0, 0, 784, 120, '0'),
('J02AC0301', 'VORICONAZOL 200 mg', 'VIAL', 0, 0, 70, 0, '0'),
('J02AX06', 'ANIDULAFUNGINA 100mg ', 'FCO', 96, 8, 0, 0, '0'),
('J05AB0100', 'ACICLOVIR 200mg/5mL', 'FCs', 1056, 88, 4112, 0, '46.7'),
('J05AB0101', 'ACICLOVIR (sal s?dica) 250 mg', 'VIAL', 6692, 558, 801, 0, '1.4'),
('J05AB0103', 'ACICLOVIR  400 mg', 'TAB', 611316, 50943, 80370, 310000, '1.6'),
('J06AA0300', 'SUERO ANTIOFIDICO polivalente anticoral ', 'VIAL', 1422, 119, 0, 0, '0'),
('J06AA0301', 'SUERO ANTIOFIDICO polivalente anticrot?lido', 'VIAL', 7240, 603, 2190, 0, '3.6'),
('J06BA02', 'INMUNOGLOBULINA humana hiperinmune  5g/100mL', 'VIAL', 2896, 241, 0, 0, '0'),
('J06BB01', 'INMUNOGLOBULINA ANTI D(RH+) 0.3 mg/mL ? 1500UI', 'VIAL o JE', 3805, 317, 974, 0, '3.1'),
('J06BB02', 'INMUNOGLOBULINA humana antitet?nica 250 U.I.', 'VIAL o JE', 29033, 2419, 9340, 0, '3.9'),
('J06BB04', 'INMUNOGLOBULINA humana antihepatitis B', 'VIAL', 0, 0, 0, 0, '0'),
('J06BB05', 'INMUNOGLOBULINA humana antirr?bica 150U.I.', 'VIAL', 12, 1, 0, 0, '0'),
('L01AA0100', 'CICLOFOSFAMIDA 50mg', 'TAB', 9600, 800, 0, 0, '0'),
('L01AA0101', 'CICLOFOSFAMIDA (monohidrato) 200mg', 'VIAL', 0, 0, 0, 0, '0'),
('L01AA0102', 'CICLOFOSFAMIDA (monohidrato) 500mg', 'VIAL', 6050, 504, 0, 0, '0'),
('L01AA02', 'CLORAMBUCILO (cloruro) 2mg', 'TAB', 0, 0, 0, 0, '0'),
('L01AA03', 'MELFALAN 2mg', 'TAB', 0, 0, 0, 0, '0'),
('L01AA06', 'IFOSFAMIDA 1g', 'VIAL', 2200, 183, 670, 0, '3.7'),
('L01AX0301', 'TEMOZOLAMIDA 100mg ', 'CAP', 5520, 460, 0, 0, '0'),
('L01AX0302', 'TEMOZOLAMIDA 250mg ', 'CAP', 4920, 410, 150, 0, '0.4'),
('L01AX04', 'DACARBAZINA 200mg', 'VIAL', 940, 78, 0, 0, '0'),
('L01BA0100', 'METOTREXATO  2.5mg', 'TAB', 204000, 17000, 0, 0, '0'),
('L01BA0101', 'METOTREXATO 50mg', 'VIAL', 1292, 108, 0, 0, '0'),
('L01BA0102', 'METOTREXATO 500 mg', 'VIAL', 0, 0, 0, 0, '0'),
('L01BB02', '6-MERCAPTOPURINA (6-MP) 50mg', 'TAB', 42000, 3500, 11500, 0, '3.3'),
('L01BB05', 'FLUDARABINA (fosfato)', 'VIAL', 35, 3, 8, 10, '2.7'),
('L01BC0100', 'CITARABINA 100 mg', 'VIAL', 1740, 145, 2259, 0, '15.6'),
('L01BC0101', 'CITARABINA 500 mg', 'VIAL', 1200, 100, 40, 0, '0.4'),
('L01BC02', '5-FLUOROURACILO (5-FU) 50 mg/ml', 'VIAL', 4900, 408, 0, 3210, '0'),
('L01BC0500', 'GEMCITABINA (clorhidrato) 200 mg', 'VIAL', 1440, 120, 240, 0, '2'),
('L01BC0501', 'GEMCITABINA 1 g', 'VIAL', 3800, 317, 1395, 0, '4.4'),
('L01BC06', 'CAPECITABINE 500 mg ', 'TAB', 240000, 20000, 163033, 0, '8.2'),
('L01CA01', 'VINBLASTINA (sulfato) 10 mg', 'VIAL', 96, 8, 0, 0, '0'),
('L01CA02', 'VINCRISTINA (sulfato) 1 mg', 'VIAL', 4900, 408, 0, 0, '0'),
('L01CA04', 'VINORELBINA (bitartrato) 10mg/mL', 'VIAL', 508, 42, 0, 0, '0'),
('L01CB01', 'ETOPOSIDO (VP-16) 20 mg/mL', 'VIAL', 1800, 150, 0, 0, '0'),
('L01CD0100', 'PACLITAXEL 6mg/ml (30mg/5ml)', 'VIAL', 1620, 135, 1100, 0, '8.1'),
('L01CD0102', 'PACLITAXEL 6mg/ml (300mg/50ml)', 'VIAL', 0, 0, 0, 0, '0'),
('L01CD0101', 'PACLITAXEL 6mg/ml (150mg/25ml)', 'VIAL', 3900, 325, 1221, 0, '3.8'),
('L01CD0200', 'DOCETAXEL 20mg ', 'VIAL', 1560, 130, 150, 0, '1.2'),
('L01CD0201', 'DOCETAXEL 80mg', 'VIAL', 2000, 167, 390, 0, '2.3'),
('L01DA01', 'DACTINOMICINA (actinomicina D) 0.5 mg', 'VIAL', 336, 28, 158, 0, '5.6'),
('L01DB0100', 'DOXORRUBICINA  (clorhidrato) 10mg', 'VIAL', 600, 50, 1, 0, '0'),
('L01DB0101', 'DOXORUBICINA (clorhidrato) 50mg', 'VIAL', 5460, 455, 937, 0, '2.1'),
('L01DC01', 'BLEOMICINA (sulfato) 15 UI', 'VIAL', 645, 54, 117, 0, '2.2'),
('L01XA01', 'CISPLATINO 50mg', 'VIAL', 4200, 350, 1257, 0, '3.6'),
('L01XA02', 'CARBOPLATINO 10mg/ml', 'VIAL', 2380, 198, 1023, 0, '5.2'),
('L01XA0300', 'OXALIPLATINO 50mg', 'VIAL', 1050, 88, 1117, 0, '12.8'),
('L01XA0301', 'OXALIPLATINO 100mg', 'VIAL', 2150, 179, 90, 0, '0.5'),
('L01XC0200', 'Rituximab 100mg/10ml', 'VIAL', 1100, 92, 194, 0, '2.1'),
('L01XC0201', 'Rituximab 500mg/50ml', 'VIAL', 980, 82, 779, 0, '9.5'),
('L01XC03', 'Trastuzumab 440mg', 'VIAL', 750, 63, 500, 0, '8'),
('L01XC0600', 'CETUXIMAB 5 mg / ml', 'VIAL', 1424, 119, 0, 0, '0'),
('L01XC0700', 'BEVACIZUMAB 100mg/4mL', 'VIAL', 1490, 124, 1448, 0, '11.7'),
('L01XC0701', 'BEVACIZUMAB 400mg/16mL', 'VIAL', 1190, 99, 1173, 0, '11.8'),
('L01XE03', 'ERLOTINIB (clorhidrato) 150 mg', 'TAB', 5940, 495, 0, 0, '0'),
('L01XX02', 'L-ASPARAGINASA 10', '000 UI,VIA', 1560, 130, 913, 0, '7'),
('L01XX05', 'HIDROXIUREA 500mg (hidroxicarbamida)', 'CAP', 2400, 200, 1850, 0, '9.3'),
('L01XX09', 'MILTEFOSINA 10mg', 'TB', 0, 0, 4408, 0, '0'),
('L01XX0901', 'MILTEFOSINA 50mg', 'TB', 0, 0, 4568, 0, '0'),
('L01XX19', 'IRINOTECANO (clorhidrato) 20 mg/mL', 'VIAL', 740, 62, 90, 0, '1.5'),
('L01XX3200', 'BORTEZOMIB 3.5 mg', 'VIAL', 120, 10, 48, 0, '4.8'),
('L02AE03', 'GOSERELINA (acetato) 10.8 mg', 'JE', 1000, 83, 835, 0, '10'),
('L02BA01', 'TAMOXIFENO (citrato) 20 mg', 'TAB', 146430, 12203, 43340, 0, '3.6'),
('L02BB03', 'BICALUTAMIDA 50mg ', 'TAB', 8600, 717, 0, 0, '0'),
('L02BG06', 'EXEMESTANO  25 mg ', 'GG', 57000, 4750, 2414, 0, '0.5'),
('L02BX0300', 'ABIRATERONA 250 mg', 'TB', 17160, 1430, 4440, 0, '3.1'),
('L03AA02', 'FILGRASTIM (factor estimulador de colonias de granulocitos) 300 mcg/ml (30 millones UI)', 'VIAL o JE/', 13560, 1130, 0, 0, '0'),
('L03AB07', 'INTERFER?N BETA 1A 22 - 44 mcg   ( 30mcg/0.5 ml IM )', 'VIAL/JE', 4480, 373, 1536, 0, '4.1'),
('L03AB0700', 'INTERFERON BETA 1-A 44 MCG', 'VIAL', 0, 0, 177, 0, '0'),
('L03AB0701', 'INTERFERON BETA 1-A ( 10 MCG )', '', 0, 0, 0, 0, '0'),
('L04AA06', 'MICOFENOLATO (mofetilo) 500mg', 'TAB', 60000, 5000, 0, 0, '0'),
('L04AA13', 'LEFLUNAMIDA 20mg', 'TAB', 150000, 12500, 26530, 0, '2.1'),
('L04AC0700', 'TOCILIZUMAB  80mg', 'FCO', 1872, 156, 25, 0, '0.2'),
('L04AC0701', 'TOCILIZUMAB 200mg', 'FCO', 1872, 156, 535, 750, '3.4'),
('L04AD0100', 'CICLOSPORINA 25 mg', 'CP', 0, 0, 0, 0, '0'),
('L04AD0101', 'CICLOSPORINA 100mg/mL', 'FCO ', 240, 20, 63, 0, '3.2'),
('L04AD0102', 'CICLOSPORINA 100mg', 'CAP', 6600, 550, 750, 0, '1.4'),
('L04AX01', 'AZATIOPRINA 50mg', 'TAB', 48000, 4000, 0, 0, '0'),
('M01AB05', 'DICLOFENACO (s?dico) 25mg/mL', 'AMP', 851732, 70978, 239548, 0, '3.4'),
('M01AE0100', 'IBUPROFENO 100 mg/5 mL', 'FCO ', 557508, 46459, 62598, 150000, '1.3'),
('M01AE0101', 'IBUPROFENO 600 mg', 'TAB ', 13885243, 1157104, 9786286, 0, '8.5'),
('M01AE01400', 'IBUPROFENO 400MG', 'TAB ', 0, 0, 1000, 0, '0'),
('M01AE17', 'DESKETOPROFENO (trometanol) 25mg/Ml', 'AMP', 680506, 56709, 238000, 0, '4.2'),
('M02AX10', 'SALICILATO DE METILO 5%', 'TA', 22084, 1840, 20284, 0, '11'),
('M03AB01', 'SUCCINILCOLINA (cloruro) 50 mg/ml', 'VIAL', 4900, 408, 0, 0, '0'),
('M03AC01', 'PANCURONIO (bromuro) 2mg/ml', 'AMP', 0, 0, 0, 0, '0'),
('M03AC04', 'ATRACURIO (besilato) 10mg/ml', 'AMP', 54251, 4521, 0, 0, '0'),
('M03BA03', 'METOCARBAMOL 500 mg', 'TAB', 3681193, 306766, 1794000, 0, '5.8'),
('M04AA0100', 'ALOPURINOL 100 mg', 'TAB ', 101169, 8431, 20950, 0, '2.5'),
('M04AA0101', 'ALOPURINOL 300 mg', 'TAB', 735840, 61320, 83960, 57300, '1.4'),
('M04AC01', 'COLCHICINA 0.5 mg ', 'TAB', 235776, 19648, 240006, 0, '12.2'),
('N01AB08', 'SEVOFLUORANE 100% v/v', 'VIAL', 5059, 422, 0, 0, '0'),
('N01AF03', 'TIOPENTAL (s?dico) 1 g', 'VIAL', 2022, 169, 0, 2000, '0'),
('N01AH01', 'FENTANILO (citrato)  0.05mg/mL', 'VIAL ', 35605, 2967, 0, 0, '0'),
('N01AX03', 'KETAMINA (clorhidrato) 50mg/mL', 'VIAL', 2923, 244, 3, 1300, '0'),
('N01AX10', 'PROPOFOL+E.D.T.A. 1% (equivalente a 10mg/mL).', 'AMP/JE', 0, 0, 0, 0, '0'),
('N01AX1000', 'PROPOFOL 1% (equivalente a 10mg/ml)', 'VIAL', 57851, 4821, 15, 0, '0'),
('N01BB01', 'BUPIVACAINA   5mg/mL (0.5%) (sin preservantes derivados del parabeno)', 'VIAL', 7563, 630, 4039, 0, '6.4'),
('N01BB0200', 'LIDOCAINA (clorhidrato) 2%', '  sin vaso', 180661, 15055, 0, 0, '0'),
('N01BB0201', 'LIDOCAINA 2% (equivalente a 20mg/mL); con preservantes', 'VIAL', 6256, 521, 1676, 0, '3.2'),
('N01BB0202', 'LIDOCAINA 2% (equivalente a 20mg/mL); sin preservantes derivados del parabeno) ', 'VIAL', 45608, 3801, 0, 0, '0'),
('N01BB0203', 'LIDOCAINA 10% (equivalente a 100mg/mL)', 'FCO', 2653, 221, 708, 0, '3.2'),
('N01BB51', 'BUPIVACAINA  5mg/mL (0.5%)+ GLUCOSA 7.5-8%/mL;  (sin preservantes derivados del parabeno)', 'AMP/VIAL', 51003, 4250, 16540, 0, '3.9'),
('N01BB5202', 'LIDOCAINA (clorhidrato) 2% + epinefrina 1:100', '000 sin va', 226603, 18884, 32575, 0, '1.7'),
('N01BB5204', 'LIDOCAINA  2% + EPINEFRINA 1:200', '000 (con p', 5155, 430, 0, 0, '0'),
('N01BB5205', 'LIDOCAINA 2% + EPINEFRINA 1:200', '000 (sin p', 9724, 810, 1762, 0, '2.2'),
('N01BB5206', 'LIDOCAINA (clorhidrato) 2% + epinefrina 1:80000 ', 'CART', 0, 0, 0, 0, '0'),
('N02AA0100', 'MORFINA (sulfato) 10 mg', 'TB', 0, 0, 0, 0, '0'),
('N02AA0101', 'MORFINA (sulfato o clorhidrato) 10mg/mL   ', 'AMP', 22394, 1866, 0, 0, '0'),
('N02AA0103', 'MORFINA (clorhidrato trihidrato) 30mg', 'TB', 18000, 1500, 12997, 0, '8.7'),
('N02AA05', 'OXICODONA (clorhidrato)  20mg ', 'TAB', 33400, 2783, 0, 0, '0'),
('N02AB02', 'MEPERIDINA (clorhidrato) 50 mg/mL', 'AMP', 18013, 1501, 2364, 0, '1.6'),
('N02AX02', 'TRAMADOL (clorhidrato) 50mg/mL', 'AMP', 339699, 28308, 0, 0, '0'),
('N02BE0100', 'ACETAMINOFEN  100mg/mL', 'FCO', 199745, 16645, 550, 0, '0'),
('N02BE0101', 'ACETAMINOFEN 120mg/5mL', 'FCO', 1681041, 140087, 1876320, 4806, '13.4'),
('N02BE0102', 'ACETAMINOFEN 500 mg', 'TAB', 40608509, 3384042, 1600, 5270000, '0'),
('N02BE0103', 'ACETAMINOFEN 10 mg / ml', 'VIAL', 29205, 2434, 8999, 0, '3.7'),
('N03AA0200', 'FENOBARBITAL (s?dico) 30-32 mg', 'TB', 35731, 2978, 0, 0, '0'),
('N03AA0201', 'FENOBARBITAL (s?dico) 100 mg', 'TAB', 2896048, 241337, 1888110, 0, '7.8'),
('N03AA0202', 'FENOBARBITAL (s?dico) 130 mg/2ml', 'Amp', 9753, 813, 1541, 0, '1.9'),
('N03AA0203', 'FENOBARBITAL (s?dico) 130 mg/ml', 'AMP', 0, 0, 0, 0, '0'),
('N03AB0200', 'FENITOINA (s?dica) 25 mg/ml', 'FCO', 12840, 1070, 13114, 0, '12.3'),
('N03AB0201', 'FENITOINA (s?dica) 50 mg/mLl', 'AMP/VIAL', 62315, 5193, 11858, 0, '2.3'),
('N03AB0203', 'FENITOINA (s?dica)100 mg', 'CAP', 4214449, 351204, 903880, 0, '2.6'),
('N03AE01', 'CLONAZEPAM  2 mg', 'TAB', 2870927, 239244, 756220, 0, '3.2'),
('N03AF01', 'CARBAMACEPINA 200 mg', 'TAB', 8762361, 730197, 433072, 0, '0.6'),
('N03AG0100', 'VALPROATO (s?dico) 100mg/mL', 'AMP', 6102, 509, 0, 0, '0'),
('N03AG0101', 'VALPROATO (s?dico) 200 mg/mL', 'FCO ', 47188, 3932, 7997, 0, '2'),
('N03AG0102', 'VALPROATO (s?dico) 500 mg', 'TAB', 3743261, 311938, 1262970, 0, '4'),
('N03AX1100', 'TOPIRAMATO 25mg', 'TAB', 39600, 3300, 3600, 0, '1.1'),
('N03AX1101', 'TOPIRAMATO 100mg', 'TAB', 204000, 17000, 38670, 0, '2.3'),
('N04AA0200', 'BIPERIDENO (clorhidrato) 2 mg', 'TAB', 305293, 25441, 99540, 0, '3.9'),
('N04AA0201', 'BIPERIDENO (lactato) 5mg/mL', 'AMP/VIAL', 764, 64, 0, 0, '0'),
('N04BA02', 'LEVODOPA 250mg + carbidopa 25 mg', 'TAB ', 329937, 27495, 91350, 0, '3.3'),
('N04BD01', 'SELEGILINA (clorhidrato) 5 mg', 'TAB', 13350, 1113, 0, 0, '0'),
('N05AB02', 'FLUFENAZINA (decanoato  o enantato) 25mg/1mL', 'AMP', 34701, 2892, 16100, 0, '5.6'),
('N05AD0100', 'HALOPERIDOL  5 mg/mL', 'AMP', 35732, 2978, 0, 6000, '0'),
('N05AD0101', 'HALOPERIDOL 5mg', 'TAB', 260108, 21676, 334010, 0, '15.4'),
('N05AH0200', 'CLOZAPINA 25 mg', 'TAB', 0, 0, 0, 0, '0'),
('N05AH0201', 'CLOZAPINA 100 mg', 'TAB', 766000, 63833, 105300, 0, '1.6'),
('N05AH0300', 'OLANZAPINA 10 mg', 'FCO', 1232, 103, 0, 8, '0'),
('N05AH04', 'QUETIAPINA (fumarato) 300mg ', 'TAB', 1038780, 86565, 141710, 0, '1.6'),
('N05AN01', 'LITIO (carbonato) 300 mg', 'TAB/CAP', 713946, 59496, 313400, 0, '5.3'),
('N05AX0800', 'RISPERIDONA 1 mg', 'TB', 0, 0, 0, 0, '0'),
('N05AX0801', 'RISPERIDONA 3 mg', 'TAB', 1980000, 165000, 0, 0, '0'),
('N05BA01', 'DIAZEPAN 5mg/mL', 'AMP', 85561, 7130, 36715, 0, '5.1'),
('N05BA06', 'LORAZEPAM 2mg ', 'TAB', 845208, 70434, 209870, 0, '3'),
('N05CD0800', 'MIDAZOLAN (clorhidrato) 1mg/mL', 'AMP', 34377, 2865, 0, 4000, '0'),
('N05CD0801', 'MIDAZOLAN (clorhidrato) 5mg/mL', 'VIAL', 15845, 1320, 0, 0, '0'),
('N06AA02', 'IMIPRAMINA (clorhidrato) 25 mg', 'TAB ', 476411, 39701, 170332, 0, '4.3'),
('N06AA09', 'AMITRIPTILINA (clorhidrato) 25 mg', 'TAB', 2346903, 195575, 671000, 0, '3.4'),
('N06AB03', 'FLUOXETINA (clorhidrato) 20mg', 'TAB/CAP', 1275506, 106292, 0, 319840, '0'),
('N06AB06', 'SERTRALINA (clorhidrato) 50 mg', 'TAB', 1486580, 123882, 0, 336000, '0'),
('N07AA01', 'NEOSTIGMINA (metil sulfato) 0.5mg/mL', 'AMP', 12901, 1075, 0, 0, '0'),
('N07AA02', 'PIRIDOSTIGMINA (metilbromuro) 60 mg', 'TAB', 39600, 3300, 0, 0, '0'),
('N07CA0000', 'DIMENHIDRINATO 25mg', 'SUP', 3633, 303, 0, 0, '0'),
('N07CA0001', 'DIMENHIDRINATO 50mg/ml', 'AMP/VIAL', 29253, 2438, 2187, 0, '0.9'),
('P01AB0100', 'METRONIDAZOL (benzoato) 125mg/5mL', 'FCO', 210724, 17560, 275418, 0, '15.7'),
('P01AB0101', 'METRONIDAZOL 500 mg', 'VIAL/BOL', 173701, 14475, 191219, 0, '13.2'),
('P01AB0103', 'METRONIDAZOL 500 mg ', 'TB', 251312, 20943, 11240, 0, '0.5'),
('P01BA0104', 'METRONIDAZOL 5 MG/ML INFUSION', '', 0, 0, 7989, 0, '0'),
('P01AB02', 'TINIDAZOL 500 mg', 'TAB', 914867, 76239, 3710, 81600, '0'),
('P01BA02', 'HIDROXICLOROQUINA (base)  310mg ', 'TAB', 144000, 12000, 314, 0, '0'),
('P02CA03400', 'ALBENDAZOL 400 MG', 'TB', 1409764, 117480, 354000, 0, '3'),
('P02CA0300', 'ALBENDAZOL 200 mg', 'TAB', 0, 0, 0, 0, '0'),
('P02CA0301', 'ALBENDAZOL 200 mg/5mL', 'FCO', 358107, 29842, 142886, 0, '4.8'),
('P02DA01', 'NICLOSAMIDA 500 mg', 'TAB', 11062, 922, 0, 0, '0'),
('P03AC0400', 'PERMETRINA 1 %', 'FCO ', 50828, 4236, 0, 0, '0'),
('P03AC0401', 'PERMETRINA 5%', 'TUB', 39608, 3301, 19315, 0, '5.9'),
('R01AD01', 'BECLOMETASONA (dipropionato) 50mcg/disparo', 'FCO', 44776, 3731, 0, 0, '0'),
('R03AC0200', 'SALBUTAMOL (sulfato) 100 mcg /disparo', 'FCO', 244745, 20395, 151686, 0, '7.4'),
('R03AC0201', 'SALBUTAMOL 2 mg/5ml', 'FCO', 0, 0, 0, 0, '0'),
('R03AC0202', 'SALBUTAMOL (sulfato) 5 mg/mL (0.5%)', 'FCO', 77852, 6488, 56136, 0, '8.7'),
('R03AK0700', 'BUDESONIDA + FORMOTEROL 160-200 mcg + 4.5-6 mcg', 'FCO', 6680, 557, 4963, 0, '8.9'),
('R03BA0100', 'BECLOMETASONA (dipropionato 50) mcg/disparo', 'FCO', 74261, 6188, 15355, 0, '2.5'),
('R03BA0101', 'BECLOMETASONA (dipropionato) 250 mcg/disparo', 'FCO', 134417, 11201, 5268, 0, '0.5'),
('R03BB0100', 'IPRATROPIO (bromuro) 20 mcg/disparo', ' FCO', 92256, 7688, 8624, 0, '1.1'),
('R03BB0101', 'IPRATROPIO  (bromuro) 250 mcg/mL', 'FCO ', 48346, 4029, 12353, 0, '3.1'),
('R03DA0400', 'TEOFILINA (anhidra) 80mg/15 ml', 'FCO', 438, 37, 0, 0, '0'),
('R03DA0401', 'TEOFILINA 250 mg', 'TAB', 0, 0, 0, 0, '0'),
('R03DA05', 'AMINOFILINA 250 mg', 'AMP', 21988, 1832, 0, 0, '0'),
('R06AA0200', 'DIFENHIDRAMINA 2.5mg/ml', 'FCO', 455714, 37976, 54636, 630, '1.4'),
('R06AA0201', 'DIFENHIDRAMINA (clorhidrato) 10mg/mL', 'VIAL', 128018, 10668, 37954, 0, '3.6'),
('R06AA0203', 'DIFENHIDRAMINA 50 mg', 'TAB/CAP', 3759418, 313285, 1738500, 0, '5.5'),
('R06AX1300', 'LORATADINA 1 mg/mL', 'FCO ', 345770, 28814, 356737, 0, '12.4'),
('R06AX1301', 'LORATADINA 10 mg', 'TAB', 4627306, 385609, 302750, 0, '0.8'),
('R07AA30', 'SURFACTANTE EXOGENO PULMONAR NATURAL 25mg/mL', 'VIAL', 1491, 124, 0, 0, '0'),
('S01AA01', 'CLORANFENICOL 0.5%', 'FCO', 107286, 8940, 0, 0, '0'),
('S01AA10', 'NATAMICINA 5%', 'FCO', 312, 26, 0, 0, '0'),
('S01AA11', 'GENTAMICINA (sulfato) 0.3%', 'FCO', 90530, 7544, 34806, 0, '4.6'),
('S01AA12', 'TOBRAMICINA 0.3%', 'FCO', 1510, 126, 317, 0, '2.5'),
('S01AA30', 'OXITETRACICLINA (clorhidrato) 5mg/g + POLIMIXINA B (sulfato) 10', '000UI/g,TU', 47636, 3970, 53973, 0, '13.6'),
('S01AD03', 'ACICLOVIR 3%', 'TUB', 25902, 2159, 15394, 0, '7.1'),
('S01AE07', 'MOXIFLOXACINA 0.5%', 'FCO', 1820, 152, 0, 0, '0'),
('S01BA07', 'FLUOROMETOLONA 0.1%', 'FCO', 1920, 160, 0, 0, '0'),
('S01CA08', 'METILPREDNISOLONA (acetato) 0.5%', 'FCO', 120, 10, 0, 0, '0'),
('S01EC01', 'ACETAZOLAMIDA 250mg', 'TAB', 13520, 1127, 13430, 0, '11.9'),
('S01ED01', 'TIMOLOL (maleato) 0.5%', 'FCO', 3180, 265, 6844, 0, '25.8'),
('S01ED5100', 'TIMOLOL (maleato) + DORZOLAMIDA (hidrocloruro) 5 mg/ml + 20 mg/ml', 'FCO/GOTERO', 2580, 215, 2500, 0, '11.6'),
('S01EE01', 'LATANOPROST 0.005%', 'FCO', 5185, 432, 1710, 0, '4'),
('S01FA01', 'ATROPINA 1%', 'FCO', 1236, 103, 1021, 0, '9.9'),
('S01FA0600', 'TROPICAMIDA 1%', 'TUB', 1200, 100, 0, 0, '0'),
('S01GA01', 'NAFAZOLINA 0.1%', 'FCO', 3291, 274, 142, 0, '0.5'),
('S01GX07', 'AZELASTINA (clorhidrato) 0.05%', 'FCO', 2460, 205, 0, 0, '0'),
('S01HA03', 'TETRACAINA 0.5%', 'FCO', 1220, 102, 0, 0, '0'),
('S01XA1800', 'CICLOSPORINA 0.1%', 'TUB', 0, 0, 0, 0, '0'),
('S01XA20', 'METILCELULOSA 0.5%', 'FCO', 25670, 2139, 16897, 0, '7.9'),
('V03AB14', 'PROTAMINA (sulfato) 10 mg/mL (1000 U.I../mL)', 'AMP', 16, 1, 0, 0, '0'),
('V03AB15', 'NALOXONA (clorhidrato) 0.4 mg/mL', 'AMP', 4949, 412, 2046, 0, '5'),
('V03AB2300', 'ACETILCISTE?NA  100mg/mL', 'AM', 1266, 106, 0, 0, '0'),
('V03AB25', 'FLUMAZENIL  0.1mg/mL', 'AMP', 356, 30, 0, 0, '0'),
('V03AE0100', 'POLIESTIRENO SULFONATO 12 g', 'SOBRE', 0, 0, 38, 0, '0'),
('V03AF01', 'MESNA (mercapto sulfonato de sodio) 100 mg/ml', 'AMP', 3720, 310, 31, 0, '0.1'),
('V03AF0300', 'FOLINATO DE CALCIO 15 mg (Leucovorina c?lcica)', 'TAB', 0, 0, 0, 0, '0'),
('V03AF0301', 'FOLINATO DE CALCIO 50mg  (Leucovorina c?lcica)', 'VIAL', 4170, 348, 0, 0, '0'),
('V04CF01', 'TUBERCULINA PPD (Derivado Proteico purificado)', 'VIAL', 0, 0, 0, 0, '0'),
('V07AB0000', 'AGUA DESTILADA 10 mL', 'VIAL', 576562, 48047, 231649, 0, '4.8'),
('V07AB0001', 'AGUA DESTILADA 500 mL', 'VIAL/BOL', 173335, 14445, 20793, 0, '1.4'),
('V07AV0000', '?CIDO  TRICLOROAC?TICO 80 al 90%', 'FCO', 1099, 92, 0, 0, '0'),
('V07AV0001', 'GEL LUBRICANTE ESTERIL  ', 'TUB', 30159, 2513, 5111, 0, '2'),
('V08AB02', 'IOHEXOL ', 'VIAL', 1200, 100, 1175, 0, '11.8'),
('V08AB04', 'IOPAMIDOL ', 'VIAL', 3542, 295, 1150, 0, '3.9'),
('V08BA01', 'BARIO (sulfato) + EFERVESCENTE', 'FCO', 0, 0, 0, 0, '0'),
('V08BA0200', 'BARIO (sulfato) BD', 'BALDE', 0, 0, 0, 0, '0'),
('V08BA0201', 'BARIO (sulfato) 400 - 570 g', 'SET', 0, 0, 0, 0, '0'),
('P02CF0100', 'IVERMECTINA vo 6mg', 'TB', 0, 0, 425024, 0, '0'),
('P02CF0101', ' Ivermectina 6 MG/ML 0.6% ', 'GOTAS', 0, 0, 0, 0, '0'),
('A12CB0102', 'ZINC 100mg', 'TB', 0, 0, 4336610, 0, '0'),
('A12CB0101', 'ZINC 50mg', 'TB', 0, 0, 0, 0, '0'),
('B01AF0100', 'RIVAROXABAN 20 mg', 'CM', 0, 0, 41478, 0, '0'),
('D08AX0701', 'HIPOCLORITO DE SODIO 240 ml', 'FC', 0, 0, 50150, 65975, '0'),
('D08AX0702', 'MICRODACYN 5 lts', '', 0, 0, 0, 0, '0'),
('L04AC0702', 'TOCILIZUMAB 20mg', 'VIAL', 0, 0, 0, 0, '0'),
('L04AC0703', 'TOCILIZUMAB 162 mg/0.9 ml', 'VIAL', 0, 0, 0, 0, '0'),
('P01BA0200', 'HIDROXICLOROQUINA (base) 200 mg', '', 0, 0, 458820, 0, '0'),
('P01BA0201', 'HIDROXICLOROQUINA ( base ) 100 MG', '', 0, 0, 602308, 0, '0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `idusuario` int(11) NOT NULL,
  `nombre` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `correo` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `usuario` varchar(20) COLLATE utf8_spanish_ci NOT NULL,
  `clave` varchar(50) COLLATE utf8_spanish_ci NOT NULL,
  `rol` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idusuario`, `nombre`, `correo`, `usuario`, `clave`, `rol`) VALUES
(1, 'Informaticos', 'vida@gmail.com', 'admin', '21232f297a57a5a743894a0e4a801fc3', 1),
(10, 'Alex', 'alexisdiaz081993@gmail.com', 'Adiaz', '202cb962ac59075b964b07152d234b70', 2);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idcliente`);

--
-- Indices de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `detallefactura`
--
ALTER TABLE `detallefactura`
  ADD PRIMARY KEY (`correlativo`);

--
-- Indices de la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  ADD PRIMARY KEY (`correlativo`);

--
-- Indices de la tabla `entradas`
--
ALTER TABLE `entradas`
  ADD PRIMARY KEY (`correlativo`);

--
-- Indices de la tabla `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`nofactura`);

--
-- Indices de la tabla `hospitales`
--
ALTER TABLE `hospitales`
  ADD PRIMARY KEY (`id_hospital`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`codproducto`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`codproveedor`);

--
-- Indices de la tabla `regiones`
--
ALTER TABLE `regiones`
  ADD PRIMARY KEY (`id_region`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`idrol`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idusuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idcliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `detallefactura`
--
ALTER TABLE `detallefactura`
  MODIFY `correlativo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  MODIFY `correlativo` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `entradas`
--
ALTER TABLE `entradas`
  MODIFY `correlativo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `factura`
--
ALTER TABLE `factura`
  MODIFY `nofactura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `hospitales`
--
ALTER TABLE `hospitales`
  MODIFY `id_hospital` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;
--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `codproducto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `codproveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `regiones`
--
ALTER TABLE `regiones`
  MODIFY `id_region` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
