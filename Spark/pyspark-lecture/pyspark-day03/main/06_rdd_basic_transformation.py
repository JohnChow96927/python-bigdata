#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    RDD 中基本转换算子：union、distinct、groupByKey和reduceByKey案例演示   
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
    rdd_1 = sc.parallelize([1, 2, 3, 4, 5, 6, 7, 8], numSlices=2)
    rdd_2 = sc.parallelize([6, 7, 8, 9], numSlices=2)

    # 3. 数据转换处理-transformation
    # TODO: union算子，将2个数据类型相同的RDD进行合并，不去重，类似SQL中 union all
    union_rdd = rdd_1.union(rdd_2)
    print(union_rdd.collect())

    # TODO: distinct 算子，对RDD集合中数据进行去重，类似SQL中distinct
    distinct_rdd = union_rdd.distinct()
    print(distinct_rdd.collect())

    rdd_3 = sc.parallelize([
            ("北京", 20), ("上海", 15), ("北京", 30), ("上海", 25), ("北京", 50), ("深圳", 90)
    ])

    # TODO: groupByKey 算子，将集合中数据，按照Key分组，相同key的value放在集合中
    group_rdd = rdd_3.groupByKey()
    group_rdd.foreach(lambda tuple: print(tuple[0], list(tuple[1])))
    """
    深圳 -> [90]
    北京 -> [20, 30, 50]
    上海 -> [15, 25]
    """

    # TODO: reduceByKey 算子，将集合中数据，先按照Key分组，再使用定义reduce函数进行组内聚合
    reduce_rdd = rdd_3.reduceByKey(lambda tmp, item: tmp + item)
    reduce_rdd.foreach(lambda item: print(item))
    """
    ('深圳', 90)
    ('北京', 100)
    ('上海', 40)
    """

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
