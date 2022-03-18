#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    TODO:
    常用触发算子:
    count, foreach, saveAsTextFile
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("rdd_common_action").setMaster("local[2]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.parallelize([1, 3, 2, 7, 4, 9, 10, 2, 8], numSlices=2)

    # 3. 数据转换处理-transformation
    # TODO: count算子, 统计集合中元素个数
    print("count: ", input_rdd.count())

    # TODO: foreach算子, 遍历集合中每个元素, 进行输出操作
    input_rdd.foreach(lambda item: print(item))

    # 或者:
    def func_for_foreach(item):
        print(item)


    input_rdd.foreach(func_for_foreach)

    # TODO: saveAsTextFile算子, 将集合数据保存到文本文件, 一个分区数据保存一个文件
    input_rdd.saveAsTextFile('../datas/output_1')

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
