# RDD Operations & Shared Variables

## I. 网站统计分析

### 1. 业务需求分析

> 大数据最早应用场景：离线分析处理网站海量用户行为日志数据，其中 **友盟+**公司开发一系列产品，方便统计分析网站数据。==友盟+== 网站：https://www.umeng.com/

![1632493433597](assets/1632493433597.png)

> 从上述图中可以看出，网站统计分析基本指标：`PV、UV、IP`，具体含义如下所示：

- 第一、**PV（page view）**即==页面浏览量==或==点击量==
  - **用户每1次对网站中的每个网页访问均被记录1个PV**，用户对同一页面的多次访问，访问量累计，用以衡量网站用户访问的网页数量；

- 第二、**UV（unique visitor）**即==唯一访客数==
  - 指通过互联网访问、浏览这个网页的自然人。
  - 访问您网站的一台电脑客户端为一个访客，00:00-24:00内相同的客户端只被计算一次。
  - **一天内同个访客多次访问仅计算一个UV。**

- 第三、**IP（Internet Protocol）**即==独立IP==
  - **指访问过某站点的IP总数，以用户的IP地址作为统计依据**，00:00-24:00内相同IP地址之被计算一次。
  - **UV与IP区别**：你和你的家人用各自的账号在同一台电脑上登录新浪微博，则IP数+1，UV数+2。由于使用的是同一台电脑，所以IP不变，但使用的不同账号，所以UV+2。

> 以阿里巴巴移动电商平台的**真实用户-商品行为数据**为基础，进行基本网站指标分析统计：PV、UV等。

- 业务数据：用户浏览网页数据记录日志

![](assets/782100-20160323100814386-2109502521.png)

- 字段含义：

![1632515190715](assets/1632515190715.png)

- 业务需求及分析说明

![1639039029609](assets/1639039029609.png)

> 编写PySpark代码，加载用户日志数据，封装为RDD，进行解析，统计每日PV和UV。

![1641978727100](assets/1641978727100.png)

### 2. 加载日志数据

> 编写代码 `09_web_analysis.py`：从本地文件系统加载日志数据，解析每条数据，封装元组中。

![1641978963209](assets/1641978963209.png)

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext


if __name__ == '__main__':
    """
    基于阿里提供用户行为日志数据，使用Spark RDD进行基本指标统计分析：pv和uv   
    """

    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[4]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.textFile('../datas/tianchi_user.csv', minPartitions=4)
    # print(input_rdd.first())
    # print("count:", input_rdd.count())
    """
    98047837,232431562,1,,4245,2014-12-06 02
    count: 1048575
    """

    # 3. 数据转换处理-transformation
    """
        3-1. 过滤脏数据，解析数据，每条数据封装到元组中
        3-2. pv统计
        3-3. uv统计
    """
    # 3-1. 过滤脏数据，解析数据，每条数据封装到元组中
    """
    对原始日志数据进行ETL转换操作，包括过滤、解析和转换
        数据格式：98047837,232431562,1,,4245,2014-12-06 02
    """
    parse_rdd = input_rdd\
        .map(lambda line: str(line).split(',')) \
        .filter(lambda line: len(str(line).split(',')) == 6) \
        .map(lambda list: (
            list[0], list[1], int(list[2]), list[3], list[4], list[5], str(list[5])[0:10]
        ))
    print("count:", parse_rdd.count())
    print(parse_rdd.first())
    """
        ('98047837', '232431562', 1, '', '4245', '2014-12-06 02', '2014-12-06')
    """

    # 3-2. pv统计
    

    # 3-3. uv统计
    

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()

```

### 3. 每日PV统计

> **需求一**：每日PV统计，使用字段【time】，获取访问日期。

![1632517379042](assets/1632517379042.png)

```python
# 3-2. pv统计
"""
    ('2014-12-06', 1)
    ('2014-12-06', 1)       ->  reduceByKey
    ('2014-12-06', 1)
    ----------------------------
    解析数据  -map->  ('2014-12-06', 1) -reduceByKey-> ('2014-12-06', 988777) ->coalesce降低RDD分区数目为1 ->sortBy降序排序
    ......
"""
pv_rdd = parse_rdd\
    .map(lambda tuple: (tuple[6], 1))\
    .reduceByKey(lambda tmp, item: tmp + item)\
    .coalesce(1)\
    .sortBy(lambda tuple: tuple[1], ascending=False)
