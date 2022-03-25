#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    TODO:
    数据聚合算子: reduce, fold和aggregate
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark rdd_agg").setMaster("local[*]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.parallelize(list(range(1, 11)), numSlices=2)

    # 3. 数据转换处理-transformation
    # TODO: reduce算子
    reduce_value = input_rdd.reduce(lambda tmp, item: tmp + item)
    print("reduceValue:", reduce_value)

    # TODO: fold算子, 需要指定聚合时变量初始值
    fold_value = input_rdd.fold(0, lambda tmp, item: tmp + item)
    print("foldValue: ", fold_value)

    # TODO: aggregate算子, 先制定聚合临时变量初始值, 分区数据聚合函数和分区间数据聚合函数
    agg_value = input_rdd.aggregate(0, lambda tmp, item: tmp + item, lambda tmp, item: tmp + item)
    print("aggValue: ", agg_value)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
