# RDD Operations & Shared Variables

## I. 网站统计分析

### 1. 业务需求分析



### 2. 加载日志数据



### 3. 每日PV统计



### 4. 每日UV统计

## II. RDD算子

### 1. reduce聚合原理



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
    print("foldValue:", agg_value)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()

```

### 3. KeyValue类型算子



### 4. Join关联算子



### 5. 分区处理算子



## III. SogouQ日志分析

### 1. 业务需求分析



### 2. Jieba中文分词



### 3. 数据加载解析



### 4. 搜索关键词统计



### 5. 用户搜索点击统计



### 6. 搜索时间段统计