# pv_rdd.foreach(lambda item: print(item))
```

![1641979426809](assets/1641979426809.png)

运行程序，输出结果如下：

```ini
('2014-12-12', 59327)
('2014-12-11', 41727)
('2014-12-10', 35835)
('2014-12-03', 34896)
('2014-11-30', 34824)
('2014-12-13', 34801)
('2014-12-14', 34656)
('2014-12-02', 34625)
('2014-12-07', 34400)
('2014-12-04', 34286)
('2014-12-15', 34208)
('2014-12-16', 34077)
('2014-12-09', 33731)
('2014-12-01', 33658)
('2014-12-06', 33119)
('2014-12-17', 33038)
('2014-12-08', 32719)
('2014-11-23', 32458)
('2014-11-24', 32292)
('2014-11-29', 31685)
('2014-11-18', 31581)
('2014-11-25', 31510)
('2014-12-05', 31370)
('2014-11-27', 31338)
('2014-12-18', 31318)
('2014-11-22', 31283)
('2014-11-26', 30792)
('2014-11-20', 30598)
('2014-11-19', 30567)
('2014-11-28', 29817)
('2014-11-21', 28039)
```

### 4. 每日UV统计

> **需求二**：每日UV统计，使用字段【`user_id`】和【`time`】，获取用户ID和访问日期。

![1632518517938](assets/1632518517938.png)

```python
# 3-3. uv统计
"""
    ('98047837', '232431562', 1, '', '4245', '2014-12-06 02', '2014-12-06')
    a. 提取字段： map
        ('2014-12-06', '98047837')
        ('2014-12-06', '98047837')
        ('2014-12-06', '98047837')
        ('2014-12-06', '96610296')
        ('2014-12-06', '96610296')
    b. 去重: distinct
        ('2014-12-06', '98047837')
        ('2014-12-06', '96610296')
    c. 转换数据: map
        ('2014-12-06', 1)
        ('2014-12-06', 1)
    d. 分组聚合，每日uv: reduceByKey
        ('2014-12-06', 2)
    e. 按照uv降序排序: sortBy
"""
uv_rdd = parse_rdd\
    .map(lambda tuple: (tuple[6], tuple[0]))\
    .distinct()\
    .map(lambda tuple: (tuple[0], 1))\
    .reduceByKey(lambda tmp, item: tmp + item)\
    .coalesce(1)\
    .sortBy(lambda tuple: tuple[1], ascending=False)
uv_rdd.foreach(lambda item: print(item))
```

![1641979888703](assets/1641979888703.png)

运行程序，输出结果如下：

```ini
('2014-12-12', 5693)
('2014-12-11', 4912)
('2014-12-13', 4624)
('2014-12-15', 4615)
('2014-12-16', 4613)
('2014-12-10', 4559)
('2014-12-03', 4558)
('2014-12-14', 4525)
('2014-12-17', 4511)
('2014-12-02', 4497)
('2014-12-08', 4483)
('2014-12-09', 4472)
('2014-12-04', 4458)
('2014-12-07', 4437)
('2014-12-01', 4421)
('2014-12-18', 4399)
('2014-11-24', 4391)
('2014-11-30', 4385)
('2014-12-06', 4373)
('2014-11-23', 4317)
('2014-11-19', 4301)
('2014-11-25', 4298)
('2014-12-05', 4295)
('2014-11-18', 4283)
('2014-11-20', 4276)
('2014-11-26', 4275)
('2014-11-27', 4262)
('2014-11-29', 4235)
('2014-11-21', 4144)
('2014-11-28', 4138)
('2014-11-22', 4122)
```

## II. RDD算子

### 1. reduce聚合原理

> 调用RDD中触发函数（算子）：`reduce`，对集合RDD中元素进行聚合操作，分为2步聚合：
>
> - 第一步、**局部聚合**操作，[RDD中各个分区数据聚合]()
> - 第二步、**全局聚合**操作，[将RDD各个分区聚合结果再次聚合]()

![1639042202924](assets/1639042202924.png)

> 案例代码演示 `01_rdd_reduce_principle`：RDD中reduce算子聚合原理。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext, TaskContext

if __name__ == '__main__':
    """
    RDD 中reduce 聚合算子原理：局部聚合和全局聚合   
    """

    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[1]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.parallelize([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], numSlices=2)
    input_rdd.foreach(lambda item: print('p-', TaskContext().partitionId(), ': item = ', item, sep=''))

    # 3. 数据转换处理-transformation
    # input_rdd.reduce(lambda tmp, item: tmp + item)

    def reduce_func(tmp, item):
        print('p-', TaskContext().partitionId(), ': tmp = ', tmp , ', item = ', item,  sep='')
        return tmp + item

    reduce_value = input_rdd.reduce(reduce_func)
    print(reduce_value)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()

```

