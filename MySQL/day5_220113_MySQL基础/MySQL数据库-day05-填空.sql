# =================================== SQL时间日期函数 ===================================
# 我们在做数据处理和开发的过程中，经常需要利用SQL在MySQL或HIVE、SPARK中使用一些SQL函数，对时间日期类型的数据进行操作。
-- 时间日期函数分类
-- 1）获取当前时间的函数，比如当前的年月日或时间戳
-- 2）计算时间差的相关函数，比如两个日期之间相差多少天，一个日期90天后是几月几号
-- 3）获取年月日的函数，从一个时间中提取具体的年份、月份
-- 4）时间转换函数，比如将2021-10-05转换为时间戳

-- 1. 获取当前时间

-- 获取当前datetime类型的时间
SELECT NOW();

-- 获取当前date类型的时间
SELECT CURRENT_DATE();

-- 获取当前time类型的时间
SELECT CURRENT_TIME();

-- 获取当前操作系统时间
SELECT SYSDATE();

-- NOW()和SYSDATE()对比
SELECT NOW(), SLEEP(2), NOW();
SELECT SYSDATE(), SLEEP(2), SYSDATE();

-- 2. 计算时间差

-- 计算指定间隔的时间日期
SELECT DATE_ADD('2007-9-27', INTERVAL 90 DAY);

-- 示例：获取当前时间3个小时以前的时间
SELECT DATE_ADD(NOW(), INTERVAL -3 HOUR);

-- 计算两个时间日期之间的天数差
SELECT DATEDIFF('2021-03-22 09:00:00', '2018-03-20 07:00:00');

-- 计算两个时间日期之间的时间差(自定义时间单位)
SELECT TIMESTAMPDIFF(MONTH, '2021-03-22 09:00:00', '2018-03-20 07:00:00');

-- 示例：使用TIMESTAMPDIFF函数计算当前时间距离1989年3月9日有多少天
SELECT TIMESTAMPDIFF(DAY, '1989-03-09', NOW());

-- 3. 提取时间日期中的年月日

-- 获取当前日期中的年份
SELECT YEAR(NOW());

-- 获取2021-10-02 09:00中月份
SELECT MONTH('2021-10-02 09:00');

-- 获取时间日期中的日
SELECT DAY('2021-10-02 09:00');

-- 提取时间日期中的时分秒
-- 分别运行下面的SQL语句
SELECT HOUR('2021-10-02 09:01:30');
SELECT MINUTE('2021-10-02 09:01:30');
SELECT SECOND('2021-10-02 09:01:30');

-- 计算时间日期是星期几(0是周一，1是周二，依次类推)'
SELECT WEEKDAY('2021-12-03');

-- 4. 时间日期转换

-- 时间格式化(时间转字符串)
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s');
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i');
SELECT DATE_FORMAT(NOW(), '%Y年%m月%d日 %H时%i分%s秒');

-- 字符串转时间
SELECT STR_TO_DATE('2021-01-20 16:01:45', '%Y-%m-%d %H:%i:%s');
SELECT STR_TO_DATE('2021-01-20 16:01:45', '%Y-%m-%d');

-- 时间或字符串转时间戳
-- 时间戳是一个数字，代表距1970-01-01 08:00:00的秒数
SELECT UNIX_TIMESTAMP(NOW());
select UNIX_TIMESTAMP('2012-12-20');

-- 时间戳转字符串
select FROM_UNIXTIME(1355932800, '%Y-%m-%d');


# =================================== SQL字符串函数 ===================================

# 我们在做数据处理和开发的过程中，经常需要利用SQL在MySQL或HIVE、SPARK中使用一些SQL函数；和时间函数一样，也经常需要对字符串类型的数据进行处理操作

-- 字符串函数分类
-- 1)大小写转换、反转
-- 2）对字符串进行拼接、删除前后缀，或做局部替换
-- 3）获取局部的子串，字符串的字符个数以及存储长度

-- 1. 大小写转换
-- 转换为小写
SELECT LOWER('Hello World!');

-- 转换为大写
SELECT UPPER('Hello World!');

-- 2. 字符串反转
SELECT REVERSE('123456');


-- 3. 字符串拼接
-- 多个相同字符串拼接
SELECT REPEAT('象飞田', 3);

-- 字符串拼接
SELECT CONCAT('马走日', '象飞田');
SELECT CONCAT(10.15, '%');

-- 指定分隔符拼接字符串
SELECT CONCAT_WS('^_^', '马走日', '象飞田');

-- 4. 字符串替换
SELECT REPLACE('赢赢赢士角炮巡河车赢', '赢', '');
SELECT REPLACE('赢赢赢士角炮巡河车赢', '赢', '输');

-- 5. 字符串截取
-- SUBSTR(str, n, m)：从 str 字符串的第 n 个字符(注意：n不是下标)往后截取 m 个字符，返回子串；m可省略，表示截取到末尾。
SELECT SUBSTR('五七炮屏风马', 3, 1);
SELECT SUBSTR('五七炮屏风马', 4);
SELECT SUBSTRING('五七炮屏风马', 4, 3);
-- SUBSTRING与SUBSTR相同


