## I. DQL数据查询语言

1. ### 排序查询

    

    ```mysql
    -- 1. DQL-排序操作
    -- 语法：SELECT * FROM 表名 ORDER BY 列1 ASC|DESC, 列2 ASC|DESC, ...
    
    -- 示例1：将所有的商品查询出来之后，根据价格进行降序排列
    SELECT * FROM product ORDER BY price DESC;
    
    -- 示例2：将所有商品查询出来后根据价格降序排列，如果价格相同，根据category_id升序排列
    SELECT * FROM product ORDER BY price DESC, category_id;
    ```

2. ### 聚合函数

3. ### 分组查询

4. ### 分页查询

## II. 多表关联查询

1. ### 表之间的3种关联关系: 一对多, 一对一, 多对多

2. ### 外键约束

3. ### 连接查询: 内连接, 外连接, 右连接, 全连接, 自连接