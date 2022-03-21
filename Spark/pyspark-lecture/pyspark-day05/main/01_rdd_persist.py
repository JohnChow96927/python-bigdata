#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time

from pyspark import SparkConf, SparkContext, StorageLevel

if __name__ == '__main__':
    """
    TODO:
    RDD数据持久化, 使用persist函数, 指定缓存级别
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[*]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.textFile('../datas/words.txt', minPartitions=2)

    # 3. 数据转换处理-transformation
    # TODO: 可以直接将数据放在内存中, 缺点: 数据量大, 内存大概率放不下
    # input_rdd.cache()
    # input_rdd.persist()

    # TODO: 缓存RDD数据, 指定存储级别, 先放内存, 不足再放磁盘
    input_rdd.persist(storageLevel=StorageLevel.MEMORY_AND_DISK)
    # 使用出发函数触发, 使用count
    input_rdd.count()

    # 当再次使用缓存数据时, 直接从缓存读取
    print(input_rdd.count())

    # TODO: 当缓存RDD数据不再被使用时, 一定记住需要释放资源
    input_rdd.unpersist()

    # 4. 处理结果输出-sink

    time.sleep(10)
    # 5. 关闭上下文对象-close
    sc.stop()
