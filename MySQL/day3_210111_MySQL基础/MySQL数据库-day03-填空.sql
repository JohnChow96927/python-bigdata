# =================================== 多表查询操作 ===================================
-- 1. AS起别名
-- 在SQL查询时，可以使用 AS 给表或者字段起别名

-- 给字段起别名
-- 示例1：查询每个分类的商品数量
SELECT category_id,
       COUNT(*) product_count
FROM products
GROUP BY category_id;

SELECT category_id, COUNT(*) `desc`
FROM products
GROUP BY category_id;
-- 示例2：查询每个分类名称所对应的商品数量(没有商品的分类的也要显示)
SELECT c.cname,
       COUNT(*) product_count
FROM category c
         LEFT JOIN products p
                   ON c.cid = p.category_id
GROUP BY c.cname;


-- 2. 子查询

-- 在一个 SELECT 语句中，嵌入了另外一个 SELECT 语句，那么被嵌入的 SELECT 语句称之为子查询语句，外部那个SELECT 语句则称为主查询。

# 主查询和子查询的关系：
# 1）子查询是嵌入到主查询中
# 2）子查询是辅助主查询的，要么充当条件，要么充当数据源，要么充当查询字段
# 3）子查询是可以独立存在的语句，是一条完整的 SELECT 语句

-- 示例1：查询当前商品大于平均价格的商品
SELECT pname, price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);

-- 示例2：获取所有商品中，平均价格大于800的分类的全部商品
SELECT *
FROM products
WHERE category_id IN (
    SELECT category_id
    FROM products
    GROUP BY category_id
    HAVING AVG(price) > 800
);

-- 示例3：获取所有商品中价格最高的商品(价格最高的商品不只一个)
-- STEP1. 查询商品最高价格
SELECT pname,
       price
FROM products
WHERE price = (SELECT MAX(price) FROM products);


-- 示例4：查询不同类型商品的平均价格
-- 查询结果字段：
--  category_id(分类id)、cname(分类名称)、avg(分类商品平均价格)
SELECT category_id `分类id`,
       cname       `分类名称`,
       `avg`       `分类商品平均价格`
FROM (
         SELECT category_id,
                AVG(price) `avg`
         FROM products
         GROUP BY category_id
     ) `a`
         JOIN category `b`
              ON a.category_id = b.cid;


-- 示例5：针对 students 表的数据，计算每个同学的Score分数和整体平均分数的差值
SELECT ID                                        `学生ID`,
       Name                                      `学生姓名`,
       (SELECT AVG(Score) FROM students)         `平均分`,
       Score - (SELECT AVG(Score) FROM students) `差值`
FROM students;

# =================================== SQL进阶-窗口函数 ===================================

-- 1. 窗口函数简介

-- 窗口函数是 MySQL8.0 以后加入的功能，之前需要通过定义临时变量和大量的子查询才能完成的工作，使用窗口函数实现起来更加简洁高效

-- 示例1：针对 students 表的数据，计算每个同学的Score分数和整体平均分数的差值
SELECT *,
       AVG(Score) OVER ()         AS `avg`,
       Score - AVG(Score) OVER () AS `difference`
FROM students;


-- 2. 窗口函数基础用法
-- 窗口函数的作用是在处理每行数据时，针对每一行关联的一组数据进行处理。

-- 基础语法：<window function> OVER(...)
-- <window function> 表示使用的窗口函数，窗口函数可以使用之前已经学过的聚合函数，比如COUNT()、SUM()、AVG()等，也可以是其他函数，比如 ranking 排序函数等，后面的课程中会介绍
-- OVER(...)的作用就是设置每行数据关联的窗口数据范围，OVER()时，每行关联的数据范围都是整张表的数据。

-- SQL示例

SELECT ID,
       Name,
       Gender,
       Score,
       -- OVER()：表示每行关联的窗口数据范围都是整张表的数据
       -- AVG(Score)：表示处理每行数据时，应用 AVG 对每行关联的窗口数据中的 Score 求平均
       AVG(Score) OVER () AS `AVG_Score`
FROM students;

-- 典型应用场景1：计算每个值和整体平均值的差值

-- 示例1
# 需求：计算每个学生的 Score 分数和所有学生整体平均分的差值。
# 查询结果字段：
#   ID、Name、Gender、Score、AVG_Score(学生整体平均分)、difference(每位学生分数和整体平均分的差值)
SELECT ID,
       Name,
       Gender,
       Score,
       -- OVER()：表示每行关联的窗口数据范围都是整张表的数据
       -- AVG(Score)：表示处理每行数据时，应用 AVG 对每行关联的窗口数据中的 Score 求平均
       AVG(Score) OVER ()         AS `AVG_Score`,
       Score - AVG(Score) OVER () AS `difference`
FROM students;

