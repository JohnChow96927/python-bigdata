#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    TODO:
    RDD 中调整分区数目算子：repartition和coalesce案例演示
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
    input_rdd = sc.textFile('../datas/words.txt', minPartitions=2)
    print("raw number of partitions: ", input_rdd.getNumPartitions())

    # 3. 数据转换处理-transformation
    # TODO: repartition算子, 增加分区数目, 使用repartition重新分区会产生shuffle降低性能, 故减少不推荐使用repartition, 推荐使用coalesce
    rdd_1 = input_rdd.repartition(4)
    print("increase: ", rdd_1.getNumPartitions())

    # TODO: coalesce算子, 减少分区数目, 不会产生shuffle
    rdd_2 = input_rdd.coalesce(1)
    print("decrease:", rdd_2.getNumPartitions())

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