![](assets/image-20210422162324117.png)

### 2. 数据聚合算子

> 在RDD中除了讲解`reduce`函数聚合外，还有`fold`和`aggregate`算子，也是对RDD中数据聚合，更加灵活。

- 算子：`reduce`

![1639102589084](assets/1639102589084.png)

**示意图**：对数值类型RDD中数据求和。

![1642057419383](assets/1642057419383.png)

- 算子：`fold`，[比reduce算子，多一个参数，可以设置聚合时中间临时变量的初始值]()

![1639102642537](assets/1639102642537.png)

**示意图**：对数值类型RDD中数据求和。

![1642057441449](assets/1642057441449.png)

- 算子：`aggregate`，[比如fold多一个参数，分别设置RDD数据集合时局部聚合函数和全局聚合函数]()

![1639102685705](assets/1639102685705.png)

**示意图**：对数值类型RDD中数据求和。

![1642057460503](assets/1642057460503.png)

> 案例代码演示 `02_rdd_agg.py`：分别使用reduce、fold和aggregate函数对RDD数据求和。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext, TaskContext

if __name__ == '__main__':
    """
    RDD中三个数据聚合算子：reduce、fold和aggregate案例演示   
    """

    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[2]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.parallelize([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], numSlices=2)

    # 3. 数据转换处理-transformation
    # TODO： reduce 算子
    reduce_value = input_rdd.reduce(lambda tmp, item: tmp + item)
    print("reduceValue:", reduce_value)

    # TODO: fold 算子，需要指定聚合时临时变量初始值
    fold_value = input_rdd.fold(0, lambda tmp, item: tmp + item)
    print("foldValue:", fold_value)

    # TODO: aggregate 算子，先指定聚合临时变量初始值、分区数据聚合函数和分区间数据聚合函数
    agg_value = input_rdd.aggregate(0, lambda tmp, item: tmp + item, lambda tmp, item: tmp + item)
    print("aggValue:", agg_value)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()

```

### 3. Key/Value类型算子

> 在Spark数据处理分析中，往往数据类型为==Key/Value对（二元组）==，RDD中提供很多转换算子和触发算子，方便数据转换操作，常用算子：`keys/values、mapValues、collectAsMap`。

![1639104487032](assets/1639104487032.png)

- 算子：`keys/values`，获取RDD中所有key或者所有value。

![1639103812035](assets/1639103812035.png)

![1639103827306](assets/1639103827306.png)

- 算子：`mapValues`，对RDD中每个元素value值进行转换操作

![1639103875827](assets/1639103875827.png)

- 算子：`collectAsMap`，将RDD数据存储为Map字典

![1639103915360](assets/1639103915360.png)

> 案例代码演示 `03_rdd_keyvalue.py`：KeyValue类型RDD中常用算子使用。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    针对KeyValue类型RDD算子使用：keys/values/mapValues/collectAsMap   
    """

    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[2]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.parallelize(
        [("spark", 10), ("mapreduce", 3), ("hive", 6), ("flink", 4)],
        numSlices=2
    )

    # 3. 数据转换处理-transformation
    # TODO: keys 算子，转换算子，返回值RDD
    key_rdd = input_rdd.keys()
    print(key_rdd.collect())

    # TODO: values 算子
    value_rdd = input_rdd.values()
    print(value_rdd.collect())

    # TODO: mapValues算子，表示对Value值进行处理
    map_rdd = input_rdd.mapValues(lambda value: value * value)
    print(map_rdd.collect())

    # TODO: collectAsMap，将RDD转换为字典Dic
    dic = input_rdd.collectAsMap()
    print(dic.items())

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()

```

