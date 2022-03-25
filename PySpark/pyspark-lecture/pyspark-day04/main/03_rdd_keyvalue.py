#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    TODO:
    针对Key/Value类型RDD算子使用:
    keys/ values/ mapValues/ collectAsMap
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark rdd_keyvalue").setMaster("local[*]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.parallelize([("spark", 10), ("mapreduce", 3), ("hive", 6), ("flink", 4)], numSlices=2)

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
