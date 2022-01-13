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

    

## II. 报表案例

1. Northwind数据集介绍
2. SQL数据汇总操作