### 4. Join关联算子

> 在Hive中分析数据，往往需要将2个表数据，依据某个字段进行关联JOIN。

```SQL
-- HiveSQL 表关联JOIN
	SELECT a.*, b.* FROM a JOIN b ON a.x1 = b.y1  ;
```

> 当两个RDD的数据类型为**二元组Key/Value**对时，可以==依据Key进行关联Join==。

![1639105567065](assets/1639105567065.png)

> RDD中关联JOIN函数：**等值JOIN、左外JOIN、右外JOIN和全外JOIN**

![1632353514512](assets/1632353514512.png)

> 案例代码演示 `04_rdd_join.py`：对类型为KeyValue的RDD，按照Key进行关联连接。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    针对KeyValue类型RDD，依据Key将2个RDD进行关联JOIN，等值JOIN   
    """

    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[2]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    emp_rdd = sc.parallelize(
        [(1001, "zhangsan"), (1002, "lisi"), (1003, "wangwu"), (1004, "zhaoliu")]
    )
    dept_rdd = sc.parallelize(
        [(1001, "sales"), (1002, "tech")]
    )

    # 3. 数据转换处理-transformation
    join_rdd = emp_rdd.join(dept_rdd)
    join_rdd.foreach(lambda item: print(item))

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()

```

### 5. 分区处理算子

每个RDD由多分区组成的，实际开发建议对每个分区数据的进行操作，`map函数使用mapPartitions代替`、`foreach函数使用foreachPartition代替`。

> **场景一**：分析网站日志流量数据，封装到RDD中，需要**解析每条日志数据中IP地址为省份**，使用第三方提供库Ip2Region（==先创建DbSearch对象，再解析IP地址==），使用map算子示意图如下：

![1642037997167](assets/1642037997167.png)

上述伪代码可以发现，**每条数据中IP地址解析为省份时，都需要创建DBSearch对象，如果几十亿条数据，就需要创建几十亿个对象，严重浪费内存**。

[由于RDD是多个分区组成的，可以每个分区数据处理时，创建一个对象，节省内存开销，示意图如下：]()

![1642038196724](assets/1642038196724.png)

上述伪代码中，使用`RDD#mapPartitions`算子代替`RDD#map`算子，处理每个分区数据，减少对象创建。

> **场景二**：将词频统计WordCount**结果数据RDD，保存到MySQL数据库表**中，使用foreach算子时，==每条数据保存时，都需要创建连接和关闭连接==，示意图如下：

![1642039011464](assets/1642039011464.png)

上述伪代码，可以看出：RDD中每条数据保存都需要获取数据库连接和关闭连接，如果是几百条数据，需要几百次反复获取连接和关闭，影响数据库性能和保存时效率（获取连接需要时间）。

[在RDD算子中，提供针对分区输出算子：`foreachPartition`，与`mapPartitions`算子类似，操作分区中数据，每个分区数据创建数据库连接和关闭连接，节省内存开销和降低对数据库性能影响。]()

![1642038733812](assets/1642038733812.png)

> 接下来，首先看一看map算子和mapPartitions算子，函数声明：

- `map` 算子：传递函数类型参数**f**，声明为：`f: (T) -> U`，[接收一个参数，返回一个值]()。

![1639106093536](assets/1639106093536.png)

示意图：

![1639106941824](assets/1639106941824.png)

- `mapPartitions` 算子：传递函数类型的参数==f==，声明为：`f: (Iterable[T]) -> Iterable[U]`，[接收一个迭代器类型参数，返回值也是迭代器。]()

![1639106117038](assets/1639106117038.png)

示意图：

![1639107214548](assets/1639107214548.png)

> 案例代码演示 `05_rdd_iter.py`：对RDD数据分别使用map和MapPartitions算子进行转换处理。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    RDD中提供专门针对分区操作处理算子：mapPartitions和foreachPartition案例演示    
    """

    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[2]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.parallelize(list(range(1, 11)), numSlices=2)

    # 3. 数据转换处理-transformation
    # TODO：map 算子，表示对集合中每条数据进行调用处理
    rdd_1 = input_rdd.map(lambda item: item * item)
    print(rdd_1.collect())

    # TODO: mapPartitions 算子，表示对RDD集合中每个分区数据处理，可以认为时每个分区数据放在集合中，然后调用函数处理
    def func(iter):
        for item in iter:
            yield item * item
    rdd_2 = input_rdd.mapPartitions(func)
    print(rdd_2.collect())

    # TODO：foreachPartition 算子，表示对RDD集合中每个分区数据输出
    def for_func(iter):
        for item in iter:
            print(item)
    input_rdd.foreachPartition(for_func)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()

