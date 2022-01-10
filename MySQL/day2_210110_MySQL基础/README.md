## I. DQL数据查询语言

1. ### 排序查询

    ##### ASC: 升序(默认) | DESC: 降序

    ```mysql
    -- 1. DQL-排序操作
    -- 语法：SELECT * FROM 表名 ORDER BY 列1 ASC|DESC, 列2 ASC|DESC, ...
    
    -- 示例1：将所有的商品查询出来之后，根据价格进行降序排列
    SELECT * FROM product ORDER BY price DESC;
    
    -- 示例2：将所有商品查询出来后根据价格降序排列，如果价格相同，根据category_id升序排列
    SELECT * FROM product ORDER BY price DESC, category_id;
    ```

2. ### 聚合函数

    > - ##### 聚合函数的计算会忽略NULL值

    ```mysql
    -- 2. DQL-聚合操作
    # COUNT(col)：表示求指定列的总记录数
    # MAX(col)：表示求指定列的最大值
    # MIN(col)：表示求指定列的最小值
    # SUM(col)：表示求指定列的和
    # AVG(col)：表示求指定列的平均值
    # 注意：聚合函数的计算会忽略 NULL 值
    
    -- 示例1：求当前商品一共有多少件
    SELECT COUNT(pid) FROM product;
    
    -- 示例2：查询当前有多少条category_id不为空的记录
    SELECT COUNT(category_id) FROM product;
    
    -- 示例3：求当前商品价格大于600的商品有多少件
    SELECT COUNT(pid) FROM product WHERE price > 600;
    
    -- 示例4：求 category_id='c001'的所有商品的价格最大值
    SELECT MAX(price) FROM product WHERE category_id = 'c001';
    
    -- 示例5：求 category_id='c002' 的所有商品的价格最小值
    SELECT MIN(price) FROM product WHERE  category_id = 'c002';
    
    -- 示例6：求所有 category_id='c002' 的商品的价格总和
    SELECT SUM(price) FROM product WHERE category_id = 'c002';
    
    -- 示例7：求所有商品的平均价格
    SELECT AVG(price) FROM product;
    
    -- 示例8：求所有商品的平均价格与价格最大值的差值
    SELECT MAX(price) - AVG(price) FROM product;
    ```

3. ### 分组查询

    ##### 分组查询就是将查询结果按照指定字段进行分组, 指定字段数据值相同的分为一组

    ##### 语法:

    ```mysql
    SELECT
    	分组字段...,
    	聚合函数(字段)...
    FROM 表名
    GROUP BY 分组字段1, 分组字段2...
    HAVING 条件表达式: 用来过滤分组后的数据
    ```

    - GROUP BY: 按照指定列的值对数据进行分组
    - 分组后, 可以查询每一组的分组字段, 或对每组的指定列进行聚合操作
    - HAVING条件表达式: 用来过滤分组之后的数据

    #### HAVING和WHERE的区别:

    ​	HAVING是在分组后对数据进行过滤, WHERE是在分组前对数据进行过滤

    ​	HAVING后面可以使用聚合函数(统计函数), WHERE后面不可以使用聚合函数

    > ##### 分组聚合操作时, SELECT之后只能查询分组字段和聚合函数, 查询其他会报错

    ```mysql
    -- 3. DQL-分组操作
    # 语法
    # SELECT
    #     分组字段...,
    #     聚合函数(字段)...
    # FROM 表名
    # GROUP BY 分组字段1, 分组字段2...
    # HAVING 条件表达式;
    
    -- 示例1：分组后查看表中有哪些category_id
    SELECT
        category_id
    FROM product
    GROUP BY category_id;
    
    -- 示例2：查看每类商品的最大价格
    SELECT
        category_id,
        MAX(price)
    FROM product
    GROUP BY category_id;
    
    -- 查看每类商品的最大价格和平均价格
    SELECT
        category_id,
        MAX(price),
        AVG(price)
    FROM product
    GROUP BY category_id;
    
    -- 示例3：将所有商品按组分类，获取每组的平均价格大于600的所有分组
    SELECT
        category_id,
        AVG(price)
    FROM product
    GROUP BY category_id
    HAVING AVG(price) > 600;
    
    -- 示例4：统计各个分类商品的个数，且只显示个数大于1的信息
    SELECT
        category_id,
        COUNT(pid)
    FROM product
    GROUP BY category_id
    HAVING COUNT(pid) > 1;
    ```

4. ### 分页查询

    语法:

    ```mysql
    SELECT
    	字段列表
    FROM 表名
    LIMIT M, N
    ```

    其中,

    ​	M: 表示开始行索引, 默认是0, 代表从下标M的位置开始分页

    ​	N: 表示查询条数, 即提取多少条数据

    ```mysql
    -- 4. DQL-分页查询
    # 语法：SELECT 字段列表 FROM 表名 LIMIT M, N
    # M表示开始行索引，默认是0，代表从下标M的位置开始分页
    # N表示查询条数，即提取多少条数据
    
    -- 示例1：获取 product 表中的第一条记录
    SELECT * FROM product LIMIT 0, 1;
    
    -- 示例2：获取 product 表中下标为2记录开始的2条记录
    SELECT * FROM product LIMIT 2, 2;
    
    
    -- 示例3：获取当前产品中，类别为'c002'的产品里，价格最低的2件商品
    SELECT
        *
    FROM product
    WHERE category_id = 'c002'
    ORDER BY price
    LIMIT 0, 2;
    
    -- 示例4：当分页展示的数据不存在时，不报错，只不过查询不到任何数据
    SELECT
        *
    FROM product
    WHERE category_id = 'c002'
    ORDER BY price
    LIMIT 25, 2;
    ```

    

## II. 多表关联查询

1. ### 表之间的3种关联关系: 一对多, 一对一, 多对多

2. ### 外键约束

3. ### 连接查询: 内连接, 外连接, 右连接, 全连接, 自连接