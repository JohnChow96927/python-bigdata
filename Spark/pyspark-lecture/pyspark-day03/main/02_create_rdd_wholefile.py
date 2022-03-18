#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    Spark 中加载小文件数据，使用方法：wholeTextFiles，指定RDD集合分区数目 
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
    # TODO: 指定目录，加载小文件文本数据
    input_rdd = sc.wholeTextFiles('../datas/ratings100', minPartitions=2)

    # 分区数目和条目数
    print("Partitions:", input_rdd.getNumPartitions())
    print("count:", input_rdd.count())

    # 获取第一条数据
    print(input_rdd.first())

    # 3. 数据转换处理-transformation

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