```

## III. SogouQ日志分析

### 1. 业务需求分析

> 基于搜狗实验室提供【**用户查询日志(SogouQ)**】数据，使用Spark框架，将数据封装到RDD中进行业务数据处理分析。

- 1）、数据介绍：

> 搜索引擎查询日志库设计为包括约1个月(2008年6月)Sogou搜索引擎部分网页查询需求及用户点击情况的网页查询日志数据集合。数据网址：http://www.sogou.com/labs/resource/q.php

- 2）、数据格式

```ini
访问时间\t用户ID\t[查询词]\t该URL在返回结果中的排名\t用户点击的顺序号\t用户点击的URL
```

![1632523810278](assets/1632523810278.png)

- 3）、数据下载：分为三个数据集，大小不一样

```ini
    # 迷你版(样例数据, 376KB)：
        http://download.labs.sogou.com/dl/sogoulabdown/SogouQ/SogouQ.mini.zip

    # 精简版(1天数据，63MB)：
        http://download.labs.sogou.com/dl/sogoulabdown/SogouQ/SogouQ.reduced.zip

    # 完整版(1.9GB)：
        http://www.sogou.com/labs/resource/ftp.php?dir=/Data/SogouQ/SogouQ.zip
```

> 针对SougouQ查询日志数据，分析业务需求：

![1632523888485](assets/1632523888485.png)

> 编写实现，按照数仓分层方式管理数据，加载原数据，进行转换处理，最后实现业务需求。

![1642046869211](assets/1642046869211.png)

### 2. Jieba中文分词

> [jieba](https://github.com/fxsjy/jieba) 是目前最好的 Python 中文分词组件，首先安装jieba分词库，命令：`pip install jieba`，再使用库对中文语句进行分词。官方网站：<https://github.com/fxsjy/jieba>

![1632524761819](assets/1632524761819.png)

[Jieba分词库，支持 3 种分词模式：精确模式、全模式、搜索引擎模式。]()

> 案例代码演示 `test_jieba.py`：使用jieba分词库，对中文分词，采用不同模式。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import jieba

if __name__ == '__main__':
    """
    Jieba中文分词使用   
    """

    # 定义一个字符串
    line = '我来到北京清华大学'

    # TODO：全模式分词
    seg_list = jieba.cut(line, cut_all=True)
    print(",".join(seg_list))

    # TODO: 精确模式
    seg_list_2 = jieba.cut(line, cut_all=False)
    print(",".join(seg_list_2))

    # TODO: 搜索引擎模式
    seg_list_3 = jieba.cut_for_search(line)
    print(",".join(seg_list_3))

```

运行结果如下所示：

