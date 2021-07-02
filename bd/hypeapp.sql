-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 29-06-2021 a las 20:47:14
-- Versión del servidor: 8.0.21
-- Versión de PHP: 7.4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `hypeapp`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `banquetes`
--

DROP TABLE IF EXISTS `banquetes`;
CREATE TABLE IF NOT EXISTS `banquetes` (
  `idBanquete` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(25) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`idBanquete`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `banq_event`
--

DROP TABLE IF EXISTS `banq_event`;
CREATE TABLE IF NOT EXISTS `banq_event` (
  `idBanquete` int NOT NULL,
  `idEvento` int NOT NULL,
  `descp_extra` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  KEY `idEvento` (`idEvento`),
  KEY `idBanquete` (`idBanquete`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `datos`
--

DROP TABLE IF EXISTS `datos`;
CREATE TABLE IF NOT EXISTS `datos` (
  `idDato` int NOT NULL AUTO_INCREMENT,
  `idNacionalidad` int NOT NULL,
  `idPerfil` int NOT NULL,
  `nombres` varchar(80) COLLATE utf8_bin NOT NULL,
  `ap_pat` varchar(40) COLLATE utf8_bin NOT NULL,
  `ap_mat` varchar(40) COLLATE utf8_bin NOT NULL,
  `email` varchar(50) COLLATE utf8_bin NOT NULL,
  `tel` varchar(10) COLLATE utf8_bin NOT NULL,
  `empresa` varchar(70) COLLATE utf8_bin NOT NULL,
  `pass` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `estatus` enum('Activo','Desactivado','Pausado') CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (`idDato`),
  KEY `idPerfil` (`idPerfil`),
  KEY `idNacionalidad` (`idNacionalidad`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `datos`
--

INSERT INTO `datos` (`idDato`, `idNacionalidad`, `idPerfil`, `nombres`, `ap_pat`, `ap_mat`, `email`, `tel`, `empresa`, `pass`, `estatus`) VALUES
(1, 2, 2, 'Patricio', 'Lopez', 'Gonzalez', 'patricio_gonzalez@gmail.com', '9987145651', 'Trabajador', '123456Pg*', 'Activo'),
(2, 1, 1, 'Abner', 'Cetzal', 'Hernandez', 'abner_cetzal@gmail.com', '9987456211', 'Hotel Azteca', '124789Ac*', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `eventos`
--

DROP TABLE IF EXISTS `eventos`;
CREATE TABLE IF NOT EXISTS `eventos` (
  `idEvento` int NOT NULL AUTO_INCREMENT,
  `idDato` int NOT NULL,
  `idTipo_Evento` int NOT NULL,
  `nombre` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `descripcion` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `fecha` date NOT NULL,
  `hor_inicial` time NOT NULL,
  `hor_final` time NOT NULL,
  `locacion` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `locacion_resp` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `estatus` enum('Sin Empezar','En Proceso','Finalizado','') COLLATE utf8_bin NOT NULL DEFAULT 'Sin Empezar',
  PRIMARY KEY (`idEvento`),
  KEY `idDato` (`idDato`),
  KEY `idTipo_Evento` (`idTipo_Evento`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `list_prod_serv_event`
--

DROP TABLE IF EXISTS `list_prod_serv_event`;
CREATE TABLE IF NOT EXISTS `list_prod_serv_event` (
  `idBanquete` int NOT NULL,
  `idProducto_Servicio` int NOT NULL,
  `idEvento` int NOT NULL,
  `idDato` int NOT NULL,
  `respuesta` enum('Aceptado','Rechazado','En Espera') COLLATE utf8_bin NOT NULL DEFAULT 'En Espera',
  KEY `idProducto_Servicio` (`idProducto_Servicio`),
  KEY `idBanquete` (`idBanquete`),
  KEY `Index_Evento` (`idEvento`),
  KEY `Index_Dato` (`idDato`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nacionalidades`
--

DROP TABLE IF EXISTS `nacionalidades`;
CREATE TABLE IF NOT EXISTS `nacionalidades` (
  `idNacionalidad` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(25) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`idNacionalidad`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `nacionalidades`
--

INSERT INTO `nacionalidades` (`idNacionalidad`, `nombre`) VALUES
(1, 'Mexicano'),
(2, 'Mexicana'),
(3, 'Estadounidense');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

DROP TABLE IF EXISTS `notificaciones`;
CREATE TABLE IF NOT EXISTS `notificaciones` (
  `idDato` int NOT NULL,
  `idTipo_Notificacion` int NOT NULL,
  `mensaje` text COLLATE utf8_bin NOT NULL,
  `estatus` enum('Activo','Finalizado') COLLATE utf8_bin NOT NULL,
  KEY `Index_Tipo_Notificacion` (`idTipo_Notificacion`),
  KEY `Index_Dato` (`idDato`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perfiles`
--

DROP TABLE IF EXISTS `perfiles`;
CREATE TABLE IF NOT EXISTS `perfiles` (
  `idPerfil` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(25) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`idPerfil`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `perfiles`
--

INSERT INTO `perfiles` (`idPerfil`, `nombre`) VALUES
(1, 'Organizador'),
(2, 'Proveedor');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos_servicios`
--

DROP TABLE IF EXISTS `productos_servicios`;
CREATE TABLE IF NOT EXISTS `productos_servicios` (
  `idProducto_Servicio` int NOT NULL AUTO_INCREMENT,
  `idTipo` int NOT NULL,
  `idDato` int NOT NULL,
  `nombre` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `descripcion` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `imagen` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `precio` double(12,2) NOT NULL,
  `estatus` enum('Activo','Desactivado') COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`idProducto_Servicio`),
  KEY `idTipo` (`idTipo`),
  KEY `idDato` (`idDato`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos`
--

DROP TABLE IF EXISTS `tipos`;
CREATE TABLE IF NOT EXISTS `tipos` (
  `idTipo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(25) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`idTipo`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `tipos`
--

INSERT INTO `tipos` (`idTipo`, `nombre`) VALUES
(1, 'Producto'),
(2, 'Servicio');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_eventos`
--

DROP TABLE IF EXISTS `tipos_eventos`;
CREATE TABLE IF NOT EXISTS `tipos_eventos` (
  `idTipo_Evento` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(25) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`idTipo_Evento`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `tipos_eventos`
--

INSERT INTO `tipos_eventos` (`idTipo_Evento`, `nombre`) VALUES
(1, 'Social'),
(2, 'Empresarial'),
(3, 'Otro');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_notificaciones`
--

DROP TABLE IF EXISTS `tipos_notificaciones`;
CREATE TABLE IF NOT EXISTS `tipos_notificaciones` (
  `idTipo_Notificacion` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(25) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`idTipo_Notificacion`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `tipos_notificaciones`
--

INSERT INTO `tipos_notificaciones` (`idTipo_Notificacion`, `nombre`) VALUES
(1, 'Respuesta'),
(2, 'Aviso');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
