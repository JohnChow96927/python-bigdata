-- Q1：求每个月的每个省份的店铺销售额(单个订单销售额=quantity*unit_price)

WITH dim_orders AS (
    -- 订单表：带月份
    SELECT MONTH(order_datetime) AS `month`,
           order_id,
           product_id,
           user_id,
           store_id,
           quantity,
           unit_price
    FROM fact_order_detail
)
SELECT month,
       province_name,
       SUM(quantity * unit_price) AS `total_revenue`
FROM dim_orders do
         JOIN dim_store ds
              ON do.store_id = ds.store_id
         JOIN dim_city dc
              ON ds.city_id = dc.city_id
         JOIN dim_province dp
              ON dc.province_id = dp.province_id
GROUP BY month, province_name
ORDER BY month;


-- Q2：求每个月的每个产品的销售额及其在当月的销售额占比
WITH dim_orders AS (
    -- 订单表：带月份
    SELECT MONTH(order_datetime) AS `month`,
           order_id,
           product_id,
           user_id,
           store_id,
           quantity,
           unit_price
    FROM fact_order_detail
),
     month_product_revenue AS (
         -- 计算每个月每个产品的销售额
         SELECT month,
                product_id,
                SUM(quantity * unit_price) AS `product_revenue`
         FROM dim_orders
         GROUP BY month, product_id
     )
SELECT month,
       product_id,
       product_revenue,
       SUM(product_revenue) OVER (PARTITION BY month)                                                AS `month_revenue`,
       -- 计算占比
       CONCAT(ROUND(product_revenue / SUM(product_revenue) OVER (PARTITION BY month) * 100, 2), '%') AS `ratio`
FROM month_product_revenue;


WITH dim_orders AS (
    -- 订单表：带月份
    SELECT MONTH(order_datetime) AS `month`,
           order_id,
           product_id,
           user_id,
           store_id,
           quantity,
           unit_price
    FROM fact_order_detail
)
SELECT month,
       product_id,
       SUM(quantity * unit_price)                                AS `product_revenue`,
       SUM(SUM(quantity * unit_price)) OVER (PARTITION BY month) AS `month_revenue`,
       CONCAT(ROUND(SUM(quantity * unit_price) / SUM(SUM(quantity * unit_price)) OVER (PARTITION BY month) * 100, 2),
              '%')                                               AS `ratio`
FROM dim_orders
GROUP BY month, product_id;


-- Q3：求每个月的销售额及其环比（销售额环比=(本月销售额-上月销售额)/上月销售额)

WITH dim_orders AS (
    -- 订单表：带月份
    SELECT MONTH(order_datetime) AS `month`,
           order_id,
           product_id,
           user_id,
           store_id,
           quantity,
           unit_price
    FROM fact_order_detail
),
     dim_month_revenue AS (
         -- 计算每个月的销售额
         SELECT month,
                SUM(quantity * unit_price) AS `month_revenue`
         FROM dim_orders
         GROUP BY month
     )
SELECT a.month,
       a.month_revenue                                                                    AS `cur_revenue`,
       b.month_revenue                                                                    AS `pre_revenue`,
       CONCAT(ROUND((a.month_revenue - b.month_revenue) / b.month_revenue * 100, 2), '%') AS `ratio`
FROM dim_month_revenue a
         LEFT JOIN dim_month_revenue b
                   ON a.month = b.month + 1 -- 当前月关联它上个月的数据
ORDER BY a.month;


-- LAG(列名)：返回每个分区中当前行指定列的前一行的这一列数据


WITH dim_orders AS (
    -- 订单表：带月份
    SELECT MONTH(order_datetime) AS `month`,
           order_id,
           product_id,
           user_id,
           store_id,
           quantity,
           unit_price
    FROM fact_order_detail
),
     dim_month_revenue AS (
         -- 计算每个月的销售额
         SELECT month,
                SUM(quantity * unit_price) AS `month_revenue`
         FROM dim_orders
         GROUP BY month
     )
SELECT month,
       month_revenue,
       LAG(month_revenue) OVER (ORDER BY month)                              AS `pre_month_revenue`,
       CONCAT(ROUND((month_revenue - LAG(month_revenue) OVER (ORDER BY month)) /
                    LAG(month_revenue) OVER (ORDER BY month) * 100, 2), '%') AS `ratio`
FROM dim_month_revenue;


-- Q4：求每个月比较其上月的新增用户量及其留存率
-- "新增用户"定义为上月未产生购买行为且本月产生了购买行为的用户
-- "留存用户"定义为上月产生过购买行为且本月也产生了购买行为的人
-- 留存率=本月留存用户数量/上月产生过购买用户数量

-- month、当月新增用户数量、当月留存用户数量、上月购买用户数量

-- 注意：如果一个用户一个月下了多次订单，他也只算一个


WITH month_order_users AS (
    -- 对同一个用户同一个月的订单进行去重
    SELECT DISTINCT MONTH(order_datetime) AS `month`,
                    user_id
    FROM fact_order_detail
),
     tb_temp1 AS (
         SELECT a.month AS `cur_month`,
                a.user_id,
                b.month AS `pre_month`
         FROM month_order_users a
                  LEFT JOIN month_order_users b
             -- 关联同一个用户上个月的订单数据
                            ON a.user_id = b.user_id AND a.month = b.month + 1
     ),
     tb_temp2 AS (
         SELECT cur_month,
                -- 计算每个月的新增用户
                COUNT(CASE
                          WHEN pre_month IS NULL THEN user_id
                    END)       AS `new`,
                -- 计算每个月的留存用户
                COUNT(CASE
                          WHEN pre_month IS NOT NULL THEN user_id
                    END)       AS `retention`,
                -- 计算每个月的购买用户数
                COUNT(user_id) AS `total`
         FROM tb_temp1
         GROUP BY cur_month
     )
SELECT cur_month,
       new,
       retention,
       LAG(total) OVER (ORDER BY cur_month)                                          AS `pre_total`,
       -- 计算每个月的留存率
       CONCAT(ROUND(retention / LAG(total) OVER (ORDER BY cur_month) * 100, 2), '%') AS `ratio`
FROM tb_temp2;