-- 从左或右截取n个字符
SELECT LEFT('仙人指路，急进中兵', 4);
SELECT RIGHT('仙人指路，急进中兵', 4);

-- 5. 字符串长度和存储大小

SELECT CHAR_LENGTH('仙人指路，急进中兵');
SELECT LENGTH('仙人指路，急进中兵');
-- utf8编码格式一个中文占3个字节


# =================================== SQL数学相关函数 ===================================

-- 1. 小数位数处理

-- ROUND(X, n)：对 X 进行四舍五入，保留 n 位小数，默认n为0
SELECT ROUND(1.6);
SELECT ROUND(1.333, 2);
SELECT ROUND(2.689, 2);

-- FORMAT(X, n)：对 X 进行四舍五入，保留 n 位小数，以##,###,###.###格式显示
SELECT FORMAT(1001.6, 2);
SELECT FORMAT(123456.333, 2);
SELECT FORMAT(234567.689, 2);

-- FLOOR(x)：向下取整
SELECT FLOOR(-1.5);

-- CEIL(X)：向上取整
SELECT CEIL(2.1);

-- GREATEST(expr1, expr2, expr3, ...)：返回列表中的最大值
SELECT GREATEST(3, 12, 34, 8, 25);

-- LEAST(expr1, expr2, expr3, ...)：返回列表中的最小值
SELECT LEAST(3, 12, 34, 8, 25);

# =================================== 事务 ===================================

# 事务就是用户定义的一系列执行SQL语句的操作, 这些操作要么完全地执行，要么完全地都不执行， 它是一个不可分割的工作执行单元。

-- 1. 事务四大特性
-- 1）原子性(Atomicity)
-- 2）一致性(Consistency)
-- 3）隔离性(Isolation)
-- 4）持久性(Durability)

-- 2. 数据库的存储引擎

-- 查看 MySQL 数据库支持的存储引擎
SHOW ENGINES;

-- 查出建表语句
USE winfunc;
SHOW CREATE TABLE students;

-- 修改表的存储引擎
-- alter table students engine = 'MyISAM';

-- 3. 事务的基本使用

-- 步骤
-- 1）开启事务：begin 或 start transaction
-- 2）事务中的 SQL 操作
-- 3）结束事务：提交事务(commit)或回滚事务(rollback)
--  提交事务：将本地缓存文件中的数据提交到物理表中，完成数据的更新
--  回滚事务：放弃本地缓存文件中的缓存数据，表示回到开始事务前的状态

-- 4. 事务的演示示例


# =================================== 索引 ===================================

# 索引在MySQL中也叫做“键”，它是一个特殊的文件，它保存着数据表里所有记录的位置信息，更通俗的来说，数据库索引好比是一本书前面的目录，能加快数据库的查询速度。

-- 应用场景:
-- 当数据库中数据量很大时，查找数据会变得很慢，我们就可以通过索引来提高数据库的查询效率。

-- 1. 索引的基本操作
SHOW INDEX FROM products;
ALTER TABLE products
    ADD INDEX 索引名 (列名, ...);
ALTER TABLE products
    DROP INDEX 索引名;

-- 2. 案例-验证索引性能
-- 创建测试表
CREATE DATABASE python CHARSET = utf8;
USE python;
CREATE TABLE test_index
(
    title VARCHAR(10)
);

-- 添加测试数据(pycharm)

-- 添加索引前后对比
# 开启SQL执行时间检测
SET PROFILING = 1;
# 查找第10万条数据'py-99999'
SELECT *
FROM test_index
WHERE title = 'py-99999';
# 查看SQL执行的时间
SHOW PROFILES;

# 给title字段创建索引
ALTER TABLE test_index
    ADD INDEX (title);
# 再次执行SQL查询语句
SELECT *
FROM test_index
WHERE title = 'py-99999';
# 再次查看SQL执行的时间
SHOW PROFILES;


-- 3. 联合索引

-- 联合索引又叫复合索引，即一个索引覆盖表中两个或者多个字段，一般用在多个字段一起查询的时候。
-- 好处：减少磁盘空间开销，因为每创建一个索引，其实就是创建了一个索引文件，那么会增加磁盘空间的开销。

CREATE TABLE teacher
(
    id   INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(10),
    age  INT
);

# 创建联合索引
ALTER TABLE teacher
    ADD INDEX (name, age);

-- 使用的最左原则
-- 在使用联合索引的查询数据时候一定要保证联合索引的最左侧字段出现在查询条件里面，否则联合索引失效

# 下面的查询使用到了联合索引
# 示例1：这里使用了联合索引的name部分
select *
from stu
where name = '张三';
# 示例2：这里完整的使用联合索引，包括 name 和 age 部分
select *
from stu
where name = '李四'
  and age = 10;
# 下面的查询没有使用到联合索引
# 示例3： 因为联合索引里面没有这个组合，只有【name】和【name age】这两种组合
select *
from stu
where age = 10;