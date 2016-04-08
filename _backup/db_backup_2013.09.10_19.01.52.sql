-- -------------------------------------------
SET AUTOCOMMIT=0;
START TRANSACTION;
SET SQL_QUOTE_SHOW_CREATE = 1;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
-- -------------------------------------------
-- -------------------------------------------
-- START BACKUP
-- -------------------------------------------
-- -------------------------------------------
-- TABLE `bonification`
-- -------------------------------------------
DROP TABLE IF EXISTS `bonification`;
CREATE TABLE IF NOT EXISTS `bonification` (
  `bonification_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `amount` float DEFAULT NULL,
  `year` int(11) NOT NULL,
  `contract_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`bonification_id`),
  KEY `fk_bonification_contract1_idx` (`contract_id`),
  CONSTRAINT `fk_bonification_contract1` FOREIGN KEY (`contract_id`) REFERENCES `contract` (`contract_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE `charge`
-- -------------------------------------------
DROP TABLE IF EXISTS `charge`;
CREATE TABLE IF NOT EXISTS `charge` (
  `charge_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(10) unsigned NOT NULL,
  `charge_date` date DEFAULT NULL,
  `charge_mount` float DEFAULT NULL,
  `charged_period` varchar(45) DEFAULT NULL,
  `municipality` int(11) DEFAULT NULL,
  `water_service` int(11) DEFAULT NULL,
  `expenses` int(11) DEFAULT NULL,
  `comment` varchar(1500) DEFAULT NULL,
  `expiration` date DEFAULT NULL,
  `recharge` float DEFAULT NULL,
  `deductions` float DEFAULT NULL,
  `other_recharge` float DEFAULT NULL,
  `charge_words` varchar(125) DEFAULT NULL,
  PRIMARY KEY (`charge_id`),
  KEY `fk_charge_contract1_idx` (`contract_id`),
  CONSTRAINT `fk_charge_contract1` FOREIGN KEY (`contract_id`) REFERENCES `contract` (`contract_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE `config`
-- -------------------------------------------
DROP TABLE IF EXISTS `config`;
CREATE TABLE IF NOT EXISTS `config` (
  `config_id` int(11) NOT NULL AUTO_INCREMENT,
  `IIBB_inscription` int(11) DEFAULT NULL,
  `start_activities` date DEFAULT NULL,
  `seat_ring` varchar(45) DEFAULT NULL,
  `establishment_number` varchar(15) DEFAULT NULL,
  `company_adress` varchar(100) DEFAULT NULL,
  `company_contact` varchar(100) DEFAULT NULL,
  `bd_version` int(11) DEFAULT NULL,
  `payment_text` text,
  `charge_text` text,
  `cuit` varchar(13) DEFAULT NULL,
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE `contract`
-- -------------------------------------------
DROP TABLE IF EXISTS `contract`;
CREATE TABLE IF NOT EXISTS `contract` (
  `contract_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `property_id` int(10) unsigned NOT NULL,
  `number` varchar(11) DEFAULT NULL,
  `extended` int(11) DEFAULT '0',
  `start_date` date DEFAULT NULL,
  `finish_date` date DEFAULT NULL,
  `amount` float DEFAULT NULL,
  `status` enum('finalized','enabled','suspended') NOT NULL DEFAULT 'enabled',
  `commission` float DEFAULT '0',
  `franchise_free` int(11) DEFAULT NULL,
  `daily_charge` float DEFAULT NULL,
  `duration` int(11) DEFAULT '1',
  PRIMARY KEY (`contract_id`),
  KEY `fk_contract_property1_idx` (`property_id`),
  KEY `number` (`number`),
  CONSTRAINT `fk_contract_property1` FOREIGN KEY (`property_id`) REFERENCES `property` (`property_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE `locality`
-- -------------------------------------------
DROP TABLE IF EXISTS `locality`;
CREATE TABLE IF NOT EXISTS `locality` (
  `locality_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`locality_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE `payment`
-- -------------------------------------------
DROP TABLE IF EXISTS `payment`;
CREATE TABLE IF NOT EXISTS `payment` (
  `payment_id` int(11) NOT NULL AUTO_INCREMENT,
  `contract_id` int(10) unsigned NOT NULL,
  `payment_date` date DEFAULT NULL,
  `payment_mount` float DEFAULT NULL,
  `payment_period` varchar(45) DEFAULT NULL,
  `comment` varchar(1500) DEFAULT NULL,
  `deductions` float DEFAULT NULL,
  `recharge` float DEFAULT NULL,
  `charge_id` int(10) unsigned NOT NULL,
  `payment_words` varchar(125) DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `fk_payment_contract1_idx` (`contract_id`),
  KEY `fk_payment_charge1_idx` (`charge_id`),
  CONSTRAINT `fk_payment_charge1` FOREIGN KEY (`charge_id`) REFERENCES `charge` (`charge_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_contract1` FOREIGN KEY (`contract_id`) REFERENCES `contract` (`contract_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE `person`
-- -------------------------------------------
DROP TABLE IF EXISTS `person`;
CREATE TABLE IF NOT EXISTS `person` (
  `person_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `document_type` enum('DNI','LC','LE','Ext') NOT NULL,
  `document_number` varchar(12) NOT NULL,
  `name` varchar(45) NOT NULL,
  `first_surname` varchar(45) NOT NULL,
  `second_surname` varchar(45) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `street_number` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `mobile` varchar(45) DEFAULT NULL,
  `employee` tinyint(1) DEFAULT NULL,
  `job_adress` varchar(255) DEFAULT NULL,
  `profession` varchar(255) DEFAULT NULL,
  `civil_status` enum('single','married','divorced','widowed') DEFAULT NULL,
  `salary` float DEFAULT NULL,
  `commercial_references` varchar(255) DEFAULT NULL,
  `bank_references` varchar(255) DEFAULT NULL,
  `zip_code` varchar(15) DEFAULT NULL,
  `bank` varchar(45) DEFAULT NULL,
  `bank_number` varchar(45) DEFAULT NULL,
  `bank_holder` varchar(255) DEFAULT NULL,
  `bank_branch` varchar(45) DEFAULT NULL,
  `locality_id` int(11) DEFAULT NULL,
  `type` enum('guarantor','locator','owner','receiver') DEFAULT NULL,
  `owner` tinyint(1) DEFAULT NULL,
  `cuit` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`person_id`),
  KEY `fk_person_locality_idx` (`locality_id`),
  CONSTRAINT `fk_person_locality` FOREIGN KEY (`locality_id`) REFERENCES `locality` (`locality_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE `person_contract`
-- -------------------------------------------
DROP TABLE IF EXISTS `person_contract`;
CREATE TABLE IF NOT EXISTS `person_contract` (
  `person_id` int(10) unsigned NOT NULL,
  `contract_id` int(10) unsigned NOT NULL,
  `person_contract_id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`person_contract_id`),
  KEY `fk_person_has_contract_contract1_idx` (`contract_id`),
  KEY `fk_person_has_contract_person1_idx` (`person_id`),
  CONSTRAINT `fk_person_has_contract_contract1` FOREIGN KEY (`contract_id`) REFERENCES `contract` (`contract_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_person_has_contract_person1` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE `person_property`
-- -------------------------------------------
DROP TABLE IF EXISTS `person_property`;
CREATE TABLE IF NOT EXISTS `person_property` (
  `person_id` int(10) unsigned NOT NULL,
  `property_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`person_id`,`property_id`),
  KEY `fk_person_has_property_property1_idx` (`property_id`),
  KEY `fk_person_has_property_person1_idx` (`person_id`),
  CONSTRAINT `fk_person_has_property_person1` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_person_has_property_property1` FOREIGN KEY (`property_id`) REFERENCES `property` (`property_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE `property`
-- -------------------------------------------
DROP TABLE IF EXISTS `property`;
CREATE TABLE IF NOT EXISTS `property` (
  `property_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `street` varchar(255) DEFAULT NULL,
  `street_number` varchar(45) DEFAULT NULL,
  `zip_code` varchar(15) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `locality_id` int(11) NOT NULL,
  `designation` varchar(90) DEFAULT NULL,
  PRIMARY KEY (`property_id`),
  KEY `fk_property_locality1_idx` (`locality_id`),
  CONSTRAINT `fk_property_locality1` FOREIGN KEY (`locality_id`) REFERENCES `locality` (`locality_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE `role`
-- -------------------------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE IF NOT EXISTS `role` (
  `role_id` int(11) NOT NULL,
  `role` varchar(45) NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE `user`
-- -------------------------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `surname` varchar(45) DEFAULT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `status` enum('enabled','disabled') DEFAULT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_user_role1_idx` (`role_id`),
  CONSTRAINT `fk_user_role1` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE DATA bonification
-- -------------------------------------------
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('3','400','1','2');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('4','200','2','2');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('5','900','1','3');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('7','300','1','5');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('8','300','1','6');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('9','400','1','7');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('10','1800','1','8');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('11','1000','2','8');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('12','1600','1','9');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('13','900','2','9');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('14','','1','10');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('15','','2','10');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('16','550','1','11');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('17','','1','12');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('18','900','1','13');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('19','500','2','13');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('20','500','1','14');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('21','500','1','4');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('22','400','1','15');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('23','600','1','18');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('24','400','2','18');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('25','200','3','18');



-- -------------------------------------------
-- TABLE DATA charge
-- -------------------------------------------
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('9','4','2013-08-05','2100','AGOSTO/2013','0','0','0','Presenta pago Agosto/13 cochera ($200.-).Valor entregado($2.100.-)','2013-08-31','0','200','0','DOS MIL TRESCIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('10','14','2013-08-05','2834','AGOSTO/2013','0','1','1','Paga 3° cuota correspondiente a Depósito en Garantía ($834.-).Total a pagar $2834.-','2013-08-31','0','0','834','DOS MIL');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('11','9','2013-08-06','2700','AGOSTO/2013','0','1','1','Presenta pago expensas Julio/2013 ','2013-08-31','0','','','DOS MIL SETECIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('12','14','2013-09-03','2000','septiembre','0','0','0','','2013-09-30','0','0','0','dosmil');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('13','14','2013-09-12','2460','uiopy','0','0','0','','2013-09-30','360','100','200','867');



-- -------------------------------------------
-- TABLE DATA config
-- -------------------------------------------
INSERT INTO `config` (`config_id`,`IIBB_inscription`,`start_activities`,`seat_ring`,`establishment_number`,`company_adress`,`company_contact`,`bd_version`,`payment_text`,`charge_text`,`cuit`) VALUES
('1','61280','2013-08-22','01-S. Central','01-0061280-00','Chile 750 (5500) Capital - Mendoza','hoperinverco@gmail.com','','Recibí de HUGO PERAZZO INVERSIONES (de acuerdo a la autorización de cobro de referencia) la suma de pesos {payment_words} ($ {amount} -) en concepto de pago del alquiler de {property_name} de mi propiedad, sito en calle {address} de {locality}, correspondiente al canon del mes de {period}','Recibí del Señor/a: {from}, la suma de pesos {charge_words} ($ {amount} -), por el alquiler de {property_name} sito/a en calle {address} de {locality} correspondiente al canon del mes de {period} que vence el día {expiration}','20-08072027-1');



-- -------------------------------------------
-- TABLE DATA contract
-- -------------------------------------------
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('2','1','001-001-2','0','2012-01-01','2014-12-31','1400','enabled','9','10','30','3');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('3','2','001-002-1','0','2013-06-01','2015-05-31','4400','enabled','9','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('4','3','011-002-1','0','2012-07-01','2014-06-30','2300','enabled','9','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('5','4','011-004-1','0','2012-10-01','2014-09-30','2500','enabled','9','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('6','4','011-004-2','0','2012-02-01','2014-01-31','2000','enabled','9','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('7','6','011-006-1','0','2012-02-01','2014-01-31','2200','enabled','9','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('8','7','026-007-1','0','2013-05-01','2016-04-30','5100','enabled','8','10','30','3');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('9','8','026-008-1','0','2013-01-01','2015-12-31','4300','enabled','8','10','30','3');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('10','9','026-009-1','0','2011-09-01','2014-08-31','1450','enabled','8','10','30','3');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('11','10','026-010-1','0','2013-07-01','2015-06-30','2750','enabled','8','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('12','11','026-011-1','0','2011-11-01','2013-10-31','1875','enabled','8','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('13','12','026-012-1','0','2012-12-01','2015-11-30','2500','enabled','8','10','30','3');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('14','13','050-013-1','0','2013-06-01','2015-05-31','2500','enabled','9','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('15','1','001-001-1','0','2013-09-03','2015-09-03','2000','enabled','9','10','29','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('16','1','001-001-3','0','2013-09-04','2014-09-04','2000','enabled','4','10','30','1');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('17','8','026-008-2','0','2013-09-03','2014-09-03','333','enabled','8','1','10','1');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('18','1','001-001-4','0','2013-09-01','2017-08-31','2800','enabled','9','10','30','4');



-- -------------------------------------------
-- TABLE DATA locality
-- -------------------------------------------
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('1','Ciudad, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('2','Ciudad de San Martín, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('3','Godoy Cruz, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('4','Luján de Cuyo, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('5','Villa  Nueva, Guaymallen');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('6','Las Cañas, Guaymallén, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('7','Cipolletti, Río Negro');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('8','Agua Escondida, Malargue, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('9','Cuarta Sección Oeste, Ciudad, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('10','Partido de Avellaneda, Buenos Aires');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('11','Luzuriaga, Maipú, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('12','Dorrego, Guaymallén, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('13','Bermejo, Guaymallén, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('14','Rodeo de la Cruz, Guaymallén, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('15','Buena Nueva, Guaymallen, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('16','Las Heras, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('17','Uspallata, Las Heras, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('18','General Gutiérrez,Mendoza');



-- -------------------------------------------
-- TABLE DATA payment
-- -------------------------------------------
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('9','9','2013-08-12','2140','Agosto 2013','','216','','11','SERÍAAAA OJOOOOO DOS MIL CUATROCIENTOS OCHENTA Y CUATRO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('10','14','2013-08-05','2409','Agosto 2013','','200','834','10','DOS MIL CUATROCIENTOS NUEVE, SERIA DOS MIL CUATROCIENTOS CINCUENTA Y CUATRO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('11','4','2013-08-06','1893','Agosto 2013','','0','0','9','MIL OCHOCIENTOS NOVENTA Y TRES');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('12','14','2013-09-11','2447.6','','','100','300','13','uiop');



-- -------------------------------------------
-- TABLE DATA person
-- -------------------------------------------
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('1','DNI','10.509.196','ALFREDO JOSE','BOHEMI','','Chile','750','','','0','','','single','','','','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('2','DNI','25.222.179','SERGIO DANIEL','NAVARRO','','','','','','0','','','single','','','','','','','','','2','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('3','DNI','22.728.615','HECTOR LEONARDO','NAVARRO','','','','','','0','','','single','','','','','','','','','2','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('4','DNI','5.276.563','ESTELA SOFIA','DRAZICH','','Alvear','281 ','','156600464','0','','Docente','married','3978','Asociación Mutual Docente del Este','Banco Superville','','Banco Superville','','','','2','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('6','DNI','30.819.121','LUIS GABRIEL','ABATE','','Juan Pobre, B° Dalvián','524','4445936','','1','Trivento Bodegas y Viñedos S.A.','Licenciado en Economia','single','','','','','Banco Francés Suc. Aristides Villanueva','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('7','DNI','25.045.575','SEBASTIAN ARIEL ','DE ORO','','Sobremonte','464','','156554672','1','Pescara 9347','Técnico Comercio Exterior','single','7000','VISA - Banco Río','Santander Rio Suc. Aristides Villanueva','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('8','DNI','25.968.688','MARCELO ARIEL','GRIMA','','Lamadrid ','512','4284476','155862807','1','Pescara 9347','Ingeniero Quimico','married','12600','VISA - Banco Río','Santander Rio Suc. Aristides Villanueva','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('9','DNI','30.709.331','JOSE ANTONIO','GUTIERREZ','','Primero de Mayo ','1181','','156254015','1','Rodriguez Peña 3868','Perforista Petrolero','single','14000','Mastercard ','Santander Rio Suc. Aristides Villanueva','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('10','DNI','12.162.224','ESTELA BEATRIZ','ELIA','','Lamadrid ','512','4284476','','0','','Docente','married','12000','Visa - Hipotecario','Banco Nación ( Gutierrez y España) ','','','','','','1','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('11','DNI','4.602.067','AIDA NELIDA','BRUNO','','B° Dalvián','Manzana 63, Casa \"11\"','4448744','155708990','0','','','single','','','','','','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('12','DNI','20.220.956','MARÍA SONIA','CENTENO','','Echeverría','6482','4210456','','1','Roma s/n col. Bombal','Docente','single','7000','','Banco Nación ','','','','','','5','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('13','DNI','14.197.336','CLAUDIO ADRIAN','VAISMAN','','Fernando Fader','665/667','4203768','','1','J. A.Calle y Olascuaga','Docente','divorced','5000','','Banco Nación ','','','','','','1','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('14','DNI','5.160.648','OLGA ','STERN','','Echeverría','6482','4210456','','0','','Docente','single','','','','','','','','','5','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('15','DNI','220.721.918','BETTI ELBA','SPOLLANSKY','','Fernando Fader','667','4203768','','0','','Docente','married','','','','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('16','DNI','32.667.890','MATIAS JOSUE','MUÑIZ','ADARO','Estrada','146/ Departamento \"5\"','','154696403','0','','Comerciante','single','','','','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('17','DNI','17.621.083','JOSE LUIS','MUÑIZ','','Ingeniero Laje','2298','','(0299)155803792','1','Maipú 1° Piso 22-c1084 Bs.As.','Empleado Petrobras Arg. S. A.','married','23000','','','','','','','','7','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('18','DNI','12.975.449','EDUARDO JOSE','FONTAO','','Martín Guemes ','S/N','','011-156-0156458','1','Agua Escondida /Martín Guemes S/N','Docente','married','10000','','','','','','','','8','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('19','DNI','23.102.988','ARIEL GASTÓN (Pinturerias Prestigio S. A.)','CEIDE','','Avenida Mitre','5899','5777-7550','','0','Av. del Libertador N° 850','','single','','','','','','','','','10','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('20','DNI','18.492.947','RUBEN ARMANDO','ROMANO','','Bolugne Sur Mer','1731, Planta Baja N° \"4\"','','','1','Peltier N° 50, Oficina N° 34','','married','7500','','','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('21','DNI','11.582.156','SARA MARGARITA','ROMANO','SOSA','Aristobulo del Valle','270, Primer Piso','','155090015','0','','','divorced','','','','','','','','','1','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('22','DNI','32.879.554','NICOLÁS GUILLERMO','GIL','STORONI','Tafi Viejo','678','','152010472','1','Jorge A. Calle','','single','4300','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('23','DNI','12.715.651','DANIEL EDUARDO','MIGUEL','','Damián Hudson','323','','','0','','','single','','','','','','','','','9','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('24','DNI','12.931.118','ESTELA MARÍA','FERNÁNDEZ','','Chile','816, Tercer Piso, Departamento “2”','','','0','','','single','','','','','','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('25','DNI','14.628.424','VIRGINIA ESTER','FERNÁNDEZ','','Chile','816, Tercer Piso, Departamento “2”','','','0','','','single','','','','','','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('26','DNI','17.410.638','ADELA ROSA ',' FERNÁNDEZ ','','Chile','816, Tercer Piso, Departamento “2”','','','0','','','single','','','','','','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('27','LE','6.908.091','JUAN SANTOS ','NOBRE','','Almirante Brown ','2297','4960915','','0','','','single','','','','','','','','','4','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('28','DNI','30.176.262','CRISTIAN OSCAR','CALVI','','Almirante Brown ','1768','4934163','','1','','Comerciante','married','','','','','','','','','11','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('29','DNI','14.962.472','STELLA MARIS','COMISSO','','Sargento Baigorria','633','','','0','','','single','','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('30','DNI','18.342.839','OSCAR ORLANDO','ORELLANO','','Salvador Arias','1240','','156359892','1','Las Heras N°389','','single','','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('31','DNI','14.329.124','OSCAR ALFREDO ','CALVI','','S. Baigorria','633','4394588','','0','Las Heras N°389','Comerciante','married','','','','','','','','','3','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('32','DNI','4.985.098','JUAN CARLOS','DÍAZ DHO.','','Córdoba','255','4315710','','0','','Arquitecto','married','','Frávega - GPATcia financ.- AMSAT','BBVA','','','','','','12','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('33','DNI','26.838.528','VERÓNICA','SILVA','','Castellanos','73','4320494','','0','','Idonea y Tec. Tur. ','single','','','','','','','','','12','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('34','DNI','12.931.072','ALBERTO MAURICIO','BRODSKY','','25 de Mayo','948, 4° Piso, Departamento \"B\"','4246146','','0','','','single','','','','','','','','','1','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('35','DNI','13.034.511','HECTOR ALFREDO','BATISTELLI','','','','','','0','','','single','','','','','','','','','8','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('36','DNI','16.241.258','SILVIA ADRIANA','MANTEO','','','','','','0','','','single','','','','','','','','','8','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('37','DNI','32.826.765','ANABELLA PAULA','BATISTELLI','','Del Valle Iberlucea','1634, Planta Baja, Departamento \"1\"','','','0','','','single','','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('38','DNI','14.677.359','OMAR GERARDO','VILLALON','','','','','','0','','','single','','','','','','','','','8','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('39','DNI','32.571.363','PAOLA GISELLE','GÓMEZ','','B° Cooperativa Bermejo, Mza \"Q\", Casa \"6\"','','','155385807','1','Las Heras 420, Local \"3\"','Agente de Viajes','single','5415','','Tarjeta Nevada','','','','','','13','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('40','DNI','0.178.057','NÉLIDA ELVIRA','TOLIVIA','','Federico Moreno, Planta Baja, Dpto. \"8\"','2476','4248730','','0','','','widowed','11000','','','','','','','','1','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('41','DNI','4.765.126','JOSEFA ISABEL','PÉREZ','','B° Covimet, Mza \"V\", Casa \"6\"','','4262838','','0','','','single','1987','','','','','','','','14','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('42','DNI','36.731.965','MATÍAS GABRIEL','GONZÁLEZ','','Zárate, B° Covimet, Mza.\"V\", Casa \"3\"','7085','','152020322','1','Rodriguez Peña e Independencia S/N','Vendedor','single','4765','','Tarjeta Nevada','','','','','','14','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('43','DNI','5.273.824','MANUEL TEOFILO','GARCIA','','','','','','0','','','single','','','','','','','','','8','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('44','DNI','10.456.569','ELENA ROSARIO','MERCADO','','Mexico','1853','','','0','','','single','','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('45','DNI','5.437.900','NELVI RAQUEL','GATTA','','B° Suyai, Mza. \"B\", Casa \"1\"','','','','0','','','single','','','','','','','','','15','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('46','DNI','10.803.721','JULIO ALEJO','DOMÍNGUEZ','','Sargento Cabral','119','4326482','','0','','','widowed','','','','','','','','','12','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('47','DNI','13.177.714','NANCY ROSA ENRIQUETA','DOMÍNGUEZ','','Dolores Prast De Huisi, Presidente Sarmiento','Mza.\"5\", Casa \"37\"','4393213','','0','','','single','','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('48','DNI','18.082.564','FABIÁN FERNANDO','ESTÉVEZ','','Castellanos','339','4318247','','0','','','married','','','','','','','','','12','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('49','DNI','20.544.690','MAURICIO OSVALDO','TORRES','','Soldado Baigorria','581','4362155','','0','','','married','','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('50','DNI','12.877.593','BEATRIZ LILIANA','LEVIN','','Marcos Burgos','151','','1151150520','0','','','single','','','','','','','','','16','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('51','DNI','20.462.209','MÓNICA BEATRIZ','GUEVARA','','B° Alto Verde. Mza. \"L\", Casa \"4\"','','','261152167672','0','','','single','','','','','','','','','17','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('52','DNI','11.068.544','IRMA BEATRIZ','KIPPES','','Yapeyu, esquina Alfredo Búfano, Planta Baja,Dpto \"2\"','511','','','0','','','single','','','','','','','','','18','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('53','DNI','10.573.415','CARLOS OSVALDO','ROSALES','','B° Dr Eugenio Panella, Mza \"B\", Casa \"12\", ','','','','0','','','single','','','','','','','','','17','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('54','DNI','25.327.099','SEBASTIÁN LEÓN','PAGLIAFORA','','B° Dr Eugenio Panella, Mza \"B\", Casa \"12\", ','','','','0','','','single','','','','','','','','','17','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('55','DNI','26.128.687','MARÍA JIMENA','PERAZZO','','Chile','750','','155934271','0','','','single','','','','','','','','','1','owner','1','');



-- -------------------------------------------
-- TABLE DATA person_contract
-- -------------------------------------------
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('2','2','3','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('4','2','4','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('3','2','5','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('8','3','6','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('9','3','7','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('10','3','8','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('7','3','9','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('6','3','10','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('16','5','15','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('17','5','16','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('18','5','17','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('19','6','18','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('11','6','19','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('22','7','20','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('23','7','21','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('20','7','22','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('21','7','23','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('27','8','24','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('28','8','25','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('31','8','26','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('30','8','27','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('32','9','28','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('33','9','29','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('34','9','30','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('35','10','31','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('36','10','32','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('37','10','33','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('38','10','34','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('42','11','35','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('41','11','36','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('40','11','37','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('39','11','38','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('43','12','39','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('44','12','40','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('45','12','41','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('46','13','42','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('47','13','43','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('48','13','44','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('49','13','45','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('52','14','46','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('53','14','47','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('54','14','48','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('51','14','49','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('12','4','50','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('13','4','51','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('14','4','52','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('15','4','53','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('1','15','54','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('2','15','55','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('3','15','56','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('2','16','57','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('3','16','58','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('4','16','59','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('1','17','60','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('3','17','61','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('6','17','62','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('1','18','63','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('34','18','64','guarantor');



-- -------------------------------------------
-- TABLE DATA person_property
-- -------------------------------------------
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('1','1');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('1','2');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('11','3');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('11','4');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('11','5');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('11','6');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('26','7');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('26','8');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('26','9');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('26','10');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('26','11');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('26','12');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('50','13');



-- -------------------------------------------
-- TABLE DATA property
-- -------------------------------------------
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('1','Rivadavia','122','5500','Habitación dividida con estructura de madera, kichinnette, baño completo, además integran la locación todos los artefactos eléctricos','Departamento','1','Planta Baja Unidad \"13\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('2','Llancanello Esq. Cordon del Plata','B° Los Olivos IV Mza. \"E\", Casa \"6\"','','Jardín perimetral, living, cocina, comedor diario, lavandería, 4 dormitorios, 2 baños, piscina ','Casa','4','');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('3','Juan Díaz Solis, Complejo Residencial \"Selectro\"','744/766','','Living Comedor, cocina con desayunador, sector de lavandería, 2 dormitorios, baño privado en uno de sus dormitorios, ','Departamento','6','Dpto. \"11\", Primer Piso');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('4','Estrada','146','','Living comedor, cocina, 2 dormitorios, baño completo','Departamento','9','Unidad \"5\", 1° Piso');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('5','Estrada','146','','Living comedor, cocina, 2 dormitorios y baño completo','Departamento','1','Unidad \"8\", 2° Piso');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('6','Boulogne Sur Mer','1731','','Planta Baja: Living comedor, cocina comedor, baño de recepción, patio interno. Planta Alta: 2 dormitorios, baño completo, una cochera ubicada en la entrada lateral Sur del complejo, identificada como cochera N° \"6\"','Departamento Duplex','1','Planta Baja, Unidad \"4\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('7','Primitivo de la Reta','1016','','Salón frontal con vidrieras, baño, rejas antirrobo para las vidrieras, línea telefónica registrada ante Telefónica de Argentina S.A. y un reloj interruptor de electricidad','Local Comercial','1','');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('8','9 de Julio','907','','Local con vidriera frontal, un ambiente para privado, y baño con lavamanos e inodoro. Ademas posee la unidad un aire acondicionado que se encuentra sin funcionamiento','Local Comercial','1','Planta Baja, Local \"C\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('9','Amigorena','94','','Compuesto por piso a nivel de vereda, entrepiso, dos baños, cierre metálico en su frente con vidriera, escalera para acceso del entrepiso revestida de alfombra','Local Comercial','1','Planta Baja, Local \"2\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('10','San Lorenzo','412','','Linving comedor con puerta ventana de acceso a patio interior, cocina, baño con vanitory de 2 puertas, con pileta de loza y espejo en pared, inodoro con mochila y sector de ducha, dormitorio alfombrado con placard de dos puertas  corredizas y tres cajones y dos patios internos con pisos cerámicos, leoneras y puertas corredizas con vidrios en perfecto estado  ','Departamento','1','Dpto. \"4\", Planta Baja');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('11','Garibaldi','384','','Consta de cuatro compartimientos privados y baño, frente: persiana metálica en puerta de entrada','Local Comercial','1','');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('12','Garibaldi','382','','Local de aproximadamente 40m2, con frente a calle, cierre con vidrios, metal y puerta de dos hojas con rejas, en la parte exterior cortina metálica romboidal de enrollar, en el interior un baño con inodoro y lavamanos, un sótano correspondiente a parte del subsuelo del edificio ','Local Comercial','1','Planta Baja, Unidad \"1\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('13','Avenida Mitre','2485','','Living comedor, con salida a balcón pequeño, cocina con mesada en granito, lavadero, con pileta de lavar y un calefón termo de 80 litros, en pasillo un calefactor tipo convector, dos dormitorios, con placares de madera,empotrados, de doble hoja, con estantes y cajoneras, baño completo','Departamento','1','Monoblock \"1\", Unidad \"10\", Tercer Piso');



-- -------------------------------------------
-- TABLE DATA role
-- -------------------------------------------
INSERT INTO `role` (`role_id`,`role`) VALUES
('1','admin');



-- -------------------------------------------
-- TABLE DATA user
-- -------------------------------------------
INSERT INTO `user` (`user_id`,`name`,`surname`,`username`,`password`,`status`,`role_id`) VALUES
('1','Admin','Admin','admin','$1$ee2.PO2.$Jfmql.yZgeWrRIDkH390b0','enabled','1');



-- -------------------------------------------
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
COMMIT;
-- -------------------------------------------
-- -------------------------------------------
-- END BACKUP
-- -------------------------------------------
