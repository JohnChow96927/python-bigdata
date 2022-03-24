# SQL and DataFrames

## I. SparkSQL数据分析

### 1. SQL分析



### 2. DSL分析之API函数



### 3. DSL分析之SQL函数



### 4. Catalyst优化器



## II. 外部数据源

### 1. 加载load和保存save



### 2. text文本文件



### 3. json文本文件



### 4. parquet列式存储



### 5. csv文本文件



### 6. jdbc数据库

![1632782589780](assets/1632782589780.png)

> SparkSQL模块内置：`jdbc` 方法，可以从常见RDBMS数据库中加载数据和保存数据。

- **load**：加载数据，`spark.read.jdbc()`

![1632782660356](assets/1632782660356.png)

- **save**：保存数据，`dataframe.write.jdbc()`

![1632783123592](assets/1632783123592.png)

> 向MySQL数据库写入数据时，需要将**MySQL JCBC 驱动包**放入到`pyspark`库安装目录`jars`下。

- 远程Python解析器，Linux系统开发测试，目录：`ANACONDA_HOME/lib/python3.8/site-packages/pyspark/jars`

```ini
# 进入目录
cd /export/server/anaconda3/lib/python3.8/site-packages/pyspark/jars

# 上传jar包：mysql-connector-java-5.1.32.jar
rz

```

![1642140852662](assets/1642140852662.png)

- Window系统开发测试，目录：`ANACONDA_HOME/Lib/site-packages/pyspark/jars`，如下图：

![1632783855499](assets/1632783855499.png)

> 保存数据至MySQL数据库，表的创建语句

```SQL
 CREATE TABLE db_company.emp_v2 (
  `empno` int(11) NOT NULL,
  `ename` varchar(10) DEFAULT NULL,
  `job` varchar(9) DEFAULT NULL,
  `sal` double DEFAULT NULL,
  `deptno` int(11) DEFAULT NULL,
  PRIMARY KEY (`empno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;
```

> **案例代码演示**： `09_datasource_jdbc.py`：加载数据库表数据，选择字段后，再次保存数据库表中

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession

if __name__ == '__main__':
    """
    SparkSQL 内置数据源，对MySQL数据库数据进行加载和保存。  
    """

    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取会话实例对象-session
    spark = SparkSession.builder \
        .appName('SparkSession Test') \
        .master('local[2]') \
        .getOrCreate()

    # 2. 加载数据源-source
    props = { 'user': 'root', 'password': '123456', 'driver': 'com.mysql.jdbc.Driver'}
    jdbc_df = spark.read.jdbc(
        'jdbc:mysql://node1.itcast.cn:3306/?serverTimezone=UTC&characterEncoding=utf8&useUnicode=true',
        'db_company.emp',
        properties=props
    )
    jdbc_df.printSchema()
    jdbc_df.show(n=20, truncate=False)

    # 3. 数据转换处理-transformation
    dataframe = jdbc_df.select('empno', 'ename', 'job', 'sal', 'deptno')

    # 4. 处理结果输出-sink
    dataframe.coalesce(1).write.mode('append').jdbc(
        'jdbc:mysql://node1.itcast.cn:3306/?serverTimezone=UTC&characterEncoding=utf8&useUnicode=true',
        'db_company.emp_v2',
        properties=props
    )

    # 5. 关闭会话实例对象-close
    spark.stop()

```

### 7. hive表

> Spark SQL模块从发展来说**，从Apache Hive框架而来**，发展历程：==Hive（MapReduce）-> Shark(Hive on Spark) -> Spark SQL（SchemaRDD -> DataFrame -> Dataset)==，所以SparkSQL天然无缝集成Hive，可以加载Hive表数据进行分析。

![1632784740343](assets/1632784740343.png)

- 第一步、当编译Spark源码时，需要指定集成Hive，命令如下

![1632784763951](assets/1632784763951.png)

- 第二步、SparkSQL集成Hive本质就是：[读取Hive框架元数据MetaStore]()，此处启动Hive MetaStore服务即可。

```bash
# 启动HDFS服务：NameNode和DataNodes
(base) [root@node1 ~]# start-dfs.sh 

# 启动HiveMetaStore 服务
(base) [root@node1 ~]# start-metastore.sh 
```

