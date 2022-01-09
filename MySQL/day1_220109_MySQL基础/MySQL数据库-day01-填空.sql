# =================================== DDL数据定义语言 ===================================
-- 1. DDL-数据库操作
-- 创建数据库语法
-- CREATE DATABASE 数据库名;

-- 数据库不存在才创建数据库
-- CREATE DATABASE IF NOT EXISTS 数据库名;

-- 创建数据库并指定 utf8 编码字符集
-- 方式1：CREATE DATABASE 数据库名 CHARACTER SET utf8;
-- 方式2：CREATE DATABASE 数据库名 CHARSET=utf8;

-- 示例1：创建一个名为 bigdata_db 的数据库
CREATE DATABASE bigdata_db;

-- 示例2：数据库不存在时，才创建数据库
CREATE DATABASE IF NOT EXISTS bigdata_db;

-- 示例3：创建数据库并指定 utf8 编码字符集
CREATE DATABASE IF NOT EXISTS bigdata_db2 CHARSET=utf8;


-- 查看数据库语法
-- SHOW DATABASES;

-- 示例4：查看当前有哪些数据库
SHOW DATABASES;

-- 使用数据库语法
-- USE 数据库名;

-- 示例5：使用 bigdata_db 数据库
USE bigdata_db;

-- 示例6：使用 bigdata_db2 数据库
USE bigdata_db2;

-- 删除数据库语法【一定要慎重！！！】
-- DROP DATABASE 数据库名;

-- 示例8：删除 bigdata_db 数据库
DROP DATABASE bigdata_db;

-- 示例9：删除 bigdata_db2 数据库
DROP DATABASE bigdata_db2;

-- 2. DDL-表操作
-- 创建表语法
# CREATE TABLE 表名(
#     字段名1 数据类型(长度) 约束,
#     字段名2 数据类型(长度) 约束
#     ...
# );

CREATE DATABASE IF NOT EXISTS bigdata_db CHARSET=utf8;
USE bigdata_db;

-- 示例1：创建一个 category 数据表
CREATE TABLE category(
    cid INT PRIMARY KEY NOT NULL,
    cname VARCHAR(100)
);

-- 查看表语法
-- SHOW TABLES; -- 显示当前数据库中有哪些表
-- DESC 表名; -- 查看指定数据表的表结构

-- 示例2：查看当前数据库中有哪些表
SHOW TABLES;

-- 示例3：查看 category 数据表的结构
DESC category;

-- 修改表语法
-- RENAME TABLE 表名 TO 新表名; -- 修改表名

-- 示例4：将 category 表重命名为 categories
RENAME TABLE category TO categories;

-- 删除表语法
-- DROP TABLE 表名; -- 删除指定数据表
DROP TABLE categories;

-- 3. DDL-表结构(字段)操作

CREATE TABLE category(
    # 字段1名称为cid，数据类型为整型，添加主键约束及非空约束
    cid INT PRIMARY KEY NOT NULL,
    # 字段2名称为cname，数据类型为varchar,最大长度为100
    cname VARCHAR(100)
);


-- 添加字段语法
-- ALTER  TABLE  表名  ADD  列名  类型(长度)  [约束];

-- 示例1：给 category 表添加一个 num 字段
ALTER TABLE category ADD num INT NOT NULL;

-- 示例2：给 category 表添加一个 desc 字段
-- 注意：添加字段如果和SQL关键字同名，字段两边必须加反引号``
ALTER TABLE category ADD `desc` VARCHAR(100);

-- 修改字段语法
-- ALTER TABLE 表名 CHANGE 旧列名 新列名 类型(长度) 约束;

-- 示例3：将 category 表的 desc 字段修改为 description 字段
ALTER TABLE category CHANGE `desc` description VARCHAR(100);

-- 删除字段语法
-- ALTER TABLE 表名 DROP 列名;

-- 示例4：删除 category 表的 num 字段
ALTER TABLE category DROP num;


# =================================== DML数据操作语言 ===================================
-- 1. 插入表记录
-- 一次添加一行数据
-- 不指定字段：INSERT INTO 表 VALUES(值1, 值2, 值3...);
-- 指定字段：INSERT INTO 表 (字段1, 字段2, 字段3...) VALUES(值1, 值2, 值3...);

-- 示例1：在 category 表中插入一条记录：cid=1, cname='服饰', description='秋冬装5折'
INSERT INTO category VALUES (1, '服饰', '秋冬装5折');

-- 示例2：在 category 表中插入一条记录：cid=2, cname='电器'
INSERT INTO category(cid, cname) VALUES (2, '电器');

-- 一次添加多行数据
-- 不指定字段：INSERT INTO 表 VALUES(值1, 值2, 值3...), (值1, 值2, 值3...), ...;
-- 指定字段：INSERT INTO 表 (字段1, 字段2, 字段3...) VALUES(值1, 值2, 值3...), (值1, 值2, 值3...)...;

-- 示例1：在 category 表中插入2条记录：
-- cid=3, cname='玩具', description='奥迪双钻我的伙伴'
-- cid=4, cname='蔬菜', description='时令蔬菜，新鲜速达'
INSERT INTO category
VALUES
        (3, '玩具', '奥迪双钻我的伙伴'),
        (4, '蔬菜', '时令蔬菜，新鲜速达');

