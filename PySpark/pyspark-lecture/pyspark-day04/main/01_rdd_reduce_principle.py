#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext, TaskContext

if __name__ == '__main__':
    """
    TODO:
    RDD中reduce聚合算子原理: 局部聚合和全局聚合
    """

    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Reduce聚合原理").setMaster("local[*]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.parallelize(list(range(1, 11)), numSlices=2)
    input_rdd.foreach(lambda item: print('p-', TaskContext().partitionId(), ': item = ', item, sep=''))

    # 3. 数据转换处理-transformation
    def reduce_func(tmp, item):
        print('p-', TaskContext().partitionId(), ': tmp = ', tmp , ', item = ', item,  sep='')
        return tmp + item

    reduce_value = input_rdd.reduce(reduce_func)
    print(reduce_value)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
