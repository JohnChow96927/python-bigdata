# ============================================ 窗口函数避坑指南 ============================================

DESC auction;
SELECT *
FROM auction;

-- 1. 不能使用窗口函数的情况

-- 情况1：不能在 WHERE 子句中使用窗口函数
-- 需求：查询出所有拍卖中，最终成交价格高于平均成交价格的拍卖
-- 查询结果字段：
-- 	id、final_price(最终成交价格)

# 错误示例
SELECT id,
       final_price
FROM auction
WHERE final_price > AVG(final_price) OVER ();

# 正确写法(子查询)
SELECT id,
       final_price
FROM auction
WHERE final_price > (
    SELECT AVG(final_price)
    FROM auction
);

# CTE表达式
WITH temp_tb AS (
    SELECT id,
           final_price,
           AVG(final_price) OVER () `avg_final_price`
    FROM auction
)
SELECT id,
       final_price
FROM temp_tb
WHERE final_price > avg_final_price;


-- 情况2：不能在HAVING子句中使用窗口函数

-- 需求：查询出国内平均成交价格高于所有拍卖平均成交价格的国家
-- 查询结果字段：
-- 	country(国家)、avg(该国家所有拍卖的平均成交价)

# 错误示例
SELECT country,
       AVG(final_price) AS `avg`
FROM auction
GROUP BY country
HAVING AVG(final_price) > AVG(final_price) OVER ();


# 正确写法(子查询)
SELECT country,
       AVG(final_price) `avg`
FROM auction
GROUP BY country
HAVING AVG(final_price) > (
    SELECT AVG(final_price)
    FROM auction
);



-- 情况3：不能在GROUP BY子句中使用窗口函数

-- NTILE(X)窗口函数：
-- 将每个分区的数据均匀的分成X组，返回每行对应的组号

-- 需求：将所有的拍卖信息按照浏览次数排序，并均匀分成4组，添加组号
-- 查询结果字典：
--  id、views(浏览次数)、quartile(分组序号)
SELECT id,
       views,
       NTILE(4) over (ORDER BY views DESC) `quartile`
FROM auction;



-- 需求：将所有的拍卖信息按照浏览次数排序，并均匀分成4组，然后计算每组的最小和最大浏览量
-- 查询结果字段：
-- 	quartile(分组序号)、min_views(当前组最小浏览量)、max_view(当前组最大浏览量)

# 错误示例
SELECT NTILE(4) OVER (ORDER BY views DESC) AS `quartile`,
       MIN(views)                          AS `min_views`,
       MAX(views)                          AS `max_views`
FROM auction
GROUP BY NTILE(4) OVER (ORDER BY views DESC);

# 正确实现(子查询)
SELECT `quartile`,
       MIN(views) `min_views`,
       MAX(views) `max_views`
FROM (
         SELECT views,
                NTILE(4) over (ORDER BY views DESC) `quartile`
         FROM auction
     ) c
GROUP BY `quartile`;


# CTE公用表表达式
WITH c AS (
    SELECT views,
           NTILE(4) over (ORDER BY views DESC) `quartile`
    FROM auction
)
SELECT `quartile`,
       MIN(views) `min_views`,
       MAX(views) `max_views`
FROM c
GROUP BY `quartile`;

# 1.2 能够使用窗口函数的情况

-- 情况1：在ORDER BY中使用窗口函数

-- 需求：将所有的拍卖按照浏览量降序排列，并均分成4组，按照每组编号降序排列
-- 查询结果字段：
-- 	id(拍卖ID)、views(浏览量)、quartile(分组编号)
SELECT id,
       views,
       NTILE(4) OVER (ORDER BY views DESC) `quartile`
FROM auction
ORDER BY quartile DESC;

-- 情况2：窗口函数与GROUP BY一起使用

-- 需求：查询拍卖信息，并统计所有拍卖的平均成交价格
-- 查询结果字段：
-- 	category_id(类别ID)、final_price(最终成交价格)、avg_final_price(所有拍卖平均成交价格)


-- 接下来我们对上面的SQL做一个简单的调整，添加一个GROUP BY子句


-- 我们再对上述窗口函数进行调整，看下这次能否正确执行


-- 练习1
-- 需求：将拍卖数据按国家分组，返回如下信息
-- 查询结果字段：
-- 	country(国家)、min(每组最少参与人数)、avg(所有组最少参与人数的平均值)
SELECT country,
       MIN(participants)              `min`,
       AVG(MIN(participants)) OVER () `avg`
FROM auction
GROUP BY country;

WITH temp_tb AS(
    SELECT country,
           MIN(participants) `min`
    FROM auction
    GROUP BY country
)
SELECT country,
       `min`,
       AVG(`min`) OVER () `avg`
FROM temp_tb;

-- 排序函数使用聚合函数的结果
-- 练习2
-- 需求：按国家进行分组，计算了每个国家的拍卖次数，再根据拍卖次数对国家进行排名
-- 查询结果字段：
-- 	country(国家)、count(该国家的拍卖次数)、rank(按拍卖次数的排名)
SELECT country,
       COUNT(id) `count`,
       RANK() OVER (
           ORDER BY COUNT(id) DESC
           )     `rank`
FROM auction
GROUP BY country;

-- 对GROUP BY分组后的数据使用PARTITION BY
-- 我们可以对GROUP BY分组后的数据进一步分区（PARTITION BY） ，再次强调，使用GROUP BY 之后使用窗口函数，只能处理分组之后的数据，而不是处理原始数据

-- 练习3
-- 需求：将所有的数据按照国家和拍卖结束时间分组，返回如下信息
-- 查询结果字段：
-- 	country(国家)、ended(拍卖结束时间)、views_sum(该分组浏览量总和)、country_views_sum(分组聚合结果中不同国家拍卖的总浏览量)
SELECT country,
       ended,
       SUM(views) `views_sum`,
       SUM(SUM(views)) OVER (PARTITION BY country) `country_views_sum`
FROM auction
GROUP BY country, ended;

WITH temp_tb AS (
    SELECT country,
           ended,
           SUM(views) `views_sum`
    From auction
    GROUP BY country, ended
)
SELECT country,
       ended,
       views_sum,
       SUM(views_sum) OVER (PARTITION BY country) `country_views_sum`
FROM temp_tb;
