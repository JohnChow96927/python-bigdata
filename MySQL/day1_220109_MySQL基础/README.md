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
    
    ```

    

# IV. DML数据操作语言

# V. DQL数据查询语言(重点)