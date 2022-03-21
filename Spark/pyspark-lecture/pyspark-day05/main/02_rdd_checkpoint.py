#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time

from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    TODO:
    RDD Checkpoint: 将RDD数据保存倒可以文件系统, 比如HDFS系统
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[*]")
    sc = SparkContext(conf=spark_conf)
    # TODO: 1. 设置checkpoint保存目录
    sc.setCheckpointDir('../datas/ckpt')

    # 2. 加载数据源-source
    input_rdd = sc.textFile('../datas/words.txt', minPartitions=2)

    # TODO: 2. 将RDD进行checkpoint
    input_rdd.checkpoint()
    input_rdd.count()

    # TODO: 当RDD进行checkpoint以后, 再次使用RDD数据时, 直接从Cheackpoint读取数据
    print(input_rdd.count())

    # 3. 数据转换处理-transformation

    # 4. 处理结果输出-sink
    time.sleep(10)

    # 5. 关闭上下文对象-close
    sc.stop()
