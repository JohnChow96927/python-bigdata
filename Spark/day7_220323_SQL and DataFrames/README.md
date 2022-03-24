# SQL and DataFrames

## I. SparkSQL数据分析

### 1. SQL分析

> 基于SQL数据分析，将DataFrame注册为临时视图，编写SQL执行分析，分为两个步骤：

- **第一步、注册为临时视图**：`df.createOrReplaceTempView(view_name)`

![1632748271537](assets/1632748271537-1648106749522.png)

- **第二步、编写SQL，执行分析**：`df = spark.sql()`

![1632748231127](assets/1632748231127-1648106747296.png)

> 其中SQL语句类似Hive中SQL语句，查看Hive官方文档，SQL查询分析语句语法

![1632748620717](assets/1632748620717-1648106744934.png)

官方文档：https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Select

> **Iris 鸢尾花数据**集是一个经典数据集，在统计学习和机器学习领域都经常被用作示例。**数据集内包含 3 类共 150 条记录，每类各 50 个数据**，每条记录都有 4 项特征：==花萼（sepals）长度和宽度、花瓣（petals）长度和宽度==，可通过4个特征预测鸢尾花卉属于（**iris-setosa、iris-versicolour、iris-virginica**）中的哪一品种。

![img](assets/v2-4764beb445a0132d4fa220239c28c6b0_720w-1648106738284.jpg)