-- 示例2：在 category 表中插入3条记录
INSERT INTO category (cid, cname)
VALUES
        (5, '化妆品'),
        (6, '书籍'),
        (7, NULL);

-- 2. 更新表记录
-- 更新所有行：UPDATE 表名 SET 字段名=值, 字段名=值, ...;
-- 更新满足条件的行：UPDATE 表名 SET 字段名=值, 字段名=值, ... WHERE 条件;

-- 示例1：将 category 表中所有行的 cname 改为 '家电'
UPDATE category SET cname='家电';

-- 示例2：将 category 表中 cid 为 1 的记录的 cname 改为 '服装'
UPDATE category SET cname='服饰' WHERE cid=1;

-- 3. 删除表记录
-- 语法：DELETE FROM 表名 [WHERE 条件];

-- 示例1：删除 category 表中 cid 为 5 的记录
DELETE FROM category WHERE cid=5;

-- 示例2：删除 category 表中的所有记录
DELETE FROM category;   # 主键自增队列不清零

-- 语法：TRUNCATE TABLE 表名; -- 清空表数据
-- 示例3：清空 category 表中的数据
TRUNCATE TABLE category;    # 主键自增队列清零

-- 补充.逻辑删除: 在表中添加一列, 这一列表示数据是否被逻辑删除, 比如0表示未被删除, 1表示删除
ALTER TABLE category ADD is_delete BIT;

INSERT INTO category
VALUES
    (1, '服饰', '棉毛衫', 0),
    (2, '玩具', '四驱车', 0),
    (3, '蔬菜', '时令蔬菜', 0);

-- 逻辑删除的本质是更新删除标记, 标记某个数据被逻辑删除了, 但其实数据还在表中
UPDATE category SET is_delete=1 WHERE cid=1;

-- 3. SQL约束进阶
-- PRIMARY KEY主键约束：主键唯一标识表中的一条记录，主键必须唯一且不能为NULL

-- 示例1：创建表时添加主键约束
# 在创建数据表时添加
CREATE TABLE person(
    id INT PRIMARY KEY,
    last_name VARCHAR(100),
    first_name VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(100)
);

DESC person;

-- 示例2：创建表后添加主键约束
# 在创建后添加约束(了解)
CREATE TABLE person1(
    id INT,
    last_name VARCHAR(100),
    first_name VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(100)
);

DESC person1;

# 创建表后，使用ALTER TABLE关键字添加主键
ALTER TABLE person1 ADD PRIMARY KEY (id);

-- 示例3：删除主键约束
ALTER TABLE person1 DROP PRIMARY KEY;

DESC person1;

-- 示例4：主键约束必须是非空且唯一
# INSERT INTO person (last_name, first_name, address, city)
# VALUES('fang', 'xiao', '石景山', '北京');

# INSERT INTO person VALUES(NULL, 'fang', 'xiao', '石景山', '北京');

INSERT INTO person VALUES(1, 'fang', 'xiao', '石景山', '北京');

-- 示例5：主键自动增长设置
# 在创建表时添加自动增长
CREATE TABLE person2(
    id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(255),
    first_name VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(255)
);

# 查看表结构
DESC person2;

# 不给id传值
INSERT INTO person2(last_name, first_name, address, city)
VALUES('ming', 'xiao', '昌平', '北京');

# 给id传NULL值或0值
INSERT INTO person2 VALUES(NULL, 'fang', 'xiao', '石景山', '北京');
INSERT INTO person2 VALUES(0, 'fang', 'xiao', '石景山', '北京');

# 插入一条id值为9的记录，查看主键自增情况
INSERT INTO person2 VALUES(9, 'fang', 'xiao', '石景山', '北京');

# 自动增长，是在我们当前自增列的最大值的基础上进行+1操作
INSERT INTO person2 VALUES(NULL, 'fang', 'xiao', '石景山', '北京');

-- NOT NULL非空约束：指定字段不能为NULL

-- 示例6：创建表时添加非空约束
CREATE TABLE person3(
    id INT NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(100)
);

# 查看表结构
DESC person3;

# INSERT INTO person3(id, first_name, address, city)
# VALUES(1, 'xiao', '昌平', '北京');

# INSERT INTO person3 VALUES(1, NULL, 'xiao','昌平', '北京');

-- UNIQUE唯一约束：指定字段的值必须唯一，不能重复

-- 示例7：在创建表时添加唯一约束
CREATE TABLE person4 (
    id INT PRIMARY KEY,
    last_name VARCHAR(100) UNIQUE ,
    first_name VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(100)
);

# 查看表结构
DESC person4;

INSERT INTO person4 VALUES(1, 'ming', 'xiao', '昌平', '北京');

# 如果出现插入重复值的情况，将会报错，插入失败
INSERT INTO person4 VALUES(2, 'ming', 'da', '丰台', '北京');