```ini
# 全模式分词：
	我,来到,北京,清华,清华大学,华大,大学
	
# 精确模式：
	我,来到,北京,清华大学
	
# 搜索引擎模式：
	我,来到,北京,清华,华大,大学,清华大学
```

### 3. 数据加载解析

> 加载搜索日志数据，对每行日志数据解析封装到元组中，方便后续处理分析

```ini
00:00:04	6943214457930995	[秦始皇陵墓]	1 16	www.vekee.com/b51126/
00:00:04	0554004435565833	[青海湖水怪]	3 2	www.mifang.org/do/bs/p55.html
00:00:04	9975666857142764	[电脑创业]	3 3	ks.cn.yahoo.com/question/1407041904210.html
```

> 创建Python文件 `06_sogou_analysis.py`：加载搜索日志数据，对每行数据进行解析。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import re
import jieba
from pyspark import SparkConf, SparkContext


def parse_data(rdd):
    """
    数据格式：
        00:00:00	2982199073774412	[360安全卫士]	8 3	download.it.com.cn/softweb/software/firewall/antivirus/20067/17938.html
        step1、简单过滤脏数据
        step2、解析数据，使用正则 \\s+
        step3、封装到元组中
    """
    output_rdd = rdd\
        .map(lambda line: re.split('\\s+', line))\
        .filter(lambda list: len(list) == 6)\
        .map(lambda list: (
            list[0], list[1], str(list[2])[1:-1], int(list[3]), int(list[4]), list[5]
        ))
    return output_rdd


if __name__ == '__main__':
    """
    Sogou搜索日志统计分析，先加载文件数据，再封装解析，最后依据业务统计。   
    """

       # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[4]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    log_rdd = sc.textFile('../datas/SogouQ.reduced', minPartitions=4)
    # print('count:', log_rdd.count())
    # print(log_rdd.first())

    # 3. 数据转换处理-transformation
    """
        3-1. 解析转换数据
        3-2. 依据业务分析数据
        3-3. 用户搜索点击统计
        3-4. 搜索时间段统计
    """
    # 3-1. 解析转换数据
    sougo_rdd = parse_data(log_rdd)
    # print("count:", sougo_rdd.count())
    print(sougo_rdd.first())

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()


```

> **补充知识点**：[详解 "\\s+"]()

```ini
# 正则表达式中\s匹配任何空白字符，包括空格、制表符、换页符等等, 等价于[ \f\n\r\t\v]
    \f -> 匹配一个换页
    \n -> 匹配一个换行符
    \r -> 匹配一个回车符
    \t -> 匹配一个制表符
    \v -> 匹配一个垂直制表符
而“\s+”则表示匹配任意多个上面的字符。另因为反斜杠在Java里是转义字符，所以在Java里，我们要这么用“\\s+”.

注:
    [\s]表示，只要出现空白就匹配
    [\S]表示，非空白就匹配
```

### 4. 搜索关键词统计

> 获取用户【查询词】，使用Jieba进行分词，按照单词分组聚合统计出现次数，类似WordCount程序，具体代码如下：

- 第一步、获取每条日志数据中【查询词`queryWords`】字段数据
- 第二步、使用Jieba对查询词进行中文分词
- 第三步、按照分词中单词进行词频统计，类似WordCount

> 定义方法 `query_keyword_count`：对每条数据中搜索词进行分词，再分组统计各个搜索关键词次数。

```python
def query_keyword_count(rdd):
    """
    搜索关键词统计：首先对查询词进行中文分词，然后对分词单词进行分组聚合，类似WordCount词频统计
        ('00:00:00', '2982199073774412', '360安全卫士', 8, 3, 'download.it.com.cn/softweb/software/firewall/antivirus/20067/17938.html')
        TODO:
            WITH tmp AS (
                SELECT explode(split_search(search_words)) AS keyword FROM tbl_logs
            )
            SELECT keyword, COUNT(1) AS total FROM tmp GROUP BY keyword
    """
    output_rdd = rdd\
        .flatMap(lambda tuple: list(jieba.cut(tuple[2], cut_all=False)))\
        .map(lambda keyword: (keyword, 1))\
        .reduceByKey(lambda tmp, item: tmp + item)
    return output_rdd

