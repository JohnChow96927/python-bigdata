## I. 子查询

1. ### AS起别名

    - #### 给字段起别名

    ```mysql
    -- 示例1：查询每个分类的商品数量
    SELECT
           category_id,
           COUNT(*) product_count
    FROM products
    GROUP BY category_id;
    
    -- 注意: 别名和关键字同名时, 别名两侧要加反引号
    SELECT category_id, COUNT(*) `desc`
    FROM products
    GROUP BY category_id;
    ```

    - #### 给表起别名

    ```mysql
    -- 示例2：查询每个分类名称所对应的商品数量(没有商品的分类的也要显示)
    SELECT
    c.cname, COUNT(*) product_count
    FROM
    category c
    LEFT JOIN products p
    ON c.cid = p.category_id
    GROUP BY c.cname;
    ```

    > ##### 可以给所有别名两端都加反引号``, 确保不会报错

2. ### 子查询操作

    > #####  在一个SELECT语句中, 嵌入了另外一个SELECT语句, 那么被嵌入的SELECT语句称为子查询语句, 外部的SELECT语句称为主查询

    #### 主查询和子查询的关系:

     1. 子查询嵌入到主查询中

     2. ##### 子查询是辅助主查询的, 要么充当条件, 要么充当数据源, 要么充当查询字段

     3. 子查询是可以独立存在的, 是一条完整的SELECT语句

    - ##### 充当条件

    ```mysql
    
    ```

    

    - ##### 充当数据源

    ```mysql
    
    ```

    

    - ##### 充当查询字段

    ```mysql
    
    ```

    

## II. 窗口函数

1. ### 窗口函数简介

    

2. ### 窗口函数基础用法: OVER关键字

    

3. ### PARTITION BY分区

    

4. ### 排序函数: 产生排名

    

5. ### 自定义window frame