-- DEFAULT默认值：当不填写字段对应的值会使用默认值，如果填写时以填写为准。
-- 示例8：# 在创建表时添加默认值
CREATE TABLE person5 (
    id INT PRIMARY KEY,
    last_name VARCHAR(100),
    first_name VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(100) DEFAULT '北京'
);

# 查看表结构
DESC person5;

INSERT INTO person5(id, last_name, first_name, address) VALUES (1, 'ming', 'xiao', '昌平');

# =================================== DQL数据查询语言 ===================================
-- 1. 简单查询操作

# 创建表
CREATE TABLE product (
    pid         INT PRIMARY KEY AUTO_INCREMENT,
    pname       VARCHAR(20),
    price       DOUBLE,
    category_id VARCHAR(32)
);

# 插入记录
INSERT INTO product(pid,pname,price,category_id) VALUES(1,'联想',5000,'c001');
INSERT INTO product(pid,pname,price,category_id) VALUES(2,'海尔',3000,'c001');
INSERT INTO product(pid,pname,price,category_id) VALUES(3,'雷神',5000,'c001');
INSERT INTO product(pid,pname,price,category_id) VALUES(4,'杰克琼斯',800,'c002');
INSERT INTO product(pid,pname,price,category_id) VALUES(5,'真维斯',200,'c002');
INSERT INTO product(pid,pname,price,category_id) VALUES(6,'花花公子',440,NULL);
INSERT INTO product(pid,pname,price,category_id) VALUES(7,'劲霸',2000,'c002');
INSERT INTO product(pid,pname,price,category_id) VALUES(8,'香奈儿',800,'c003');
INSERT INTO product(pid,pname,price,category_id) VALUES(9,'相宜本草',200,'c003');
INSERT INTO product(pid,pname,price,category_id) VALUES(10,'面霸',5,'c003');
INSERT INTO product(pid,pname,price,category_id) VALUES(11,'好想你枣',56,'c004');
INSERT INTO product(pid,pname,price,category_id) VALUES(12,'香飘飘奶茶',1,'c005');
INSERT INTO product(pid,pname,price,category_id) VALUES(13,'海澜之家',1,'c002');

-- 语法
# 查询表中的全部数据(所有行所有列的数据)
# SELECT * FROM 表名;

# 查询表中的指定列数据(所有行指定列的数据)
# SELECT 列1, 列2, ... FROM 表名;

-- 示例1：获取全部商品信息
SELECT * FROM product;

-- 示例2：获取所有商品的名称和价格
SELECT pname, price FROM product;

-- 2. 条件查询操作
-- 语法
-- SELECT * FROM 表名 WHERE 条件;

# 比较运算符
# =、>、<、>=、<=、!=、<>
-- 示例1：查询所价格等于800的所有商品信息
SELECT * FROM product WHERE price=800;
-- 示例2：查询所有价格不为800的所有商品信息
SELECT * FROM product WHERE price<>800;
-- 示例3：查询价格大于600元的所有商品信息
SELECT * FROM product WHERE price>600;
-- 示例4：查询价格小于2000元的所有商品的名称和价格
SELECT pname, price FROM product WHERE price<2000;
# 逻辑运算符
# AND、OR、NOT
-- 示例1：获取所有商品中，价格在200-2000之间的所有商品
SELECT * FROM product WHERE price >= 200 AND price <= 2000;
-- 示例2：获取所有商品中，价格大于3000或价格小于600的所有商品信息
SELECT * FROM product WHERE price > 3000 OR  price < 600;
-- 示例3：获取所有商品中价格不在200-2000范围内的所有商品信息
SELECT * FROM product WHERE NOT (price >= 200 AND price <= 2000);
# 模糊查询
# LIKE
# %：表示任意多个任意字符
# _：表示一个任意字符
-- 示例1：例1：查询所有商品中，商品名以'斯'结尾的商品信息
SELECT * FROM product WHERE pname LIKE '%斯';
-- 示例2：查询所有商品中，商品名以'斯'结尾，并且是三个字的商品信息
SELECT * FROM product WHERE pname LIKE '__斯';
-- 示例3：询所有商品中，名字中带'霸'的商品信息
SELECT * FROM product WHERE pname LIKE '%霸%';

# 范围查询
# BETWEEN ... AND ... 表示在一个连续的范围内查询
# IN 表示在一个非连续的范围内查询
-- 示例1：查询价格在800-2000范围内的所有商品
SELECT * FROM product WHERE price BETWEEN 200 AND 2000;
-- 示例2：查询所有商品中价格是600、800、2000的商品信息
SELECT * FROM product WHERE price IN (600, 800, 2000);
-- 示例3：查询商品名称是 '劲霸'和 '香奈儿' 的商品信息(可以对于字符型数据使用IN)
SELECT * FROM product WHERE pname IN ('劲霸', '香奈儿');

# 空判断查询
# 判断为空使用：IS NULL
# 判断非空使用：IS NOT NULL
-- 示例1：查询所有商品中category_id的值为NULL的商品信息
SELECT * FROM product WHERE category_id IS NULL;
-- 示例2：查询所有商品中category_id的值不为NULL的商品信息
SELECT * FROM product WHERE category_id IS NOT NULL;