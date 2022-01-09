# I. MySQL数据库简介

1. ### 数据库的概念和作用

    数据库就是**存储和管理数据的仓库**, 用户可以对数据库中的数据进行增加, 修改, 删除, 查询等操作

2. ### 数据库的分类及常见数据库

    关系型数据库: 数据以行列表格的形式进行存储

    ​	**MySQL**, Oracle, DB2, SQL Server, Sqlite(小型关系型数据库)

    非关系型数据库: Key-Value形式进行数据存储

    ​	 MongoDB, **Redis**, **HBase**

3. ### MySQL的简介

    MySQL是一个关系型数据库管理系统

    MySQL是C/S软件: 分为客户端和服务器

    特点:

     	1. 开源, 提供免费版本
     	2. 支持大型数据库
     	3. 使用**标准SQL数据语言**形式
     	4. 兼容不同操作系统, 提供多种编程语言的操作接口
     	5. 支持多种存储引擎
     	6. 服务端端口号: 3306

4. ### MySQL数据库的登录和退出

    MySQL登录:

    > mysql -h数据库服务端IP -P数据库服务器端口 -u用户名 -p密码

    -h默认为127.0.0.1, 可以省略

    -P默认为3306, 可以省略

    MySQL退出:

    > **quit**
    >
    > 或
    >
    > **exit**

5. ### DataGrip基本使用

    - 创建工程
    - 连接数据库
    - DataGrip配置
    - 创建查询
    - Ctrl(command)+Enter(return)

# II. SQL语句作用及分类介绍

- #### SQL全称是结构化查询语言(Structured Query Language)

- #### SQL是关系型数据库管理系统都需要遵循的规范, 是操作关系型数据库的语言

- #### 只要是关系型数据库, 都支持SQL

- #### SQL语句的作用: 

    #### 数据库(表)的增删改查, 表记录的增删改查…..

- #### SQL语句的分类:

    - DDL: Definition 数据定义语言, 用来定义数据库对象: 数据库, 表, 列等

    - DML: Manipulation 数据操作语言, 用于对数据库中表的记录增删改

    - ### DQL: Query 数据查询语言, 用来查询数据库中表的记录(核心重点)

    - DCL: Control 数据控制语言, 定义访问权限和安全级别, 创建用户

- #### SQL通用语法

    1. 可以单行或多行书写, 以分号结尾

    2. 可使用空格和缩进来增强语句的可读性

    3. ##### MySQL数据库的SQL语句不区分大小写, 关键字建议使用大写

    4. 可以使用`/* */`, `—`, `#`注释

# III. DDL数据定义语言

- #### 主要负责数据库及数据表的结构设置, 即搭建保存数据的容器, 并定义存储规则

- ### DDL - 数据库操作

    ```mysql
    -- 1. DDL-数据库操作
    -- 创建数据库语法
    -- CREATE DATABASE 数据库名;
    
    -- 数据库不存在才创建数据库
    -- CREATE DATABASE IF NOT EXISTS 数据库名;
    
    -- 创建数据库并指定 utf8 编码字符集
    -- 方式1：CREATE DATABASE 数据库名 CHARACTER SET utf8;
    -- 方式2：CREATE DATABASE 数据库名 CHARSET=utf8;
    
    -- 示例1：创建一个名为 bigdata_db 的数据库
    CREATE DATABASE bigdata_db;
    
    -- 示例2：数据库不存在时，才创建数据库
    CREATE DATABASE IF NOT EXISTS bigdata_db;
    
    -- 示例3：创建数据库并指定 utf8 编码字符集
    CREATE DATABASE IF NOT EXISTS bigdata_db2 CHARSET=utf8;
    
    
    -- 查看数据库语法
    -- SHOW DATABASES;
    
    -- 示例4：查看当前有哪些数据库
    SHOW DATABASES;
    
    -- 使用数据库语法
    -- USE 数据库名;
    
    -- 示例5：使用 bigdata_db 数据库
    USE bigdata_db;
    
    -- 示例6：使用 bigdata_db2 数据库
    USE bigdata_db2;
    
    -- 删除数据库语法【一定要慎重！！！】
    -- DROP DATABASE 数据库名;
    
    -- 示例8：删除 bigdata_db 数据库
    DROP DATABASE bigdata_db;
    
    -- 示例9：删除 bigdata_db2 数据库
    DROP DATABASE bigdata_db2;
    ```

- ### DDL - 数据表操作

    ```mysql
    -- 2. DDL-表操作
    -- 创建表语法
    # CREATE TABLE 表名(
    #     字段名1 数据类型(长度) 约束,
    #     字段名2 数据类型(长度) 约束
    #     ...
    # );
    
    CREATE DATABASE IF NOT EXISTS bigdata_db CHARSET=utf8;
    USE bigdata_db;
    
    -- 示例1：创建一个 category 数据表
    CREATE TABLE category(
        cid INT PRIMARY KEY NOT NULL,
        cname VARCHAR(100)
    );
    
    -- 查看表语法
    -- SHOW TABLES; -- 显示当前数据库中有哪些表
    -- DESC 表名; -- 查看指定数据表的表结构
    
    -- 示例2：查看当前数据库中有哪些表
    SHOW TABLES;
    
    -- 示例3：查看 category 数据表的结构
    DESC category;
    
    -- 修改表语法
    -- RENAME TABLE 表名 TO 新表名; -- 修改表名
    
    -- 示例4：将 category 表重命名为 categories
    RENAME TABLE category TO categories;
    
    -- 删除表语法
    -- DROP TABLE 表名; -- 删除指定数据表
    DROP TABLE categories;
    ```