- 第三步、连接HiveMetaStore服务配置文件`hive-site.xml`，放于【`$SPARK_HOME/conf`】目录

  - 创建hive-site.xml文件

  ```ini
  [root@node1 ~]# cd /export/server/spark-local/conf
  [root@node1 conf]# touch hive-site.xml
  
  [root@node1 conf]# vim hive-site.xml
  ```

  - 添加如下内容：

  ```xml
  <?xml version="1.0"?>
  <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
  <configuration>
      <property>
          <name>hive.metastore.uris</name>
          <value>thrift://node1.itcast.cn:9083</value>
      </property>
  </configuration>
  ```

- 第四步、案例演示，读取Hive中`db_hive.emp`表数据，分析数据

```bash
(base) [root@node1 ~]# jps
4338 RunJar
4549 Jps
3178 NameNode
4252 DataNode

(base) [root@node1 ~]# /export/server/spark-local/bin/pyspark --master local[2] --conf spark.sql.shuffle.partitions=2    

>>> spark.sql("show databases").show()
>>> spark.sql("show tables in db_hive") .show()
>>> emp_df = spark.sql("select * from db_hive.emp").show()

>>> spark.sql("select e.ename, e.sal, d.dname from db_hive.emp e join db_hive.dept d on e.deptno = d.deptno").show()

>>> df = spark.read.table("db_hive.emp")
>>> df.printSchema()
>>> df.show(15)

```

> 将DataFrame数据保存到表中时，使用方法：`saveAsTable`

![1632785676864](E:/Heima/%E5%B0%B1%E4%B8%9A%E7%8F%AD%E6%95%99%E5%B8%88%E5%86%85%E5%AE%B9%EF%BC%88%E6%AF%8F%E6%97%A5%E6%9B%B4%E6%96%B0%EF%BC%89/PySpark/%E9%A2%84%E4%B9%A0%E8%B5%84%E6%96%99/pyspark_day07_20220324/03_%E7%AC%94%E8%AE%B0/assets/1632785676864.png)

```bash
# 当向Hive表保存数据，注意HDFS用户权限，可以设置 /user/hive/warehouse 为 777
hdfs dfs -chmod 777 /user/hive/warehouse/db_hive.db
```

> 在PyCharm中开发应用，集成Hive，读取表的数据进行分析，**构建SparkSession时需要设置HiveMetaStore服务器地址**及**集成Hive选项**。

![1632785345780](E:/Heima/%E5%B0%B1%E4%B8%9A%E7%8F%AD%E6%95%99%E5%B8%88%E5%86%85%E5%AE%B9%EF%BC%88%E6%AF%8F%E6%97%A5%E6%9B%B4%E6%96%B0%EF%BC%89/PySpark/%E9%A2%84%E4%B9%A0%E8%B5%84%E6%96%99/pyspark_day07_20220324/03_%E7%AC%94%E8%AE%B0/assets/1632785345780.png)

> **案例代码演示**： `10_datasource_hive`：从Hive表加载数据，并且将数据保存到Hive表。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession

if __name__ == '__main__':
    """
    SparkSQL 内置数据源：Hive，从其中加载load数据，和保存数据save。  
    """

    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取会话实例对象-session
    spark = SparkSession.builder \
        .appName('SparkSession Test') \
        .master('local[2]') \
        .config("spark.sql.warehouse.dir", 'hdfs://node1.itcast.cn:8020/user/hive/warehouse') \
        .config('hive.metastore.uris', 'thrift://node1.itcast.cn:9083') \
        .enableHiveSupport()\
        .getOrCreate()

    # 2. 加载数据源-source
    emp_df = spark.read.format('hive').table('db_hive.emp')
    emp_df.printSchema()
    emp_df.show(n=20, truncate=False)

    # 3. 数据转换处理-transformation

    # 4. 处理结果输出-sink
    emp_df.coalesce(1)\
        .write\
        .format('hive')\
        .mode('append')\
        .saveAsTable('db_hive.emp_v2')

    # 5. 关闭会话实例对象-close
    spark.stop()

```

## III. 分布式SQL引擎

### 1. spark-sql命令行



### 2. Thrift Server服务



### 3. DataGrip JDBC连接



## 拓展内容

### 1. SQL开窗函数



### 2. Top10电影分析升级版

