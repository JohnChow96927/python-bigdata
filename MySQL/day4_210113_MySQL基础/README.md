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
        
        ```

    3. 不能在GROUP BY子句中使用窗口函数

3. 能够使用窗口函数的情况

## II. 报表案例

1. Northwind数据集介绍
2. SQL数据汇总操作