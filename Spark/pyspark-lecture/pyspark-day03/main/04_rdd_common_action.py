#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    RDD中常用触发算子使用：count、foreach、saveAsTextFile案例演示   
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
    # TODO: count 算子，统计集合中元素个数
    print("count:", input_rdd.count())

    # TODO: foreach 算子，遍历集合中每个元素，进行输出操作
    input_rdd.foreach(lambda item: print(item))

    # TODO: saveAsTextFiles 算子，将集合数据保存到文本文件，一个分区数据保存一个文件
    input_rdd.saveAsTextFile('../datas/output')

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
