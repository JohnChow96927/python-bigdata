SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `emp`
-- ----------------------------
DROP TABLE IF EXISTS `emp`;
CREATE TABLE `emp` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `deg` varchar(100) DEFAULT NULL,
  `salary` int(11) DEFAULT NULL,
  `dept` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of emp
-- ----------------------------
INSERT INTO `emp` VALUES ('1201', 'gopal', 'manager', '50000', 'TP');
INSERT INTO `emp` VALUES ('1202', 'manisha', 'Proof reader', '50000', 'TP');
INSERT INTO `emp` VALUES ('1203', 'khalil', 'php dev', '30000', 'AC');
INSERT INTO `emp` VALUES ('1204', 'prasanth', 'php dev', '30000', 'AC');
INSERT INTO `emp` VALUES ('1205', 'kranthi', 'admin', '20000', 'TP');

-- ----------------------------
-- Table structure for `emp_add`
-- ----------------------------
DROP TABLE IF EXISTS `emp_add`;
CREATE TABLE `emp_add` (
  `id` int(11) DEFAULT NULL,
  `hno` varchar(100) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of emp_add
-- ----------------------------
INSERT INTO `emp_add` VALUES ('1201', '288A', 'vgiri', 'jublee');
INSERT INTO `emp_add` VALUES ('1202', '108I', 'aoc', 'sec-bad');
INSERT INTO `emp_add` VALUES ('1203', '144Z', 'pgutta', 'hyd');
INSERT INTO `emp_add` VALUES ('1204', '78B', 'old city', 'sec-bad');
INSERT INTO `emp_add` VALUES ('1205', '720X', 'hitec', 'sec-bad');

-- ----------------------------
-- Table structure for `emp_conn`
-- ----------------------------
DROP TABLE IF EXISTS `emp_conn`;
CREATE TABLE `emp_conn` (
  `id` int(100) DEFAULT NULL,
  `phno` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of emp_conn
-- ----------------------------
INSERT INTO `emp_conn` VALUES ('1201', '2356742', 'gopal@tp.com');
INSERT INTO `emp_conn` VALUES ('1202', '1661663', 'manisha@tp.com');
INSERT INTO `emp_conn` VALUES ('1203', '8887776', 'khalil@ac.com');
INSERT INTO `emp_conn` VALUES ('1204', '9988774', 'prasanth@ac.com');
INSERT INTO `emp_conn` VALUES ('1205', '1231231', 'kranthi@tp.com');
