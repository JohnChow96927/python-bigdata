#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    TODO:
    RDD中数据排序算子：sortBy、sortByKey、top、takeOrdered案例演示
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("rdd_sort").setMaster("local[2]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.parallelize([("spark", 10), ("mapreduce", 3), ("hive", 6), ("flink", 4), ("python", 5)], numSlices=2)
    print("测试用例: ", input_rdd.collect())

    # 3. 数据转换处理-transformation
    # TODO: sortBy算子, 按照词频进行降序排序, 每个分区内数据排序, 并不是全局
    rdd_1 = input_rdd.sortBy(keyfunc=lambda tup: tup[1], ascending=False)
    print("sortBy算子: ")
    rdd_1.foreach(lambda item: print(item))

    # TODO: sortByKey算子, 按照Key进行排序, 可以指定排序规则
    rdd_2 = input_rdd.map(lambda tup: (tup[1], tup[0])).sortByKey(ascending=False)
    print("sortByKey算子: ")
    rdd_2.foreach(lambda item: print(item))

    rdd_3 = sc.parallelize([34, 87, 1, -98, 36, 83, 100], numSlices=2)
    print("测试用例: ", rdd_3.collect())

    # TODO: top算子, 获取集合中最大前N个数据
    top_list = rdd_3.top(3)
    print("最大的前3个数: ", top_list)

    # TODO: takeOrdered算子, 获取集合中最小的前N个数据
    bottom_list = rdd_3.takeOrdered(3)
    print("最小的前3个数: ", bottom_list)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
