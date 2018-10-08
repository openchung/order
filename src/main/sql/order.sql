CREATE DATABASE  IF NOT EXISTS `order`;
USE `order`;

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `cname` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

LOCK TABLES `categories` WRITE;
INSERT INTO `categories` VALUES (1,'麥當勞'),(2,'肯德基'),(3,'Subway'),(4,'漢堡王'),(10,'吉野家'),(11,'摩斯');
UNLOCK TABLES;

DROP TABLE IF EXISTS `menus`;
CREATE TABLE `menus` (
  `mid` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT NULL COMMENT 'category id',
  `mname` varchar(255) DEFAULT NULL,
  `price` float(11,2) DEFAULT NULL,
  PRIMARY KEY (`mid`),
  UNIQUE KEY `id_UNIQUE` (`mid`),
  KEY `cid_idx` (`cid`),
  CONSTRAINT `cid` FOREIGN KEY (`cid`) REFERENCES `categories` (`cid`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

LOCK TABLES `menus` WRITE;
INSERT INTO `menus` VALUES (6,3,'起司牛肉',11.30),(9,1,'勁辣雞腿堡',23.00),(10,2,'煙燻脆培根咔啦雞腿堡-重量級XL套餐',15.00),(11,4,'莫札瑞拉雙層華堡',20.00),(13,10,'牛丼',23.50),(14,10,'豚丼',31.00),(16,1,'麥香魚',98.00),(18,4,'小華保',36.01),(19,1,'大麥克',26.29),(20,1,'麥香雞',1.50);
UNLOCK TABLES;