```

main方法中添加代码：

```python
    # 3-2. 搜索关键词统计
    query_keyword_rdd = query_keyword_count(sougo_rdd)
    top_10_keyword = query_keyword_rdd.top(10, key=lambda tuple: tuple[1])
    print(top_10_keyword)
```

运行程序结果：

```ini
[('+', 1442), ('地震', 605), ('.', 575), ('的', 492), ('汶川', 430), ('原因', 360), ('哄抢', 321), ('救灾物资', 321), ('com', 278), ('图片', 260)]
```

### 5. 用户搜索点击统计

> 统计出==每个用户每个搜索词点击网页的次数==，可以作为搜索引擎搜索效果评价指标。[先按照用户ID分组，再按照【查询词】分组，最后统计次数，求取最大次数、最小次数及平均次数。]()

定义方法 `query_click_count`：实现各个用户搜索点击统计，代码如下：

```python
def query_click_count(rdd):
    """
    用户搜索点击统计：先按照用户id分组，再按照搜索词分组，聚合操作
        ((u1001, x1), 4)
        ((u1002, x2), 5)
        TODO:
            SELECT user_id, search_words, COUNT(1) AS total FROM tbl_logs GROUP user_id, search_words
    """
    output_rdd = rdd\
        .map(lambda tuple: ((tuple[1], tuple[2]), 1))\
        .reduceByKey(lambda tmp, item: tmp + item)
    return output_rdd
```

> 获取计算结果RDD后，对其中值求取max、min和mean值。

```python
    # 3-3. 用户搜索点击统计
    query_click_rdd = query_click_count(sogou_rdd)
    # print(query_click_rdd.take(10))
    """
        计算每个用户的每个搜索词点击次数平均值、最小值和最大值
    """
    click_total_rdd = query_click_rdd.map(lambda tuple: tuple[1])
    click_total_rdd.persist(StorageLevel.MEMORY_AND_DISK)
    print("max:", click_total_rdd.max())
    print("min:", click_total_rdd.min())
    print("mean:", click_total_rdd.mean())
    click_total_rdd.unpersist()
```

运行程序结果：

```ini
max click count: 274
min click count: 1
avg click count: 2.0963357823142448
```

### 6. 搜索时间段统计

> 按照==【访问时间】==字段获取**【小时】**，分组**统计各个小时段用户查询搜索的数**量，进一步观察用户喜欢在哪些时间段上网，使用搜狗引擎搜索。

定义方法 `query_hour_count`：实现各个用户搜索点击统计，代码如下：

```python
def query_hour_count(rdd):
    """
    各个时间段用户使用搜狗搜索引擎使用量
        TODO:
            WITH tmp AS (
                SELECT substring(access_time, 0, 2) AS hour_str FROM tbl_logs
            )
            SELECT hour_str, COUNT(1) AS total FROM tmp GROUP BY hour_str ORDER BY total DESC
    """
    output_rdd = rdd\
        .map(lambda tuple: tuple[0])\
        .map(lambda time_str: time_str[0:2])\
        .map(lambda hour_str: (hour_str, 1))\
        .reduceByKey(lambda tmp, item: tmp + item)\
        .coalesce(1)\
        .sortBy(keyfunc=lambda tuple: tuple[1], ascending=False)
    return output_rdd
```

main方法中添加代码：

```python
    # 3-4. 搜索时间段统计
    query_hour_rdd = query_hour_count(sogou_rdd)
    query_hour_rdd.foreach(lambda item: print(item))
```

运行程序结果：

```ini
('16', 116540)
('21', 115126)
('20', 110863)
('15', 109086)
('10', 104694)
('17', 104639)
('14', 101295)
('22', 99977)
('11', 97991)
('19', 97129)
('13', 94970)
('18', 91697)
('12', 88140)
('09', 86079)
('23', 65879)
('08', 55966)
('00', 51735)
('01', 30476)
('07', 28854)
('02', 19775)
('06', 16692)
('03', 13191)
('05', 10822)
('04', 10092)
```

