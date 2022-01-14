CREATE TABLE business
(
    name      VARCHAR(20),
    orderdate VARCHAR(20),
    cost      INT
);

LOAD DATA INFILE '/Users/zhengyuan.zhou/Heima/就业班笔记及代码/ITheima_python_bigdata/就业指导文档/220114/data.txt' INTO TABLE business
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n';

SHOW VARIABLES LIKE 'secure_file_priv';

select *
from business;
-- 1. 查询在2017年4月份购买过的顾客及顾客的购买次数
SELECT name     `顾客`,
       COUNT(*) `购买次数`
FROM business
WHERE MONTH(orderdate) = 4
GROUP BY name;

-- 2.1. 查询每个顾客每个月购买总额明细
SELECT DISTINCT name                                                 `顾客`,
                MONTH(orderdate)                                     `月份`,
                SUM(cost) OVER (PARTITION BY MONTH(orderdate), name) `购买总额`
FROM business;

-- 2.2. 查询每个顾客到目前为止的购买总金额明细
SELECT DISTINCT name                               `顾客`,
                SUM(cost) OVER (PARTITION BY name) `购买总金额`
FROM business;

-- 3. 查询顾客上次的购买时间
SELECT DISTINCT name                                                       `顾客`,
                orderdate                                                  `此次购买时间`,
                LAG(orderdate) over (PARTITION BY name ORDER BY orderdate) `上次购买时间`
FROM business;


-- 4. 查询前20%时间的订单信息
WITH temp_tb AS (SELECT *,
                        NTILE(5) over (ORDER BY orderdate) `N`
                 FROM business
)
SELECT name,
       orderdate,
       cost
FROM temp_tb
WHERE N = 1;


-- 连续活跃问题
-- （1） 某APP用户活跃记录表active，有uid（用户id）、dt（活跃日期）字段，求出连续出勤3天及以上的用户数




-- （2） 某APP用户活跃记录表active，有uid（用户id）、dt（活跃日期）字段，求每个用户的最大连续活跃天数









-- 希望知道ALLEN和WARD的HIREDATE相差多少天
-- 计算两个时间日期之间的天数差
SELECT DATEDIFF('2021-03-22 09:00:00', '2018-03-20 07:00:00');

CREATE TABLE IF NOT EXISTS T1(
    name VARCHAR(10),
    `date` date
);

INSERT INTO T1 VALUES ('ALLEN', '2021-12-01'),
                      ('WARD', '2019-12-01');

SELECT *
FROM T1;

SELECT DATEDIFF(a.date, b.date)
FROM T1 a
JOIN T1 b
WHERE a.name = 'ALLEN' AND b.name = 'WARD';