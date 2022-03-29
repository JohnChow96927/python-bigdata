# ODS层自动化构建实现

## I. 数仓分层回顾

- **目标**：**回顾一站制造项目分层设计**

- **实施**

  ![image-20210821102418366](assets/image-20210821102418366-1648541362548.png)

  - ODS层：原始数据层，所有从Oracle中同步过来的数据
  - 实现：101张表的数据和Schema信息已经存储在HDFS上
  - 目标
    - step1：建库建表
    - step2：申明分区

- **小结**

  - 回顾一站制造项目分层设计

## II. Hive建表语法

- **目标**：**掌握Hive建表语法**

- **实施**

  ```sql
  CREATE [TEMPORARY] [EXTERNAL] TABLE [IF NOT EXISTS] [db_name.]table_name
  (
      col1Name col1Type [COMMENT col_comment],
      co21Name col2Type [COMMENT col_comment],
      co31Name col3Type [COMMENT col_comment],
      co41Name col4Type [COMMENT col_comment],
      co51Name col5Type [COMMENT col_comment],
      ……
      coN1Name colNType [COMMENT col_comment]
  
  )
  [COMMENT table_comment]
  [PARTITIONED BY (col_name data_type ...)]
  [CLUSTERED BY (col_name...) [SORTED BY (col_name ...)] INTO N BUCKETS]
  [ROW FORMAT row_format]
  	row format delimited fields terminated by 
  	lines terminated by
  [STORED AS file_format]
  [LOCATION hdfs_path]
  TBLPROPERTIES
  ```

  - **语法**

  - **注意**：能在Hive中运行，通常都可以在SparkSQL中执行，但是Spark中语法有两个细节需要注意

    - Hive语法：支持数据类型比较少，建表语法严格要求顺序

      ```
      Spark：Integer
      Hive：int
      ```

    - SparkSQL语法：支持数据类型兼容Hive类型，顺序有些位置可以互换

    - 本次所有SQL：SparkSQL

- **小结**

  - 掌握Hive建表语法

## III. Avro建表语法



## IV. ODS层自动化构建

### 1. 需求分析



### 2. 创建项目环境



### 3. 代码导入



### 4. 代码结构



### 5. 代码修改



### 6. 连接代码及测试



### 7. 建库代码及测试



### 8. 建表实现分析



### 9. 获取Oracle表元数据



### 10. 申明分区代码及测试



## 附一: 面向对象的基本应用



## 附二: 代码操作数据库

- **规律**：所有数据库，都有一个服务端，代码中构建一个服务端连接，提交SQL给这个服务端

- **步骤**

  - step1：构建连接：指定数据库地址+认证

    ```python
    #  MySQL
    conn = PyMySQL.connect(host=node1, port=3306, username='root', password='123456')
    # Oracle
    conn = cxOracle.connect(host=node1, port=1521, username='root', password='123456', dsn=helowin)
    # ThriftServer/HiveServer2
    ```

  - step2：执行操作

    ```python
    # 构建SQL语句
    sql = 'select * from db_emp.tb_emp'
    # Oracle
    cursor = conn.cursor
    # 执行SQL语句
    cursor.execute(sql)
    ```

  - step3：释放资源

    ```python
    cursor.close()
    conn.close()
    ```

    