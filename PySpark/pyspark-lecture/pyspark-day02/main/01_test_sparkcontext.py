#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time
from pyspark import SparkContext, SparkConf

if __name__ == '__main__':
    """
    Spark程序入口：SparkContext对象创建
    """

    # TODO：设置系统环境变量
    os.environ['JAVA_HOME'] = 'C:/Java/jdk1.8.0_241'
    os.environ['HADOOP_HOME'] = 'C:/Hadoop/hadoop-3.3.0'
    os.environ['PYSPARK_PYTHON'] = 'C:/Users/JohnChow/anaconda3/python.exe'
    os.environ['PYSPARK_DRIVER_PYTHON'] = 'C:/Users/JohnChow/anaconda3/python.exe'

    # 创建SparkConf实例，设置应用属性，比如名称和master
    spark_conf = SparkConf().setAppName("SparkContext Test").setMaster("local[2]")

    # 创建SparkContext对象，传递SparkConf实例
    sc = SparkContext(conf=spark_conf)
    print(sc)

    time.sleep(100000)
    # 关闭资源
    sc.stop()