> [数据下载：http://archive.ics.uci.edu/ml/datasets/Iris]()

![img](assets/6533825-61d6b7f8b885ee5f-1648106734150.webp)

> **案例代码演示**： `01_dataframe_sql.py`：注册DataFrame为临时视图，编写SQL分析数据。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession

if __name__ == '__main__':
    """
    加载鸢尾花数据集，使用SQL分析，基本聚合统计操作
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
    iris_rdd = spark.sparkContext.textFile('../datas/iris/iris.data')

    # 3. 数据转换处理-transformation
    """
        采用toDF函数方式，转换RDD为DataFrame，此时要求RDD中数据类型：元组Tuple
    """
    tuple_rdd = iris_rdd\
        .map(lambda line: str(line).split(','))\
        .map(lambda list: (float(list[0]), float(list[1]), float(list[2]), float(list[3]), list[4]))
    # 调用toDF函数，指定列名称
    iris_df = tuple_rdd.toDF(['sepal_length', 'sepal_width', 'petal_length', 'petal_width', 'category'])
    # iris_df.printSchema()
    # iris_df.show(n=10, truncate=False)

    # 第1步、注册DataFrame为临时视图
    iris_df.createOrReplaceTempView('view_tmp_iris')
    # 第2步、编写SQL语句并执行
    result_df = spark.sql("""
        SELECT   
          category,
          COUNT(1) AS total,
          ROUND(AVG(sepal_length), 2) AS sepal_length_avg,
          ROUND(AVG(sepal_width), 2) AS sepal_width_avg,
          ROUND(AVG(petal_length), 2) AS petal_length_avg,
          ROUND(AVG(petal_width), 2) AS petal_width_avg
        FROM view_tmp_iris GROUP BY category
    """)

    # 4. 处理结果输出-sink
    result_df.printSchema()
    result_df.show()

    # 5. 关闭会话实例对象-close
    spark.stop()

```

程序运行结果：

![1632754797497](assets/1632754797497-1648106726399.png)

### 2. DSL分析之API函数

> 调用==DataFrame API（函数）==分析数据，其中函数包含**RDD 函数**和类似**SQL函数**。

- 第一、**类似RDD 算子**，比如count、cache、foreach、collect等，但是**没有map和mapPartitions算子**

![1639748046534](E:/Heima/%E5%B0%B1%E4%B8%9A%E7%8F%AD%E6%95%99%E5%B8%88%E5%86%85%E5%AE%B9%EF%BC%88%E6%AF%8F%E6%97%A5%E6%9B%B4%E6%96%B0%EF%BC%89/PySpark/%E9%A2%84%E4%B9%A0%E8%B5%84%E6%96%99/pyspark_day07_20220324/03_%E7%AC%94%E8%AE%B0/assets/1639748046534.png)

[其中，可以从DataFrame数据集中获取列名称：`columns`、Schema信息：`schema`和RDD数据：`rdd`]()

> DataFrame中函数使用演示，说明如下：

- 第一、在PyCharm中开发，方便查看函数的使用说明
- 第二、启动`pyspark shell` 命令行，即使执行命令，查看结果

```bash
(base) [root@node1 ~]# /export/server/spark-local/bin/pyspark \
--master local[2] \
--conf spark.sql.shuffle.partitions=2
```

> **案例代码演示**： `02_dataframe_dsl.py`：加载json格式数据，调用类似RDD算子函数。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession
from pyspark import StorageLevel

if __name__ == '__main__':
    """
    加载JSON格式数据，封装到DataFrame中，使用DataFrame API进行操作（类似RDD 算子）  
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
    emp_df = spark.read.json('hdfs://node1.itcast.cn:8020/datas/resources/employees.json')
    emp_df.printSchema()
    emp_df.show(n=10, truncate=False)

    # 3. 数据转换处理-transformation
    # TODO：count/collect/take/first/head/tail/
    emp_df.count()
    emp_df.collect()
    emp_df.take(2)
    emp_df.head()
    emp_df.first()
    emp_df.tail(2)

    # TODO: foreach/foreachPartition
    emp_df.foreach(lambda row: print(row))

    # TODO：coalesce/repartition
    emp_df.rdd.getNumPartitions()
    emp_df.coalesce(1).rdd.getNumPartitions()
    emp_df.repartition(3).rdd.getNumPartitions()

    # TODO：cache/persist
    emp_df.cache()
    emp_df.unpersist()
    emp_df.persist(storageLevel=StorageLevel.MEMORY_AND_DISK)

    # TODO: columns/schema/rdd/printSchema
    emp_df.columns
    emp_df.schema
    emp_df.printSchema()

    # 5. 关闭会话实例对象-close
    spark.stop()

```

### 3. DSL分析之SQL函数

> 调用==DataFrame API（函数）==分析数据，其中函数包含**RDD 函数**和类似**SQL函数**。

- **第二、类似SQL函数算子**，比如select、groupBy、orderBy、limit等等

![1639755502199](assets/1639755502199-1648107416525.png)

```python
# 1、选择函数select：选取某些列的值
	def select(self, *cols: Union[Column, str]) -> DataFrame
	
# 2、过滤函数filter/where：设置过滤条件，类似SQL中WHERE语句
	def filter(self, condition: Union[Column, str]) -> DataFrame
	
# 3、分组函数groupBy/rollup/cube：对某些字段分组，在进行聚合统计
	def groupBy(self, *cols: Union[Column, str]) -> GroupedData

# 4、聚合函数agg：通常与分组函数连用，使用一些count、max、sum等聚合函数操作
	def agg(self, *exprs: Union[Column, Dict[str, str]]) -> DataFrame
    
# 5、排序函数sort/orderBy：按照某写列的值进行排序（升序ASC或者降序DESC）
	def sort(self,
         *cols: Union[str, Column, List[Union[str, Column]]],
         ascending: Union[bool, List[bool]] = ...) -> DataFrame

# 6、限制函数limit：获取前几条数据，类似RDD中take函数
	def limit(self, num: int) -> DataFrame
    
# 7、重命名函数withColumnRenamed：将某列的名称重新命名
	def withColumnRenamed(self, existing: str, new: str) -> DataFrame
    
# 8、删除函数drop：删除某些列
	def drop(self, cols: Union[Column, str]) -> DataFrame

# 9、增加列函数withColumn：当某列存在时替换值，不存在时添加此列
	def withColumn(self, colName: str, col: Column) -> DataFrame
```

> ​		上述SQL函数调用时，通常**指定某个列名称，传递`Column`对象**，使用`col`或`column`内置函数，转换String字符串为Column对象。

```python
# 导入库
from pyspark.sql.functions import col, column

# 转换字符串列名称为Column对象
col('name')
column('name')
```

> **案例代码演示**： `03_top10_movies_dsl.py`，调用DataFrame中函数，采用链式编程分析数据。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time
from pyspark.sql import SparkSession
import pyspark.sql.functions as F

if __name__ == '__main__':
    """
    Top10 电影分析（电影评分最高10个，并且每个电影评分人数大于2000）  
    """

    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取会话实例对象-session
    spark = SparkSession.builder \
        .appName('SparkSession Test') \
        .master('local[4]') \
        .config('spark.sql.shuffle.partitions', '4')\
        .getOrCreate()

    # 2. 加载数据源-source
    rating_rdd = spark.sparkContext.textFile("../datas/ml-1m/ratings.dat")
    # print('count:', rating_rdd.count())
    # print(rating_rdd.first())

    # 3. 数据转换处理-transformation
    """
        数据格式：
            1::1193::5::978300760
        转换DataFrame：
            采用toDF函数指定列名称
    """
    # 3-1. 将RDD数据封装转换为DataFrame数据集
    rating_df = rating_rdd\
        .map(lambda line: str(line).split('::'))\
        .map(lambda list: (list[0], list[1], float(list[2]), int(list[3])))\
        .toDF(['user_id', 'item_id', 'rating', 'timestamp'])
    # rating_df.printSchema()
    # rating_df.show(10, truncate=False)

    # 3-2. 基于DSL方式分析数据，调用DataFrame函数（尤其是SQL函数）
    """
        Top10电影：电影评分人数>2000, 电影平均评分降序排序，再按照电影评分人数降序排序
        a. 按照电影进行分组：groupBy
        b. 每个电影数据聚合：agg
            count、avg
        c. 过滤电影评分人数：where/filter
        d. 评分和人数降序排序：orderBy/sortBy
        e. 前10条数据：limit
    """
    top10_movie_df = rating_df\
        .groupBy(F.col('item_id'))\
        .agg(
            F.count(F.col('item_id')).alias('rating_total'),
            F.round(F.avg(F.col('rating')), 2).alias('rating_avg')
        )\
        .where(F.col('rating_total') > 2000)\
        .orderBy(
            F.col('rating_avg').desc(), F.col('rating_total').desc()
        )\
        .limit(10)
    # top10_movie_df.printSchema()
    # top10_movie_df.show(n=10, truncate=False)

    # 3-3. 加载电影基本信息数据
    movie_df = spark.sparkContext \
        .textFile('../datas/ml-1m/movies.dat') \
        .map(lambda line: str(line).split('::')) \
        .toDF(['movie_id', 'title', 'genres'])
    # movie_df.printSchema()
    # movie_df.show(n=10, truncate=False)

    # 3-4. 将Top10电影与电影基本信息数据进行JOIN，采用DSL
    result_df = top10_movie_df\
        .join(
            movie_df,
            on=F.col('item_id')==F.col('movie_id'),
            how='inner'
        )\
        .select(
            F.col('title'), F.col('rating_avg').alias('rating'), F.col('rating_total').alias('total')
        )

    # 4. 处理结果输出-sink
    result_df.printSchema()
    result_df.show(10, truncate=False)

    # 5. 关闭会话实例对象-close
    spark.stop()

```

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