- ### DDL - 数据类型和约束

    - 数据类型:
        - 整数: int, bit
        - 小数: decimal(m, n): 共m位, 小数占n位, 不满位数往高位补零
        - 字符串: varchar, char: varchar为可变长度字符串, char为固定长度字符串, 不满向后补空格
        - 日期和时间: date, time, datetime
        - 枚举类型(enum)
        - text存储大文本
    - 数据约束: 
        - **PRIMARY KEY**主键约束: 物理上存储的顺序. 建议叫id, int unsigned类型
        - **NOT** **NULL**非空约束
        - **UNIQUE**唯一约束:
        - **DEFAULT**默认值约束:
        - **FOREIGN KEY**外键约束:

- ### DDL - 表结构(字段)操作

    - 实际开发中创建的数据库一般只满足第一版需求

    ```mysql
    -- 3. DDL-表结构(字段)操作
    
    CREATE TABLE category(
        # 字段1名称为cid，数据类型为整型，添加主键约束及非空约束
        cid INT PRIMARY KEY NOT NULL,
        # 字段2名称为cname，数据类型为varchar,最大长度为100
        cname VARCHAR(100)
    );
    
    
    -- 添加字段语法
    -- ALTER  TABLE  表名  ADD  列名  类型(长度)  [约束];
    
    -- 示例1：给 category 表添加一个 num 字段
    ALTER TABLE category ADD num INT NOT NULL;
    
    -- 示例2：给 category 表添加一个 desc 字段
    -- 注意：添加字段如果和SQL关键字同名，字段两边必须加反引号``
    ALTER TABLE category ADD `desc` VARCHAR(100);
    
    -- 修改字段语法
    -- ALTER TABLE 表名 CHANGE 旧列名 新列名 类型(长度) 约束;
    
    -- 示例3：将 category 表的 desc 字段修改为 description 字段
    ALTER TABLE category CHANGE `desc` description VARCHAR(100);
    
    -- 删除字段语法
    -- ALTER TABLE 表名 DROP 列名;
    
    -- 示例4：删除 category 表的 num 字段
    ALTER TABLE category DROP num;
    ```

- ### DDL - 数据约束进阶

    - ##### 主键约束: 

    - ##### 非空约束: 

    - ##### 唯一约束: 

    - ##### 默认值约束: 

# IV. DML数据操作语言

- ### DML - 增加表记录: 

    ```mysql
    -- 1. 插入表记录
    -- 一次添加一行数据
    -- 不指定字段：INSERT INTO 表 VALUES(值1, 值2, 值3...);
    -- 指定字段：INSERT INTO 表 (字段1, 字段2, 字段3...) VALUES(值1, 值2, 值3...);
    
    -- 示例1：在 category 表中插入一条记录：cid=1, cname='服饰', description='秋冬装5折'
    INSERT INTO category VALUES (1, '服饰', '秋冬装5折');
    
    -- 示例2：在 category 表中插入一条记录：cid=2, cname='电器'
    INSERT INTO category(cid, cname) VALUES (2, '电器');
    
    -- 一次添加多行数据
    -- 不指定字段：INSERT INTO 表 VALUES(值1, 值2, 值3...), (值1, 值2, 值3...), ...;
    -- 指定字段：INSERT INTO 表 (字段1, 字段2, 字段3...) VALUES(值1, 值2, 值3...), (值1, 值2, 值3...)...;
    
    -- 示例1：在 category 表中插入2条记录：
    -- cid=3, cname='玩具', description='奥迪双钻我的伙伴'
    -- cid=4, cname='蔬菜', description='时令蔬菜，新鲜速达'
    INSERT INTO category
    VALUES
            (3, '玩具', '奥迪双钻我的伙伴'),
            (4, '蔬菜', '时令蔬菜，新鲜速达');
    
    -- 示例2：在 category 表中插入3条记录
    INSERT INTO category (cid, cname)
    VALUES
            (5, '化妆品'),
            (6, '书籍'),
            (7, NULL);
    ```

- ### DML - 更新表记录: 

    ```mysql
    -- 2. 更新表记录
    -- 更新所有行：UPDATE 表名 SET 字段名=值, 字段名=值, ...;
    -- 更新满足条件的行：UPDATE 表名 SET 字段名=值, 字段名=值, ... WHERE 条件;
    
    -- 示例1：将 category 表中所有行的 cname 改为 '家电'
    UPDATE category SET cname='家电';
    
    -- 示例2：将 category 表中 cid 为 1 的记录的 cname 改为 '服装'
    UPDATE category SET cname='服饰' WHERE cid=1;
    ```

- ### DML - 删除表记录: 

    ```mysql
    -- 3. 删除表记录
    -- 语法：DELETE FROM 表名 [WHERE 条件];
    
    -- 示例1：删除 category 表中 cid 为 5 的记录
    DELETE FROM category WHERE cid=5;
    
    -- 示例2：删除 category 表中的所有记录
    DELETE FROM category;   # 主键自增队列不清零
    
    -- 语法：TRUNCATE TABLE 表名; -- 清空表数据
    -- 示例3：清空 category 表中的数据
    TRUNCATE TABLE category;    # 主键自增队列清零
    
    -- 补充.逻辑删除: 在表中添加一列, 这一列表示数据是否被逻辑删除, 比如0表示未被删除, 1表示删除
    ALTER TABLE category ADD is_delete BIT;
    
    INSERT INTO category
    VALUES
        (1, '服饰', '棉毛衫', 0),
        (2, '玩具', '四驱车', 0),
        (3, '蔬菜', '时令蔬菜', 0);
    
    -- 逻辑删除的本质是更新删除标记, 标记某个数据被逻辑删除了, 但其实数据还在表中
    UPDATE category SET is_delete=1 WHERE cid=1;
    ```

# V. DQL数据查询语言(重点)