-- 典型应用场景2：计算每个值占整体之和的占比

# 需求：计算每个学生的Score分数占所有学生分数之和的百分比
# 查询结果字段：
#   ID、Name、Gender、Score、sum(所有学生分数之和)、ratio(每位学生分数占所有学生分数之和的百分比)
SELECT ID,
       Name,
       Gender,
       Score,
       -- OVER()：表示每行关联的窗口数据范围都是整张表的数据
       -- AVG(Score)：表示处理每行数据时，应用 AVG 对每行关联的窗口数据中的 Score 求平均
       SUM(Score) OVER ()               AS `SUM`,
       Score * 100 / SUM(Score) OVER () AS `ratio`
FROM students;

-- 2. PARTITION BY分区

-- 基本语法：<window function> OVER(PARTITION BY 列名, ...)
-- PARTITION BY 列名, ...的作用是按照指定的列对整张表的数据进行分区
-- 分区之后，在处理每行数据时，<window function>是作用在该行数据关联的分区上，不再是整张表上

-- SQL 示例

SELECT ID,
       Name,
       Gender,
       Score,
       -- PARTITION BY Gender：按照性别对整张表的数据进行分区，此处会分成2个区
       -- AVG(Score)：处理每行数据时，应用 AVG 对该行关联分区数据中的 Score 求平均
       AVG(Score) OVER (PARTITION BY Gender) AS `Avg`
FROM students;

-- 应用示例

-- 示例1
-- 需求：计算每个学生的 Score 分数和同性别学生平均分的差值
-- 查询结果字段：
--  ID、Name、Gender、Score、Avg(同性别学生的平均分)、difference(每位学生分数和同性别学生平均分的差值)
SELECT ID,
       Name,
       Gender,
       Score,
       -- PARTITION BY Gender：按照性别对整张表的数据进行分区，此处会分成2个区
       -- AVG(Score)：处理每行数据时，应用 AVG 对该行关联分区数据中的 Score 求平均
       AVG(Score) OVER (PARTITION BY Gender) AS      `分性别学生平均分`,
       Score - AVG(Score) OVER (PARTITION BY Gender) `与同性别学生平均分的差值`
FROM students;

-- 示例2
-- 需求：计算每人各科分数与对应科目最高分的占比
-- 查询结果字段：
--  name、course、score、max(对应科目最高分数)、ratio(每人各科分数与对应科目最高分的占比)
SELECT Name,
       course,
       Score,
       MAX(Score) OVER (PARTITION BY course) AS      `各科最高分`,
       Score / MAX(Score) OVER (PARTITION BY course) `与对应科目最高分的占比`
FROM tb_score;

-- 3. 排序函数

-- 基本语法：<ranking function> OVER (ORDER BY 列名, ...)
-- OVER() 中可以指定 ORDER BY 按照指定列对每一行关联的分区数据进行排序，然后使用排序函数对分区内的每行数据产生一个排名序号

-- SQL 示例
SELECT name,
       course,
       score,
       -- 此处 OVER() 中没有 PARTITION BY，所以整张表就是一个分区
       -- ORDER BY score DESC：按照 score 对每个分区内的数据降序排序
       -- RANK() 窗口函数的作用是对每个分区内的每一行产生一个排名序号
       RANK() OVER (ORDER BY score DESC) as `rank`
FROM tb_score;

-- 排序函数
-- RANK()：产生的排名序号 ，有并列的情况出现时序号不连续
-- DENSE_RANK() ：产生的排序序号是连续的，有并列的情况出现时序号会重复
-- ROW_NUMBER() ：返回连续唯一的行号，排名序号不会重复


-- PARTITION BY和排序函数配合

-- 示例1：
-- 需求：按照不同科目，对学生的分数从高到低进行排名(要求：连续可重复)
-- 查询结果字段：
-- name、course、score、dense_rank(排名序号)
SELECT name,
       course,
       score,
       DENSE_RANK() OVER (
           PARTITION BY course
           ORDER BY score DESC) `dense_rank`
FROM tb_score;

-- 典型应用：获取指定排名的数据

-- 示例1
-- 需求：获取每个科目，排名第二的学生信息
-- 查询结果字段：
--  name、course、score
SELECT name,
       course,
       score
FROM (
         SELECT name,
                course,
                score,
                DENSE_RANK() OVER (
                    PARTITION BY course
                    ORDER BY score DESC
                    ) `dense_rank`
         FROM tb_score
     ) `s`
WHERE `dense_rank` = 2;

-- CTE(公用表表达式)

-- CTE(公用表表达式)：Common Table Expresssion，类似于子查询，相当于一张临时表，可以在 CTE 结果的基础上，进行进一步的查询操作。
-- 基础语法
# WITH some_name AS (
#     -- your cte --
# )
# SELECT
#     ...
# FROM some_name;

