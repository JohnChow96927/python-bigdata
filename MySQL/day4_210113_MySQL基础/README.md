## I. 窗口函数避坑指南

1. SQL语句的执行顺序

    > ##### FROM > JOIN > ON > WHERE > GROUP BY > 聚合函数 > HAVING > 窗口函数 > SELECT > DISTINCT > ORDER BY > LIMIT

    ```mysql
    FROM
    JOIN
    ON
    WHERE
    GROUP BY
    聚合函数
    HAVING
    窗口函数
    SELECT
    DISTINCT (去重)
    ORDER BY
    LIMIT
    ```

2. 不能使用窗口函数的情况

    1. 不能在WHERE子句中使用窗口函数

        ```mysql
        -- 情况1：不能在 WHERE 子句中使用窗口函数
        -- 需求：查询出所有拍卖中，最终成交价格高于平均成交价格的拍卖
        -- 查询结果字段：
        -- 	id、final_price(最终成交价格)
        
        # 错误示例
        SELECT
        	id,
        	final_price
        FROM auction
        WHERE final_price > AVG(final_price) OVER();
        
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
        ```

    2. 不能在HAVING子句中使用窗口函数

        ```mysql
        -- 情况2：不能在HAVING子句中使用窗口函数
        
        -- 需求：查询出国内平均成交价格高于所有拍卖平均成交价格的国家
        -- 查询结果字段：
        -- 	country(国家)、avg(该国家所有拍卖的平均成交价)
        
        # 错误示例
        SELECT
          country,
          AVG(final_price)  AS `avg`
        FROM auction
        GROUP BY country
        HAVING AVG(final_price) > AVG(final_price) OVER();
        
        
        # 正确写法(子查询)
        SELECT country,
               AVG(final_price) `avg`
        FROM auction
        GROUP BY country
        HAVING AVG(final_price) > (
            SELECT AVG(final_price)
            FROM auction
            );
        
        ```

    3. 不能在GROUP BY子句中使用窗口函数

        `NTILE(X)`: 将每个分区的数据均匀分成X组, 返回每行对应的组号, 若11行分3组(除不尽)则分成4,4,3, 前面的块会多一条, 块和块之间相差不能超过1.

        ```mysql
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
        ```

3. 能够使用窗口函数的情况

    > ##### 可以在SELECT和ORDER BY中使用窗口函数

    ```mysql
    -- 情况1：在ORDER BY中使用窗口函数
    
    -- 需求：将所有的拍卖按照浏览量降序排列，并均分成4组，按照每组编号降序排列
    -- 查询结果字段：
    -- 	id(拍卖ID)、views(浏览量)、quartile(分组编号)
    SELECT id,
           views,
           NTILE(4) OVER (ORDER BY views DESC) `quartile`
    FROM auction
    ORDER BY quartile DESC;
    ```

    > ##### GROUP BY和窗口函数配合使用时, 窗口函数处理分组聚合之后的结果, 不再是原始的表数据

    ```mysql
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
    ```

    

## II. 报表案例

1. Northwind数据集熟悉实例

    ```mysql
    -- 练习8
    -- 需求：查询每一个商品的`product_name`、`category_name`、`quantity_per_unit`、`unit_price`、`units_in_stock` 并且通过 `unit_price` 字段排序
    SELECT product_name,
           category_name,
           quantity_per_unit,
           unit_price,
           units_in_stock
    FROM products
    JOIN categories
    ON products.category_id = categories.category_id
    ORDER BY unit_price;
    
    
    
    -- 练习9
    -- 需求：查询提供了3种以上不同商品的供应商列表
    -- 查询结果字段：
    -- 	suppler_id(供应商ID)、company_name(供应商公司名称)、products_count(提供的商品数量)
    SELECT s.supplier_id,
           s.company_name,
           COUNT(*) `products_count`
    FROM suppliers s
    JOIN products p
    ON s.supplier_id = p.supplier_id
    GROUP BY s.supplier_id, s.company_name
    HAVING products_count > 3;
    
    
    
    -- 在标准的 SQL 分组聚合中，除了聚合的结果，其他的列如果在GROUP BY没有出现，不允许出现在 SELECT 中
    -- 在 MySQL 的分组聚合中，SELECT后面的列值只要在每组内都是唯一的，即使在 GROUP BY 中没有出现，MySQL也不会报错
    
    -- MySQL测试版数据库：不会报错
    ```

2. SQL数据汇总操作

    2.1. 详细报告

    ```mysql
    -- 1.1 详细报告
    
    -- 练习1
    -- 需求：查询运输到法国的订单信息，返回如下结果
    --
    -- 查询结果字段：
    -- customer_company_name(客户公司名称)、employee_first_name和employee_last_name(销售员工姓名)、order_date(下单日期)、shipped_date(发货日期)、ship_country(收货国家)
    SELECT c.company_name `customer_company_name`,
           e.first_name `employee_first_name`,
           e.last_name `emloyee_last_name`,
           o.order_date,
           o.shipped_date,
           o.ship_country
    FROM orders o
    JOIN employees e
    ON o.employee_id = e.employee_id
    JOIN customers c
    ON o.customer_id = c.customer_id
    WHERE o.ship_country = 'France';
    
    
    
    -- 练习2
    -- 需求：查询订单编号为10250的订单详情，按商品名称排序，返回如下结果
    -- 查询结果字段：
    -- 	product_name(商品名称)、quantity(购买数量)、unit_price(购买单价)、discount(折扣)、order_date(下单日期)
    SELECT p.product_name,
           oi.quantity,
           oi.unit_price,
           oi.discount,
           o.order_date
    FROM orders o
    JOIN order_items oi on o.order_id = oi.order_id
    JOIN products p on oi.product_id = p.product_id
    WHERE o.order_id = 10250
    ORDER BY p.product_name;
    ```

    