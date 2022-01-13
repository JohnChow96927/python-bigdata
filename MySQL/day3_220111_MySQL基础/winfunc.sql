-- MySQL dump 10.13  Distrib 8.0.16, for Win64 (x86_64)
--
-- Host: localhost    Database: winfunc
-- ------------------------------------------------------
-- Server version	8.0.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8mb4 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- CREATE DATABASE winfunc
--
CREATE DATABASE winfunc CHARSET=utf8;
USE winfunc;

--
-- Table structure for table `auction`
--

DROP TABLE IF EXISTS `auction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `auction` (
  `id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `asking_price` decimal(10,2) DEFAULT NULL,
  `final_price` decimal(10,2) DEFAULT NULL,
  `views` int(11) DEFAULT NULL,
  `participants` int(11) DEFAULT NULL,
  `country` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ended` date DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auction`
--

LOCK TABLES `auction` WRITE;
/*!40000 ALTER TABLE `auction` DISABLE KEYS */;
INSERT INTO `auction` VALUES (1,1,190.07,219.66,93,16,'Spain','2017-01-05'),(2,4,34.70,54.70,187,31,'Spain','2017-01-05'),(3,5,124.85,155.95,237,59,'Spain','2017-01-05'),(4,3,141.42,205.73,289,58,'Spain','2017-01-06'),(5,2,31.11,66.45,165,83,'Spain','2017-01-09'),(6,3,106.18,125.07,27,3,'Spain','2017-01-06'),(7,2,124.83,150.93,266,53,'Spain','2017-01-06'),(8,1,151.71,164.54,158,53,'Spain','2017-01-08'),(9,4,51.44,87.02,235,59,'France','2017-01-05'),(10,2,118.97,178.21,191,38,'France','2017-01-05'),(11,5,38.50,69.61,44,7,'France','2017-01-06'),(12,4,20.87,35.57,298,37,'France','2017-01-08'),(13,2,56.45,112.42,267,45,'Germany','2017-01-05'),(14,3,189.20,242.16,234,33,'Germany','2017-01-06'),(15,2,43.15,88.01,92,12,'Germany','2017-01-06'),(16,5,158.92,179.18,17,2,'Germany','2017-01-06'),(17,1,64.55,129.46,155,78,'UK','2017-01-05'),(18,4,196.07,237.86,63,21,'UK','2017-01-05'),(19,2,171.26,190.57,194,39,'UK','2017-01-06'),(20,3,157.81,206.63,218,31,'Italy','2017-01-05'),(21,2,135.16,197.43,47,12,'Italy','2017-01-07'),(22,4,172.98,197.07,297,42,'Italy','2017-01-06'),(23,5,163.89,218.99,90,18,'Italy','2017-01-09'),(24,3,115.76,137.49,136,19,'Italy','2017-01-06'),(25,3,149.89,208.09,25,3,'Italy','2017-01-07');
/*!40000 ALTER TABLE `auction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `category` (
  `cid` varchar(32) NOT NULL,
  `cname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES ('c001','家电'),('c002','服饰'),('c003','化妆品');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dept`
--

DROP TABLE IF EXISTS `dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `dept` (
  `deptno` int(11) NOT NULL,
  `dname` varchar(20) NOT NULL,
  `loc` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`deptno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dept`
--

LOCK TABLES `dept` WRITE;
/*!40000 ALTER TABLE `dept` DISABLE KEYS */;
INSERT INTO `dept` VALUES (10,'ACCOUNTING','NEW YORK'),(20,'RESEARCH','DALLAS'),(30,'SALES','CHICAGO'),(40,'OPERATIONS','BOSTON');
/*!40000 ALTER TABLE `dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emp`
--

DROP TABLE IF EXISTS `emp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `emp` (
  `empno` int(11) NOT NULL,
  `empname` varchar(10) NOT NULL,
  `job` varchar(10) NOT NULL,
  `manager` int(11) DEFAULT NULL,
  `hiredate` date DEFAULT NULL,
  `salary` double DEFAULT NULL,
  `comm` double DEFAULT NULL,
  `deptno` int(11) DEFAULT NULL,
  PRIMARY KEY (`empno`),
  KEY `index_dept_deptno` (`deptno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emp`
--

LOCK TABLES `emp` WRITE;
/*!40000 ALTER TABLE `emp` DISABLE KEYS */;
INSERT INTO `emp` VALUES (7369,'SMITH','CLERK',7902,'1980-12-17',800,NULL,20),(7499,'ALLEN','SALESMAN',7698,'1981-02-20',1600,300,30),(7521,'WARD','SALESMAN',7698,'1981-02-22',1250,500,30),(7566,'JONES','MANAGER',7839,'1981-04-02',2975,NULL,20),(7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250,1400,30),(7698,'BLAKE','MANAGER',7839,'1981-05-01',2850,NULL,30),(7782,'CLARK','MANAGER',7839,'1981-06-09',2450,NULL,10),(7788,'SCOTT','ANALYST',7566,'1987-07-03',3000,NULL,20),(7839,'KING','PRESIDENT',NULL,'1981-11-17',5000,NULL,10),(7844,'TURNER','SALESMAN',7698,'1981-09-08',1500,NULL,30),(7876,'ADAMS','CLERK',7788,'1987-07-13',1100,NULL,20),(7900,'JAMES','CLERK',7698,'1981-12-03',950,NULL,30),(7902,'FORD','ANALYST',7566,'1981-12-03',3000,NULL,20),(7934,'MILLER','CLERK',7782,'1981-01-23',1300,NULL,10);
/*!40000 ALTER TABLE `emp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `product` (
  `name` varchar(24) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES ('笔记本',2745.00),('手机',3360.00),('台式电脑',2460.00);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `products` (
  `pid` varchar(32) NOT NULL,
  `pname` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `flag` varchar(2) DEFAULT NULL,
  `category_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`pid`),
  KEY `products_fk` (`category_id`),
  CONSTRAINT `products_fk` FOREIGN KEY (`category_id`) REFERENCES `category` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES ('p001','联想',5000,'1','c001'),('p002','海尔',3000,'1','c001'),('p003','雷神',5000,'1','c001'),('p004','JACK JONES',800,'1','c002'),('p005','真维斯',200,'1','c002'),('p006','花花公子',440,'1','c002'),('p007','劲霸',2000,'1','c002'),('p008','香奈儿',800,'1','c003'),('p009','相宜本草',200,'1','c003');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `revenue`
--

DROP TABLE IF EXISTS `revenue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `revenue` (
  `department_id` int(11) NOT NULL,
  `year` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `revenue`
--

LOCK TABLES `revenue` WRITE;
/*!40000 ALTER TABLE `revenue` DISABLE KEYS */;
INSERT INTO `revenue` VALUES (1,'2011',65342.87),(1,'2012',75701.18),(1,'2013',77193.70),(1,'2014',48629.92),(1,'2015',57473.22),(2,'2011',45828.17),(2,'2012',39771.22),(2,'2013',38502.23),(2,'2014',66505.80),(2,'2015',62086.19),(3,'2011',35549.41),(3,'2012',47770.94),(3,'2013',42497.93),(3,'2014',64161.23),(3,'2015',41491.15);
/*!40000 ALTER TABLE `revenue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salgrade`
--

DROP TABLE IF EXISTS `salgrade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `salgrade` (
  `grade` int(11) NOT NULL,
  `losal` double DEFAULT NULL,
  `hisal` double DEFAULT NULL,
  PRIMARY KEY (`grade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salgrade`
--

LOCK TABLES `salgrade` WRITE;
/*!40000 ALTER TABLE `salgrade` DISABLE KEYS */;
INSERT INTO `salgrade` VALUES (1,700,1200),(2,1200,1400),(3,1400,2000),(4,2000,3000),(5,3000,19999);
/*!40000 ALTER TABLE `salgrade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `students` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(24) NOT NULL,
  `Gender` varchar(8) NOT NULL,
  `Score` decimal(5,2) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,'smart','Male',90.00),(2,'linda','Female',81.00),(3,'lucy','Female',83.00),(4,'david','Male',94.00),(5,'Tom','Male',92.00),(6,'Jack','Male',88.00);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_revenue`
--

DROP TABLE IF EXISTS `tb_revenue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `tb_revenue` (
  `store_id` varchar(24) NOT NULL,
  `month` int(2) NOT NULL,
  `revenue` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_revenue`
--

LOCK TABLES `tb_revenue` WRITE;
/*!40000 ALTER TABLE `tb_revenue` DISABLE KEYS */;
INSERT INTO `tb_revenue` VALUES ('s1',1,3000),('s1',2,6000),('s1',3,4320),('s1',4,3800),('s1',5,6600),('s1',6,2400),('s2',1,5100),('s2',2,7800),('s2',3,4000),('s2',4,6300),('s2',5,5800),('s2',6,4610),('s3',1,3400),('s3',2,5820),('s3',3,4100),('s3',4,5600),('s3',5,6300),('s3',6,3200);
/*!40000 ALTER TABLE `tb_revenue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_sales`
--

DROP TABLE IF EXISTS `tb_sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `tb_sales` (
  `month` int(2) NOT NULL,
  `sales` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_sales`
--

LOCK TABLES `tb_sales` WRITE;
/*!40000 ALTER TABLE `tb_sales` DISABLE KEYS */;
INSERT INTO `tb_sales` VALUES (1,10),(2,23),(3,14),(4,5),(5,32),(6,22),(8,12),(9,19),(10,36),(11,33),(12,69),(6,10);
/*!40000 ALTER TABLE `tb_sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_score`
--

DROP TABLE IF EXISTS `tb_score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `tb_score` (
  `name` varchar(24) NOT NULL,
  `course` varchar(24) NOT NULL,
  `score` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_score`
--

LOCK TABLES `tb_score` WRITE;
/*!40000 ALTER TABLE `tb_score` DISABLE KEYS */;
INSERT INTO `tb_score` VALUES ('张三','语文',81.00),('张三','数学',75.00),('李四','语文',76.00),('李四','数学',90.00),('王五','语文',81.00),('王五','数学',100.00);
/*!40000 ALTER TABLE `tb_score` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-01-08 21:25:52
