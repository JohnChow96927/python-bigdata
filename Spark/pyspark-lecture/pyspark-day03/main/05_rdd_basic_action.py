#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    RDD 中基本触发算子：first、take、collect、reduce 案例演示   
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
    # TODO：first 算子， 获取集合中第一条数据
    print("first:", input_rdd.first())

    # TODO: take 算子，获取集合中前N条数据，放在列表中
    take_list = input_rdd.take(3)
    print(take_list)

    # TODO: collect 算子，将集合数据转换为列表，注意数据不能太大，否则内存不足：OOM
    collect_list = input_rdd.collect()
    print(collect_list)

    # TODO: reduce 算子，对集合中数据进行聚合操作，聚合时需要变量存储聚合中间值
    sum = input_rdd.reduce(lambda tmp, item: tmp + item)
    print("sum:", sum)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
