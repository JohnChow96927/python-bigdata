#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    TODO:
    RDD中累加器Accumulator: 使用累加器处理文件中有多少条数据
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[*]")
    sc = SparkContext(conf=spark_conf)

    # TODO: 1. 定义累加器
    counter = sc.accumulator(0)

    # 2. 加载数据源-source
    input_rdd = sc.textFile('../datas/words.txt', minPartitions=2)

    # 3. 数据转换处理-transformation
    def map_func(line):
        # TODO: 2. 使用累加器
        counter.add(1)
        return line

    output_rdd = input_rdd.map(map_func)

    # 4. 处理结果输出-sink
    print(output_rdd.count())

    # TODO: 3. 获取累加器值
    print("counter = ", counter.value)

    # 5. 关闭上下文对象-close
    sc.stop()
