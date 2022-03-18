#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    RDD 中数据排序算子：sortBy、sortByKey、top、takeOrdered案例演示   
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
        [("spark", 10), ("mapreduce", 3), ("hive", 6), ("flink", 4), ("python", 5)],
        numSlices=2
    )

    # 3. 数据转换处理-transformation
    # TODO： sortBy算子，按照词频进行降序排序，每个分区内数据排序，并不是全局
    rdd_1 = input_rdd.sortBy(keyfunc=lambda tuple: tuple[1], ascending=False)
    rdd_1.foreach(lambda item: print(item))

    # TODO: sortByKey 算子，按照Key进行排序，可以指定排序规则
    rdd_2 = input_rdd.map(lambda tuple: (tuple[1], tuple[0])).sortByKey(ascending=False)
    rdd_2.foreach(lambda item: print(item))

    rdd = sc.parallelize([34, 87, 1, -98, 36, 83, 100], numSlices=2)

    # TODO： top算子，获取集合中最大前N个数据
    top_list = rdd.top(3)
    print(top_list)

    # TODO: takeOrdered 算子，获取集合中最小前N个数据
    bottom_list = rdd.takeOrdered(3)
    print(bottom_list)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
