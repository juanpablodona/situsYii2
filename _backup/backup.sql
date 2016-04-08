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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;

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
  `number` varchar(30) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- -------------------------------------------
-- TABLE `locality`
-- -------------------------------------------
DROP TABLE IF EXISTS `locality`;
CREATE TABLE IF NOT EXISTS `locality` (
  `locality_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`locality_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

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
('5','900','1','3');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('6','500','1','4');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('9','400','1','7');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('12','1600','1','9');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('13','900','2','9');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('14','0','1','10');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('15','0','2','10');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('16','550','1','11');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('18','900','1','13');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('19','500','2','13');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('20','500','1','14');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('26','400','1','16');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('27','340','1','17');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('29','650','1','18');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('31','450','1','20');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('32','525','1','21');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('33','0','1','12');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('36','400','1','2');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('37','200','2','2');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('40','800','1','23');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('41','1050','1','15');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('42','1800','1','8');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('43','1000','2','8');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('44','300','1','6');
INSERT INTO `bonification` (`bonification_id`,`amount`,`year`,`contract_id`) VALUES
('47','300','1','5');



-- -------------------------------------------
-- TABLE DATA charge
-- -------------------------------------------
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('8','5','2013-09-03','2320','Septiembre 2013','1','1','0','El vto de Aguas Mendocinas es el 28/8/2013.
Municipalidad presentó mayo,junio,julio y agosto.
Se deja constancia que adeuda Expensas del mes de agosto, sino lo trae para octubre no se procederá al cobro','2013-09-30','100','40','60','dos mil doscientos');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('9','7','2013-09-05','2435','Septiembre 2013','1','1','1','Paga Expensas 
($235.-),correspondiente al mes de Septiembre/2013, deja constancia que en Municipalidad queda pago cochera y edificación (Julio, Agosto/2013) además presenta factura de Aguas Mendocinas, vto.28/8/13','2013-09-30','0','0','235','DOS MIL CUATROCIENTOS TREINTA Y CINCO');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('10','9','2013-09-06','2700','Septiembre 2013','0','0','1','Presenta pago Expensas mes de Agosto/2013.Se reitera urgente necesidad cambio domicilio para recepción factura Edemsa.','2013-09-30','0','0','0','DOS MIL SETECIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('11','14','2013-09-09','2000','Septiembre 2013','0','0','1',' Pagó Expensas Septiembre/2013','2013-09-30','0','0','0','Dos Mil');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('12','16','2013-09-10','2490','Septiembre 2013','0','0','0','Paga 90$ por servicios a cargo de la propietaria, Septiembre/2013','2013-09-30','0','0','90','DOS MIL CUATROCIENTOS NOVENTA ');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('14','4','2013-09-10','1925','Septiembre 2013','0','0','1','Se deducen $200.- por pago cochera y $175.- por expensas extraordinarias.
Septiembre/2013 ','2013-09-30','0','375','0','MIL NOVECIENTOS VEINTICINCO');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('16','18','2013-09-10','3350','Septiembre 2013','0','0','-1','Paga $600.- de última cuota en Depósito en Garantía, correspondiente Septiembre/2013','2013-09-30','0','0','600','TRES MIL TRESCIENTOS CINCUENTA');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('17','8','2013-09-10','3300','Septiembre 2013','1','0','-1','Ninguna','2013-09-30','0','0','0','TRES MIL TRESCIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('18','21','2013-09-10','2625','Septiembre 2013','0','0','0','Ninguna','2013-09-30','0','0','0','DOS MIL SEISCIENTOS VEINTICICO');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('19','11','2013-09-10','2716','Septiembre 2013','1','0','1','Paga última cuota en Depósito en Garantía, $516.-, correspondiente Septiembre/2013','2013-09-30','0','0','516','DOS MIL SETECIENTOS DIECISÉIS ');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('20','10','2013-09-10','1450','Septiembre 2013','0','0','0',' boletas pendientes para el próximo mes','2013-09-30','0','0','0','MIL CUATROCIENTOS CINCUENTA');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('30','23','2013-09-10','3500','Septiembre 2013','0','0','0','Boletas pendientes','2013-09-30','0','0','0','TRES MIL QUINIENTOS ');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('31','2','2013-09-10','1200','Septiembre 2013','0','0','0','Se comunica que en relación a la rescisión anticipada deberá presentar a la entrega de llaves boletas de cancelación y libre deuda: Expensas, Municipalidad, Aguas Mendocinas y Luz Eléctrica. Además entregar la propiedad recién pintada ','2013-09-30','0','0','0','MIL DOSCIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('32','13','2013-09-10','1600','Septiembre 2013','1','0','0','No trae boleta de O.S.M. por reclamo, no se la han enviado, la trae el próximo mes','2013-09-30','0','0','0','MIL SEISCIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('33','15','2013-09-02','5250','Septiembre 2013','0','1','0','Vencimiento de la boleta de Aguas Mendocinas 5/8/13','2013-09-30','0','0','1050','CINCO MIL DOSCIENTOS CINCUENTA');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('34','3','2013-09-10','3500','Septiembre 2013','0','0','0','Ninguna','2013-09-30','0','0','0','TRES MIL QUINIENTOS ');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('36','6','2013-09-10','2000','Septiembre 2013','1','1','0','Presenta boletas de Municipalidad y Aguas Mendocinas con vto. 28/8/2013','2013-09-30','0','0','0','DOS MIL');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('37','17','2013-09-12','2580','Septiembre 2013','0','0','0','Abona ($2040.-) correspondiente a alquiler Septiembre/2013, ($180.-) en concepto de servicios abonados por propietaria, correspondiente al mes de Agosto y Septiembre/2013, mas ($360.-) por intereses.Total a pagar ($2580.-)','2013-09-30','360','0','180','DOS MIL QUINIENTOS OCHENTA');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('38','12','2013-09-16','1875','Septiembre 2013','1','1','0','Trae boletas de Municipalidad Julio, Agosto y Septiembre/2013 y Aguas Mendocinas con vto. 13/8/2013','2013-09-30','0','0','0','MIL OCHOCIENTOS SETENTA Y CINCO');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('43','4','2013-10-08','2300','Octubre 2013','0','0','1','El alquiler corresponde a $2300.-, que se le deducen $200.- por cochera y $175.- por pago de Expensas comunes correspondiente mes de Octubre. Total a pagar $1925.-','2013-10-31','0','0','0','DOS MIL TRESCIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('44','14','2013-10-02','2000','Octubre 2013','1','1','0','No presenta pago Expensa mes de Octubre porque la encargada de cobrarlas se encuentra enferma. Trae boleta de Aguas Mendocinas vto.7/10/13 y Municipalidad Julio/ Agosto /Septiembre y Octubre/2013','2013-10-31','0','0','0','DOS MIL');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('45','15','2013-10-07','4200','Octubre 2013','0','0','0','Paga última cuota de deposito en garantía $1.050.-, mas alquiler $4.200.- correspondiente al mes Octubre/2013.Total a pagar $5.250.- Facturas pendientes,las trae el próximo mes','2013-10-31','0','0','1050','CUATROMIL DOSCIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('46','9','2013-10-08','2700','Octubre 2013','0','1','1','Presenta factura de Aguas Mendocinas vto. 15/10/13 y presenta pago Expensas $336 ','2013-10-31','0','0','0','DOS MIL SETECIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('48','7','2013-10-10','2200','Octubre 2013','0','0','1','El alquiler corresponde a $2200.- mas Expensas $329.-, pero abona este mes $300, ante el desconocimiento en situación de Expensa , le cominicare en curso del mes forma de pago de la diferencia generada $940.-. Total a pagar $2500','2013-10-31','0','0','0','DOS MIL DOSCIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('49','10','2013-10-10','1450','Octubre 2013','0','0','0','El alquiler corresponde a $1450.- ademas abona $3235.- por acuerdo de partes. Total a pagar $4685.- ','2013-10-31','0','0','0','MIL CUATROCIENTOS CINCUENTA');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('50','16','2013-10-09','2400','Octubre 2013','0','0','0','El alquiler corresponde a $2400.- ademas abona $90.- por servicios a cargo de la propietaria/octubre 2013. Total a pagar $ 2490.-','2013-10-31','0','0','0','DOS MIL CUATROCIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('52','17','2013-10-09','2040','Octubre 2013','0','0','0','El alquiler corresponde a $2040.-, además abona $90.- por servicios a cargo de la propietaria del mes Octubre/2013. Total a pagar $2130.-','2013-10-31','0','0','0','DOS MIL CUARENTA');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('53','20','2013-10-09','1800','Octubre 2013','0','1','0','Presenta pago factura de Aguas Mendocinas con vto.26/9/2013','2013-10-31','0','0','0','MIL OCHOCIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('54','13','2013-10-10','1600','Octubre 2013','0','0','0','Deja factura de Aguas Mendocina correspondiente al mes de Septiembre/2013, con vto.13/8/13 que había quedado pendiente, este mes no corresponde facturas','2013-10-31','0','0','0','MIL SEISCIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('55','8','2013-10-10','3300','Octubre 2013','0','1','0','Vencimiento del agua 16/09/2013','2013-10-31','0','0','0','TRES MIL TRESCIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('56','6','2013-10-10','2000','Octubre 2013','1','0','1','Presenta boletas de Municipalidad y expensas del mes pasado','2013-10-31','0','0','0','DOS MIL');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('57','11','2013-10-10','2200','Octubre 2013','1','0','1','Presenta factura de Municipalidad  Septiembre Octubre/2013 y Expensas','2013-10-31','0','0','0','DOS MIL DOSCIENTOS');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('58','23','2013-10-10','3500','Octubre 2013','0','0','0','Ninguna, el próximo mes trae facturas pendientes','2013-10-31','0','0','0','TRES MIL QUINIENTOS ');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('59','3','2013-10-10','3500','Octubre 2013','0','0','0','Presenta Impuesto Inmobiliario y carta personal ','2013-10-31','0','0','0','TRES MIL QUINIENTOS ');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('60','21','2013-10-10','2625','Octubre 2013','0','0','0','','2013-10-31','0','0','0','DOS MIL SEISCIENTOS VEINTICICO');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('61','18','2013-10-10','2750','Octubre 2013','0','1','0','Presenta boleta Aguas Mendocinas con vto. 27/9/13','2013-10-31','0','0','0','DOS MIL SETECIENTOS CINCUENTA ');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('62','5','2013-10-10','2500','Octubre 2013','0','0','1','','2013-10-31','0','0','0','DOS MIL QUINIENTOS ');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('63','12','2013-10-18','1675','Octubre 2013','1','1','0','Presenta boleta de Municipalida Y Aguas Mendocina con vto.15/10/13','2013-10-31','0','200','0','MIL OCHOCIENTOS SETENTA Y CINCO');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('64','23','2014-02-05','4300','fedr','-1','-1','-1','','2014-02-28','0','0','0','asdfas');
INSERT INTO `charge` (`charge_id`,`contract_id`,`charge_date`,`charge_mount`,`charged_period`,`municipality`,`water_service`,`expenses`,`comment`,`expiration`,`recharge`,`deductions`,`other_recharge`,`charge_words`) VALUES
('65','23','2014-02-05','4500','Asd','-1','-1','-1','','2014-02-26','0','200','400','Cuatro mil quinientos');



-- -------------------------------------------
-- TABLE DATA config
-- -------------------------------------------
INSERT INTO `config` (`config_id`,`IIBB_inscription`,`start_activities`,`seat_ring`,`establishment_number`,`company_adress`,`company_contact`,`bd_version`,`payment_text`,`charge_text`,`cuit`) VALUES
('1','16564','2001-01-01','01-S. Central','01-00101-0','Colón 165 6° \"A\" (5500) Capital - Mendoza','info@quoma.com.ar','0','Recibí de SITUS (de acuerdo a la autorización de cobro de referencia) la suma de pesos {payment_words} ($ {amount} -) en concepto de pago del alquiler de {property_name} de mi propiedad, sito en calle {address} de {locality}, correspondiente al canon del mes de {period}','Recibí del Señor/a: {from}, la suma de pesos {charge_words} (${amount}-), por el alquiler de {property_name} sito/a en calle {address} de {locality} correspondiente al canon del mes de {period} que vence el {expiration}','30-16564987-1');



-- -------------------------------------------
-- TABLE DATA contract
-- -------------------------------------------
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('2','1','001-001-2','0','2012-01-01','2014-12-31','1400','enabled','9','10','30','3');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('3','2','001-002-1','0','2013-06-01','2015-05-31','4400','enabled','9','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('4','3','011-003-1','0','2012-07-01','2014-06-30','2300','enabled','9','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('5','4','Jacinta Pichimagüida','0','2012-10-01','2014-09-30','2500','enabled','9','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('6','5','011-004-2','0','2012-02-01','2014-01-31','2000','enabled','9','10','30','2');
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
('15','14','055-014-1','0','2013-06-01','2015-05-31','5250','enabled','0','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('16','15','061-015-1','0','2012-05-01','2014-04-30','2400','enabled','9','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('17','16','061-016-1','0','2012-04-01','2014-03-31','2040','enabled','9','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('18','17','071-017-1','0','2013-08-01','2015-07-31','3400','enabled','9','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('20','18','061-018-1','0','2013-07-01','2015-06-30','2250','enabled','0','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('21','19','026-019-1','0','2012-01-01','2013-12-31','2625','enabled','8','10','30','2');
INSERT INTO `contract` (`contract_id`,`property_id`,`number`,`extended`,`start_date`,`finish_date`,`amount`,`status`,`commission`,`franchise_free`,`daily_charge`,`duration`) VALUES
('23','21','082-021-1','0','2012-11-01','2014-10-31','4300','enabled','0','10','30','2');



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
('6','Guaymallén, Mendoza');
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
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('19','San José, Guaymallén ');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('20','Panquehua, Las Heras');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('21','Chacras de Coria, Luján de Cuyo');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('22','Las Tortugas, Godoy Cruz');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('23','Capital, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('24','Benegas, Godoy Cruz, Mendoza');
INSERT INTO `locality` (`locality_id`,`name`) VALUES
('25','Carrodilla, Lujan de Cuyo');



-- -------------------------------------------
-- TABLE DATA payment
-- -------------------------------------------
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('7','5','2013-09-05','2002','Septiembre','Se requirió al inquilino boleta de expensas, advirtiéndole que el mes siguiente no se efectuará el cobro si no se presentan las mismas.','0','0','8','dos mil dos');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('8','7','2013-09-06','2237','Septiembre/2013','Pago Expensas ($235.-) y presentan boletas de Municipalidad y O.S.M., ','0','0','9','DOS MIL DOSCIENTOS TREINTA Y SIETE');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('9','14','2013-09-11','1620','Septiembre/2013',' Pagó Expensas Septiembre/2013. Se DEDUCEN $200.- para Jorge Levin','200','0','11','MIL SEISCIENTOS VEINTE');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('10','3','2013-09-11','3185','Septiembre/2013','Se retienen MIL PESOS ($1.000.-) destinados arreglos de cañerías y perdidas de agua, sujeto a renovación ','0','0','34','TRES MIL CIENTOS OCHENTA Y CINCO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('11','15','2013-09-11','4872','Septiembre/2013','','0','0','33','CUATRO MIL OCHOCIENTOS SETENTA Y DOS');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('12','13','2013-09-11','1472','Septiembre/2013','No presenta boleta de Aguas Mendocinas, porque hizo el reclamo y no se la enviaron, la trae próximo mes','0','0','32','MIL CUATROCIENTOS SETENTA Y DOS');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('13','2','2013-09-11','1092','Septiembre/2013','','0','0','31','MIL NOVENTA Y DOS ');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('14','23','2013-09-11','3500','Septiembre/2013','','0','0','30','TRES MIL QUINIENTOS');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('16','10','2013-09-11','4312','Septiembre/2013','Abona alquiler ($1450.-) mas ($3237.-) para ser imputado en arreglos internos. Total a pagar ($4687)','259','3237','20','CUATRO MIL TRESCIENTOS DOCE');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('17','11','2013-09-11','2540','Septiembre/2013','Paga última cuota en Depósito en Garantía ($516), correspondiente Septiembre/2013','0','0','19','DOS MIL QUINIENTOS CUARENTA ');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('18','21','2013-09-11','2415','Septiembre/2013','Ninguna','0','0','18','DOS MIL CUATROCIENTOS QUINCE');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('19','8','2013-09-11','3036','Septiembre/2013','Ninguna','0','0','17','TRES MIL TREINTA Y SEIS ');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('20','4','2013-09-11','1718','Septiembre/2013','Se deducen ($200.-) por pago de cochera, y ($175.-) por expensas extraordinarias','0','0','14','MIL SETECIENTOS DIECIOCHO ');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('21','18','2013-09-11','3104','Septiembre/2013','Paga ($600.-) de última cuota en Depósito en Garantía. correspondiente Septiembre/2013 ','0','0','16','TRES MIL CIENTO CUATRO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('22','16','2013-09-11','2274','Septiembre/2013','Paga ($90.-) por servicios a cargo de la propietaria, Septiembre/2013','0','0','12','DOS MIL DOSCIENTOS SETENTA Y CUATRO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('23','9','2013-09-11','2484','Septiembre/2013','Presenta pago Expensas  mes de Agosto/2013. Se reitera urgente necesidad cambio de domicilio para recepción de la factura de Edemsa','0','0','10','DOS MIL CUATROCIENTOS OCHENTA Y CUATRO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('24','6','2013-09-11','1820','Septiembre/2013','Presenta pago Municipalidad y Aguas Mendocinas, que vence el 28/8/2013','0','0','36','MIL OCHOCIENTOS VEINTE');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('25','17','2013-09-12','2364','Septiembre/2013','Abona ($2040.-) correspondiente a alquiler Septiembre/2013, ($180.-) en concepto de impuestos pagos por propietaria del mes Agosto-Septiembre/2013 , mas ($360.-) en concepto de intereses por mora','0','0','37','DOS MIL TRESCIENTOS SESENTA Y CUATRO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('26','12','2013-09-16','1725','Septiembre/2013','Presento las boletas de  Municipalidad Julio, Agosto,y Septiembre/2013 y Aguas Mendocinas con Vto.13/8/2013','0','0','38','MIL SETECIENTOS VEINTICINCO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('27','14','2013-10-02','1620','Octubre/2013','No presenta pago Expensa mes de Octubre porque la encargada de cobrarlas se encuentra enferma (lo trae el próx. mes). Trae boleta de Aguas Mendocinas vto.7/10/13 y Municipalidad Julio/ Agosto /Septiembre/ Octubre/2013. Se deducen $200.- para el Señor Jorge Levin, quien firma y retira en este acto','200','0','44','MIL SEISCIENTOS VEINTE');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('28','4','2013-10-09','1718','Octubre/2013','El alquiler corresponde a $2300.-, que se le deducen $200.- por cochera y $175.- por pago de Expensas comunes correspondiente mes de Octubre. Total a pagar $1925.-','375','0','43','MIL SETECIENTOS DIECIOCHO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('29','17','2013-10-11','1947','Octubre/2013','El alquiler corresponde a $2040.-, además abona $90.- por servicios a cargo de la propietaria del mes Octubre/2013. Total a pagar $2130.-','0','90','52','MIL NOVECIENTOS CUARENTA Y SIETE');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('30','20','2013-10-11','1710','Octubre/2013','Presenta pago factura de Aguas Mendocinas con vto.26/9/2013','90','0','53','MIL SETECIENTOS DIEZ');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('31','18','2013-10-11','2503','Octubre/2013','Presenta boleta Aguas Mendocinas con vto. 27/9/13','0','0','61','DOS MIL QUINIENTOS TRES');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('32','21','2013-10-11','2415','Octubre/2013','','0','0','60','DOS MIL CUATROCIENTOS QUINCE');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('33','3','2013-10-11','3185','Octubre/2013',' Presenta Impuesto Inmobiliario y carta personal','0','0','59','TRES MIL CIENTO OCHENTA Y CINCO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('34','11','2013-10-11','2024','Octubre/2013','Presenta factura de Municipalidad Septiembre Octubre/2013 y Expensas','0','0','57','DOS MIL VEINTICUATRO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('35','6','2013-10-11','1820','Octubre/2013','Presenta boletas de Municipalidad y expensas del mes pasado','0','0','56','MIL OCHOCIENTOS VEINTE');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('36','8','2013-10-11','3036','Octubre/2013','Vencimiento del agua 16/09/2013','0','0','55','TRES MIL TREINTA Y SEIS');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('37','13','2013-10-11','1472','Octubre/2013','Deja factura de Aguas Mendocina correspondiente al mes de Septiembre/2013, con vto.13/8/13 que había quedado pendiente, este mes no corresponde facturas','0','0','54','MIL CUATROCIENTOS SETENTA Y DOS');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('38','16','2013-10-11','2274','Octubre/2013','El alquiler corresponde a $2400.- ademas abona $90.- por servicios a cargo de la propietaria/octubre 2013. Total a pagar $ 2490.','0','90','50','DOS MIL DOSCIENTOS SETENTA Y CUATRO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('39','10','2013-10-11','4310','Octubre/2013','El alquiler corresponde a $1450.- ademas abona $3235.- por acuerdo de partes. Total a pagar $4685.-','259','3235','49','CUATRO MIL TRESCIENTOS DIEZ ');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('40','7','2013-10-11','2302','Octubre/2013','El alquiler corresponde a $2200.- mas Expensas $329.-, pero abona este mes $300, ante el desconocimiento en situación de Expensas , le comunicare en curso del mes forma de pago de la diferencia generada $940.-. Total a pagar $2500','0','300','48','DOS MIL TRESCIENTOS DOS');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('41','9','2013-10-11','2484','Octubre/2013','Presenta factura de Aguas Mendocinas vto. 15/10/13 y presenta pago Expensas $336','0','0','46','DOS MIL CUATROCIENTOS OCHENTA Y CUATRO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('42','5','2013-10-11','2275','Octubre/2013','','0','0','62','DOS MIL DOSCIENTOS SETENTA Y CINCO');
INSERT INTO `payment` (`payment_id`,`contract_id`,`payment_date`,`payment_mount`,`payment_period`,`comment`,`deductions`,`recharge`,`charge_id`,`payment_words`) VALUES
('43','12','2013-10-18','1725','Octubre/2013','Presenta boleta de Municipalidad Y Aguas Mendocinas con vto.15/10/13','0','0','63','MIL SETECIENTOS VEITICINCO');



-- -------------------------------------------
-- TABLE DATA person
-- -------------------------------------------
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('1','DNI','10.529.196','Alfredo','Bou','','Cabral','450','','','0','','','single','0','','','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('2','DNI','25.322.459','Franco','Navarro','','','','','','0','','','single','0','','','','','','','','2','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('3','DNI','22.748.578','Leonardo','Navas','','','','','','0','','','single','0','','','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('4','DNI','15.236.563','Sofía','Darwich','','República de Siria','256','','0261-156972583','0','','Docente','married','3978','Asociación Mutual Docente del Este','Banco Superville','','Banco Superville','','','','2','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('6','DNI','30.839.121','Luciano','Britos','','Juan Pobre, B° Dalvián','524','4445936','','1','Trivento Bodegas y Viñedos S.A.','Licenciado en Economia','single','0','','','','Banco Francés Suc. Aristides Villanueva','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('7','DNI','25.785.587','Ariel','Quintana','','Belgrano','243','','0261-3789428','1','Mitre 2031','Técnico Comercio Exterior','single','8500','VISA - Banco Santander','Santander Rio Suc. Aristides Villanueva','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('8','DNI','18.352.688','Marcos','Grimau','','Las Cañas','512','4257893','155876251','1','Mitre 2031','Ingeniero Civil','married','11000','VISA - Banco Supervielle','Santander Rio Suc. Aristides Villanueva','','','','','','6','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('9','DNI','31.239.331','Matias','Grimi','','25 de mayo','158','','156231848','1','Rodriguez Peña 2587','Ingeniero Electromecánico','single','12500','Mastercard ','Santander Rio Suc. España','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('10','DNI','23.172.333','Benjamín','Button','','Adolfo Calle','512','4224476','','0','','Docente','married','12000','Visa - Nación','Banco Nación ( Gutierrez y España) ','','','','','','12','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('11','DNI','14.512.021','Andrea','Campos','','Colón','155','4210824','0261-3584962','0','','','single','0','','','','','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('12','DNI','20.220.956','Mara','Cabrera','','Simón Bolivar','6482','4210456','','1','Roma s/n col. Bombal','Docente','single','7000','','Banco Nación ','','','','','','5','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('13','DNI','14.197.336','Claudio','Masman','','Fernando Fader','665/667','4203768','','1','J. A.Calle y Olascuaga','Docente','divorced','5000','','Banco Nación ','','','','','','1','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('14','DNI','5.160.648','Olga ','Magallan','','Echeverría','6482','4210456','','0','','Docente','single','0','','','','','','','','5','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('15','DNI','220.721.918','Betiana','Lampa','','Fernando Fader','667','4203768','','0','','Docente','married','0','','','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('16','DNI','32.667.890','Marcos','Muñoz','ADARO','Estrada','146/ Departamento \"5\"','','154696403','0','','Comerciante','single','0','','','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('17','DNI','17.621.083','Esteban','Rodriguez','','Ingeniero Laje','2298','','(0299)155803792','1','Maipú 1° Piso 22-c1084 Bs.As.','Empleado Petrobras Arg. S. A.','married','23000','','','','','','','','7','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('18','DNI','12.975.449','Gerardo','Lorenzo','','Martín Guemes ','S/N','','011-156-0156458','1','Agua Escondida /Martín Guemes S/N','Docente','married','10000','','','','','','','','8','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('19','DNI','23.102.988','Daniel','Dubbini','','Avenida Mitre','5899','5777-7550','','0','Av. del Libertador N° 850','','single','0','','','','','','','','10','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('20','DNI','18.492.947','Diego','Gonzalez','','Bolugne Sur Mer','1731, Planta Baja N° \"4\"','','','1','Peltier N° 50, Oficina N° 34','','married','7500','','','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('21','DNI','11.582.156','Cinthya','Rodriguez','Salgado','Aristobulo del Valle','270, Primer Piso','','155090015','0','','','divorced','0','','','','','','','','1','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('22','DNI','32.879.554','Silvia','Morales','Aguado','Tafi Viejo','678','','152010472','1','Jorge A. Calle','','single','4300','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('23','DNI','12.715.651','Daniel','Grilli','','Damián Hudson','323','','','0','','','single','0','','','','','','','','9','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('24','DNI','12.931.118','José','Sosa','','Chile','816, Tercer Piso, Departamento “2”','','','0','','','single','0','','','','','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('25','DNI','14.628.424','Leonel','Gancedo','','Chile','816, Tercer Piso, Departamento “2”','','','0','','','single','0','','','','','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('26','DNI','17.410.638','Marcos ',' Angelleri ','','Chile','816, Tercer Piso, Departamento “2”','','','0','','','single','0','','','','','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('27','LE','6.908.091','Sebastián ','Blanco','','Almirante Brown ','2297','4960915','','0','','','single','0','','','','','','','','4','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('28','DNI','30.176.262','Germán','Lux','','Almirante Brown ','1768','4934163','','1','','Comerciante','married','0','','','','','','','','11','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('29','DNI','14.962.472','Ricardo','Bochini','','Sargento Baigorria','633','','','0','','','single','0','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('30','DNI','18.342.839','Lucía','Galán','','Salvador Arias','1240','','156359892','1','Las Heras N°389','','single','0','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('31','DNI','14.329.124','Carmen ','Barbieri','','S. Baigorria','633','4394588','','0','Las Heras N°389','Comerciante','married','0','','','','','','','','3','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('32','DNI','4.985.098','Juan','Andino','','Córdoba','255','4315710','','0','','Arquitecto','married','0','Frávega - GPATcia financ.- AMSAT','BBVA','','','','','','12','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('33','DNI','26.838.528','Verónica','Ojeda','','Castellanos','73','4320494','','0','','Idonea y Tec. Tur. ','single','0','','','','','','','','12','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('34','DNI','12.931.072','Karina','Anderson','','25 de Mayo','948, 4° Piso, Departamento \"B\"','4246146','','0','','','single','0','','','','','','','','1','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('35','DNI','13.034.511','Silvia','Bustelo','','','','4297688 (local)','155268251','0','','','single','0','','','','','','','','8','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('36','DNI','16.241.258','Silvina','Comiso','','','','','','0','','','single','0','','','','','','','','8','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('37','DNI','32.826.765','Ana Paula','Gonzales','','Del Valle Iberlucea','1634, Planta Baja, Departamento \"1\"','','','0','','','single','0','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('38','DNI','14.677.359','Roberto','Aguirre','','','','','','0','','','single','0','','','','','','','','8','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('39','DNI','32.571.363','Paola','Rivero','','B° Cooperativa Bermejo, Mza \"Q\", Casa \"6\"','','','155385807','1','Las Heras 420, Local \"3\"','Agente de Viajes','single','5415','','Tarjeta Nevada','','','','','','13','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('40','DNI','0.178.057','Nélida','Oliva','','Federico Moreno, Planta Baja, Dpto. \"8\"','2476','4248730','','0','','','widowed','11000','','','','','','','','1','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('41','DNI','4.765.126','Josefina','Moyano','','B° Covimet, Mza \"V\", Casa \"6\"','','4262838','','0','','','single','1987','','','','','','','','14','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('42','DNI','36.731.965','Juana','Isgró','','Zárate, B° Covimet, Mza.\"V\", Casa \"3\"','7085','','152020322','1','Rodriguez Peña e Independencia S/N','Vendedor','single','4765','','Tarjeta Nevada','','','','','','14','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('43','DNI','5.273.824','Teófilo','Gutierrez','','','','','','0','','','single','0','','','','','','','','8','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('44','DNI','10.456.569','Franco','Bagnatto','','Mexico','1853','','','0','','','single','0','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('45','DNI','5.437.900','Gabriel','Mercado','','B° Suyai, Mza. \"B\", Casa \"1\"','','','','0','','','single','0','','','','','','','','15','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('46','DNI','10.803.721','Miguel','Rodriguez','','Sargento Cabral','119','4326482','','0','','','widowed','0','','','','','','','','12','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('47','DNI','13.177.714','Nancy','Duplaá','','Dolores Prast De Huisi, Presidente Sarmiento','Mza.\"5\", Casa \"37\"','4393213','','0','','','single','0','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('48','DNI','18.082.564','Facundo','Castillón','','Castellanos','339','4318247','','0','','','married','0','','','','','','','','12','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('49','DNI','20.544.690','Ricardo','Almada','','Soldado Baigorria','581','4362155','','0','','','married','0','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('50','DNI','12.877.593','BEATRIZ LILIANA','LEVIN','','Marcos Burgos','151','','1151150520','0','','','single','0','','','','','','','','16','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('51','DNI','20.462.209','MÓNICA BEATRIZ','GUEVARA','','B° Alto Verde. Mza. \"L\", Casa \"4\"','','','261152167672','0','','','single','0','','','','','','','','17','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('52','DNI','11.068.544','IRMA BEATRIZ','KIPPES','','Yapeyu, esquina Alfredo Búfano, Planta Baja,Dpto \"2\"','511','','','0','','','single','0','','','','','','','','18','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('53','DNI','10.573.415','CARLOS OSVALDO','ROSALES','','B° Dr Eugenio Panella, Mza \"B\", Casa \"12\", ','','','','0','','','single','0','','','','','','','','17','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('54','DNI','25.327.099','Sergio','Paglia','','B° Dr Eugenio Panella, Mza \"B\", Casa \"12\", ','','','','0','','','single','0','','','','','','','','17','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('55','DNI','26.128.687','Jimena','Perez','','Chile','750','','155934271','0','','','single','0','','','','','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('56','DNI','12.833.211','MABEL CRISTINA ','FIOCHI','','Don Bosco','1829','4454561','','1','Perú y Pedro Molina','Docente','widowed','0','','Banco Patagonia','','','','','','19','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('57','DNI','12.833.785','LUIS ROBERTO','FIOCHI','','Liniers','47, Piso 2°, Dpto. \"5\"  Edificio:T. Agustinas','','155605778','1','San Martín 1092,cdad. Mendoza','Contador Público','married','70','Amex, Visa, Maitex','Citi. Santander, Supervielle, Credicoop','','','','','','3','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('58','DNI','24.566.492','IVANA VERÓNICA','GIUDICA','','Belgrano, Planta Baja, Departamento N° \"7\"','2840','4232742','','1','Rivadavia 601, Godoy Cruz, Mendoza','Lic. en Administración de Empresas','married','5000','Farmacia Chester','Credicoop','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('59','DNI','28.172.932','CAROLINA VANESA','VESELKA','','B° LOS CIRUELOS','MZ \"B\", Casa 12','4379500','','1','Perú y Pedro Molina','Docente','married','7500','','','','','','','','20','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('60','DNI','13.569.034','ALICIA ','NORA','','Belgrano','374','','','1','San Martín Sur','Doctora en Mate','single','12','','Banco Patagonia','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('61','DNI','4.036.674','ELSA MARÍA ESTHER','RODRIGUEZ','','ESPEJO,QUINTO (5°) PISO, DEPARTAMENTO N° “3” ','223','','156167921 (Mza.) 011-4932837 (Bs. As.)','0','','','single','0','','','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('62','DNI','28.700.553','DIEGO RUBEN','ARIAS','','Ciudad de Luján','1183','','155408901','0','','','single','0','','','','','','','','12','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('63','DNI','30.837.024','JOHANA ROMINA','TABARELLI','','Vertiz',' 28','4226021','','0','','','single','0','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('64','DNI','3.054.024','GLADYS JESUS','CESARINO','','Vertiz','28','','','0','','','single','0','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('65','DNI','29.282.720','NELSON GASTON','PEREZ','','Pasaje Caroglio ','198','','','0','','','single','0','','','','','','','','12','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('66','DNI','33.052.978','JUAN PABLO ','CUGNINI','','Pasaje Nazar ','1389','','','0','','','single','0','','','','','','','','21','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('67','DNI','23.574.857','TANIA','GARCÍA','','Avenida España, Planta Baja, Departamento \"8\"','1751','','154665060','1','D.G.E.','Docente','single','2.4','','','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('68','DNI','93.751.530','MARAVILLA DEL PILAR','CORBALÁN','','Catamarca','1475','4520415','','0','','Comerciante','widowed','0','\"Estilo Pueblo\", Chacras','Banco Nación ','','','','','','22','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('69','LC','6.488.006','EVA CRISTINA','FERRARI','','Avenida España','1751','4257856 - 4960724','','1','','Docente','married','0','','','','','','','','1','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('70','DNI','32.211.663','JUAN JOSE','BORIERO','CORBALAN','Catamarca','1475','4979224','153662306','1','Carril R. Peña N° 2451, Godoy Cruz','Est. Ing.','single','4.9','','','','','','','','22','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('71','DNI','4.137.469','LUIS','SANTIAGO','','El Parral','2440, Primer Piso, Departamento \"7\"','4200495','154184638','0','','','married','0','','','','','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('72','DNI','5.123.955','MARÍA INÉS','AVENDAÑO','','El Parral','2440, Primer Piso, Departamento \"7\"','4200495','','1','','Docente','married','0','','','','','','','','1','owner','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('73','DNI','28.690.182','PABLO MATIAS','ESCUDERO','','Los Tilos','709','','155929276','1','Rivadavia 651, Ciudad, Mendoza','Sociologo','single','9.153','Tarjeta Nevada','Banco Nación ','','','','','','16','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('74','DNI','12.353.136','MARÍA DEL CARMEN','RIVERO','','Astorga','5459','4210255','','1','La Purisima 1345, Guaymallén, Mendoza','Administrativa','married','7.5','Tarjeta Provencred','Banco Galicia','','','','','','15','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('75','DNI','28.690.182','EMILIA ELSA','ESCUDERO','','Astorga','5459','4210255','','0','','','single','2487','Tarjeta Nevada','Banco Nación ','','','','','','15','','1','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('76','DNI','22.726.230','MARIA SILVIA','KROMER','','Los Tilos, B° Cementista II','709','','','0','','','single','0','','','','','','','','16','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('77','DNI','17.515.143','SANDRA LILIANA','BAGGIO','','PELLEGRINA TORRES ','496','','','0','','','married','0','','','','','','','','11','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('78','DNI','30.606.582','LEONARDO DAVID ','BOGGIO','','GRANADEROS ','1964','','','0','','','single','0','','','','','','','','23','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('79','DNI','27.786.758','Fernando','Rios','','LAGO MASCARDI  ','2444','','','0','','','single','0','','','','','','','','24','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('80','DNI','32.085.533','Antonio','Alzamendi','','RIO TUPUNGATO ','873','','','0','','','single','0','','','','','','','','3','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('81','LC','5.157.309','Franco','Carral','','','','','','0','','','single','0','','','','','','','','8','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('82','DNI','29.974.294','Ricardo','Estevez','','Chile','750','4251420','155394777','0','','','single','0','','','','','','','','1','owner','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('83','DNI','5.543.356','Michael','Alonso ','','SAN MARTÍN ','5381','','','0','','','single','0','','','','','','','','25','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('84','DNI','23.616.292','Dante ','Spinetta ','','BARRIO MINETTI OESTE','CASA 18','','','0','','','single','0','','','','','','','','16','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('85','DNI','25.586.812','Jorge','Cáceres','','JOSE INGENIEROS ','623','','','0','','','single','0','','','','','','','','16','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('86','DNI','26.872.093','María ','Oregón','','JOSE INGENIEROS   ',' 623  ','','','0','','','single','0','','','','','','','','16','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('87','DNI','24.234.903','Pedro ','Olivares ','','Uruguay','828','','','0','','','single','0','','','','','','','','1','','0','');
INSERT INTO `person` (`person_id`,`document_type`,`document_number`,`name`,`first_surname`,`second_surname`,`street`,`street_number`,`phone`,`mobile`,`employee`,`job_adress`,`profession`,`civil_status`,`salary`,`commercial_references`,`bank_references`,`zip_code`,`bank`,`bank_number`,`bank_holder`,`bank_branch`,`locality_id`,`type`,`owner`,`cuit`) VALUES
('88','DNI','13.489.745','Maximiliano','Spartaro','','Río Ceballos','782','','','1','','','single','','','','','','','','','4','','0','');



-- -------------------------------------------
-- TABLE DATA person_contract
-- -------------------------------------------
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
('12','4','11','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('13','4','12','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('14','4','13','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('15','4','14','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('22','7','20','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('23','7','21','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('20','7','22','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('21','7','23','guarantor');
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
('62','16','73','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('63','16','74','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('64','16','75','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('65','16','76','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('66','16','77','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('67','17','78','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('70','17','79','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('68','17','80','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('69','17','81','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('73','18','86','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('76','18','87','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('75','18','88','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('74','18','89','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('77','20','94','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('78','20','95','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('79','20','96','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('80','20','97','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('81','21','98','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('80','21','99','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('43','12','100','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('44','12','101','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('45','12','102','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('2','2','106','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('4','2','107','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('3','2','108','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('87','23','113','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('83','23','114','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('85','23','115','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('84','23','116','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('86','23','117','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('56','15','118','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('57','15','119','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('58','15','120','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('59','15','121','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('60','15','122','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('28','8','123','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('27','8','124','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('31','8','125','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('30','8','126','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('19','6','127','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('11','6','128','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('16','5','135','locator');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('17','5','136','guarantor');
INSERT INTO `person_contract` (`person_id`,`contract_id`,`person_contract_id`,`role`) VALUES
('18','5','137','guarantor');



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
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('55','14');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('61','15');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('61','16');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('71','17');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('61','18');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('26','19');
INSERT INTO `person_property` (`person_id`,`property_id`) VALUES
('4','21');



-- -------------------------------------------
-- TABLE DATA property
-- -------------------------------------------
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('1','Lincoln','1245','5524','Habitación dividida con estructura de madera, kichinnette, baño completo, además integran la locación todos los artefactos eléctricos','Departamento','1','Planta Baja Unidad \"13\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('2','Colón y Mitre','Ciudad \"E\", Casa \"6\"','','Jardín perimetral, living, cocina, comedor diario, lavandería, 4 dormitorios, 2 baños, piscina ','Casa','4','');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('3','Pedro Molina','744/766, Complejo Departamentos \"Selectro\"','','Living Comedor, cocina con desayunador, sector de lavandería, 2 dormitorios, baño privado en uno de sus dormitorios, ','Departamento','6','Primer Piso, Dpto. \"11\" ');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('4','Adolfo Calle','146','','Living comedor, cocina, 2 dormitorios, baño completo','Departamento','9','Unidad \"5\", 4° Piso');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('5','Adolfo Calle','146','','Living comedor, cocina, 3 dormitorios y baño completo','Departamento','1','Unidad \"8\", 5° Piso');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('6','Emilio Civit','171','','Planta Baja: Living comedor, cocina comedor, baño de recepción, patio interno. Planta Alta: 2 dormitorios, baño completo, una cochera ubicada en la entrada lateral Sur del complejo, identificada como cochera N° \"6\"','Departamento Duplex','1','Planta Baja, Unidad \"4\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('7','Colón','116','','Salón frontal con vidrieras, baño, rejas antirrobo para las vidrieras, línea telefónica registrada ante Telefónica de Argentina S.A. y un reloj interruptor de electricidad','Un Local Comercial','1','Planta Baja, Unidad\" 5\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('8','Colón','165','','Local con vidriera frontal, un ambiente para privado, y baño con lavamanos e inodoro. Ademas posee la unidad un aire acondicionado que se encuentra sin funcionamiento','Local Comercial','1','Planta Baja, Local \"C\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('9','Río Juramento','94','','Compuesto por piso a nivel de vereda, entrepiso, dos baños, cierre metálico en su frente con vidriera, escalera para acceso del entrepiso revestida de alfombra','Local Comercial','1','Planta Baja, Local \"2\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('10','España','412','','Linving comedor con puerta ventana de acceso a patio interior, cocina, baño con vanitory de 2 puertas, con pileta de loza y espejo en pared, inodoro con mochila y sector de ducha, dormitorio alfombrado con placard de dos puertas  corredizas y tres cajones y dos patios internos con pisos cerámicos, leoneras y puertas corredizas con vidrios en perfecto estado  ','Un Departamento','1','Planta Baja, Unidad\" 4\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('11','Godoy Cruz','4884','','Consta de cuatro compartimientos privados y baño, frente: persiana metálica en puerta de entrada','Local Comercial','1','');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('12','Paso de los Andes','1583','','Local de aproximadamente 40m2, con frente a calle, cierre con vidrios, metal y puerta de dos hojas con rejas, en la parte exterior cortina metálica romboidal de enrollar, en el interior un baño con inodoro y lavamanos, un sótano correspondiente a parte del subsuelo del edificio ','Local Comercial','1','Planta Baja, Unidad \"1\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('13','25 de mayo','125','','Living comedor, con salida a balcón pequeño, cocina con mesada en granito, lavadero, con pileta de lavar y un calefón termo de 80 litros, en pasillo un calefactor tipo convector, dos dormitorios, con placares de madera,empotrados, de doble hoja, con estantes y cajoneras, baño completo','Departamento','1','Monoblock \"1\", Unidad \"10\", Tercer Piso');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('14','España','175','','Porche, con ingreso a living comedor, 3 dormitorios, baño privado, comedor diario, cocina, sector de lavado, sector de servicio con baño privado y patio','Casa','1','');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('15','General Paz','252','','Living comedor, 2 dormitorios, baño completo,y alarma comunitaria con su correspondiente control','Departamento','3','Planta Baja, Unidad \"1\" B°Los Parrales');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('16','General Paz','252','','living comedor, cocina con lavandería integrada, acceso a balcón terraza de uso exclusivo, 2 dormitorios con placares, baño totalmente instalado con vanitory','Departamento','3','Planta Alta, Unidad \"4\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('17','Aconcagua','128','','Living comedor, cocina comedor, 3 dormitorios, uno con baño privado totalmente instalado, baño completo, lavadero. cochera techada, con portón metálico, jardín y churrasquera','Casa','16','');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('18','Los Arcos ','587','','Living Comedor con cocina integrada, un dormitorio con placard de seis puertas, cuatro cajones, baño completo con sus artefactos ','Departamento','3','DEPARTAMENTO N° “4”, de PLANTA ALTA');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('19','San Martín','4875','','Living, cocina comedor, 2 dormitorios y un baño completo','Un Departamento','1','Planta Baja, Unidad \"2\"');
INSERT INTO `property` (`property_id`,`street`,`street_number`,`zip_code`,`description`,`name`,`locality_id`,`designation`) VALUES
('21','Rosas','255','','Frente: con rejas , jardín con ingreso de vehículos; entrada a living-Comedor  que posee un calefactor marca ORO AZUL y un equipo de aire acondicionado  tipo Split marca PHILCO;  Escritorio  con equipo de aire acondicionado tipo Split marcas GENERAL ELECTRIC; Baño de recepción, con Vanitory; Tres(3) Dormitorios; Amplia Galería con calefactor marca EMEGE; Baño principal completo con ducha manual y  grifería completa marca FV, artefactos  marca ROCA ; Cocina-Comedor, con calefón-termo de 120 Lts; artefacto de Cocina cuatro hornallas horno y parrilla marca ESLABON DE LUJO; Mesadas en granito natural; Alacenas y Bajo-Mesadas marca JOHNSON (nuevos): Cuerpos en pared Norte y pared Oeste; sobre pared Norte: Bajo Mesada con Tres(3) cajones, uno grande y dos pequeños; y tres(3) puertas de abrir con Estante dos(2) grandes y una pequeña; sobre  pared Oeste:  Alacenas y Bajo-Mesada en juego: Alacenas cuatro (4) puertas de abrir, dos (2) con estantes, dos (2) sin estantes y Bajo','Casa','1','');



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
