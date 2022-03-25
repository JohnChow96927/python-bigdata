#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    TODO:
    RDD中提供专门针对分区操作处理算子：
    mapPartitions和foreachPartition案例演示
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark rdd_iter").setMaster("local[*]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.parallelize(list(range(1, 11)), numSlices=2)

    # 3. 数据转换处理-transformation
    # TODO: map算子, 表示对集合中每条数据进行调用处理
    rdd_map = input_rdd.map(lambda item: item * item)
    print(rdd_map.collect())

    # TODO: mapPartitions算子, 表示对RDD集合中每个分区数据处理, 可以认为是每个分区数据放在集合中, 然后调用函数处理
    def func_map_partition_iter(iter):
        for item in iter:
            yield item * item


    rdd_map_partitions = input_rdd.mapPartitions(func_map_partition_iter)
    print(rdd_map_partitions.collect())

    # TODO: foreachPartition算子, 表示对RDD集合中每个分区数据输出
    def func_foreach_partition(iter):
        print('============')
        for item in iter:
            print(item)


    input_rdd.foreachPartition(func_foreach_partition)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
