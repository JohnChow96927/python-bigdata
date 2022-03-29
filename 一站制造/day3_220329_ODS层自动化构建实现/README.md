# ODS层自动化构建实现

## I. 数仓分层回顾



## II. Hive建表语法



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

    