-- 示例1
-- 需求：获取每个科目，排名第二的学生信息
-- 查询结果字段：
--  name、course、score
WITH ranking AS (
    SELECT name,
           course,
           score,
           DENSE_RANK() over (
               PARTITION BY course
               ORDER BY score DESC
               ) AS `dense_rank`
    FROM tb_score
)
SELECT name,
       course,
       score
FROM ranking
WHERE `dense_rank` = 2;

-- 4. 自定义window frame

-- 分区数据范围和window frame范围
-- 在使用窗口函数处理表中的每行数据时，每行数据关联的数据有两种：
-- 1）每行数据关联的分区数据
--      OVER()中什么都不写时，整张表默认是一个分区
--      OVER(PARTITION BY 列名, ...)：整张表按照指定的列被进行了分区
-- 2）每行数据关联的分区中的window frame数据
--      每行关联的分区window frame数据范围 <= 每行关联的分区数据范围

-- 目前我们所学的窗口函数中，有些窗口函数作用在分区上，有些函数作用在window frame上：
--  聚合函数(SUM、AVG、COUNT、MAX、MIN)作用于每行关联的分区window frame数据上
--  排序函数(RANK、DENSE_RANK、ROW_NUMBER)作用于每行关联的分区数据上

-- 自定义window frame语法
# <window function> OVER (
#   PARTITION BY 列名, ...
#   ORDER BY 列名, ...
#   [ROWS|RANGE] BETWEEN 上限 AND 下限
# )
-- PARTITION BY 列名, ...：按照指定的列，对整张表的数据进行分区
-- ORDER BY 列名, ...：按照指定的列，对每个分区内的数据进行排序
-- [ROWS|RANGE] BETWEEN 上限 AND 下限：在分区数据排序的基础上，设置每行关联的分区window frame范围

-- 上限和下限的设置：
-- UNBOUNDED PRECEDING：对上限无限制
-- PRECEDING： 当前行之前的 n 行 （ n 表示具体数字如：5 PRECEDING ）
-- CURRENT ROW：仅当前行
-- FOLLOWING：当前行之后的 n 行 （ n 表示具体数字如：5 FOLLOWING ）
-- UNBOUNDED FOLLOWING：对下限无限制

-- 应用示例
-- 示例1
-- 需求：计算截止到每个月的累计销量。1月：1月销量，2月：1月销量+2月销量，3月：1月销量+2月销量+3月销量，依次类推
-- 查询结果字段：
--  month(月份)、sales(当月销量)、running_total(截止当月累计销量)

SELECT *
FROM tb_sales;
-- 查看 tb_sales 表的数据


-- 示例2
-- 需求：计算每3个月(前1个月、当前月、后1一个月)的累计销量。1月：1月销量+2月销量，2月：1月销量+2月销量+3月销量，3月：2月销量+3月销量+4月销量，依次类推
-- 查询结果字段：
--  month(月份)、sales(当月销量)、running_total(每3个月累计销量)


-- ROWS和RANGE的区别

-- ROWS和RANGE关键字，都可以用来自定义 windowframe 范围：
--  ROWS BETWEEN 上限 AND 下限
--  RANGE BETWEEN 上限 AND 下限

-- ROWS是根据分区数据排序之后，每一行的 row_number 确定每行关联的 window frame 范围的
-- RANGE是根据分区数据排序之后，每一行的 rank 值确实每行关联的 window frame 范围的

-- 示例1
-- 需求：计算截止到每个月的累计销量。1月：1月销量，2月：1月销量+2月销量，3月：1月销量+2月销量+3月销量，依次类推
-- 查询结果字段：
--  month(月份)、sales(当月销量)、running_total(截止当月累计销量)

-- 向表中在添加一条6月份的销售记录，这样表中就有2条六月份的销售记录
INSERT INTO tb_sales
VALUES (6, 10);

SELECT *
FROM tb_sales;
-- 查看 tb_sales 表的数据


-- 默认的 window frame
-- 在 OVER 中只要添加了 ORDER BY，在没有写ROWS或RANGE的情况下，会有一个默认的 window frame范围：
--  RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- 示例1：需求：计算截止到每个月的累计销量。1月：1月销量，2月：1月销量+2月销量，3月：1月销量+2月销量+3月销量，依次类推
-- 查询结果字段：
--  month(月份)、sales(当月销量)、running_total(截止当月累计销量)


-- PARTITION BY和自定义window frame
-- 查看 tb_revenue 表的内容
SELECT *
FROM tb_revenue;

-- 示例1
-- 需求：计算每个商店截止到每个月的累计销售额。1月：1月销量，2月：1月销量+2月销量，3月：1月销量+2月销量+3月销量，依次类推
-- 查询结果字段：
--  store_id(商店id)、month(月份)、revenue(当月销售额)、sum(截止当月累计销售额)

