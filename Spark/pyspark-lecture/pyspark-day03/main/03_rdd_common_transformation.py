#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    RDD常用转换算子使用示例:
    map, filter, flatMap
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("rdd_common_transformation").setMaster("local[2]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    # 并行化方式创建RDD
    input_rdd = sc.parallelize([1, 2, 3, 4, 5])

    # 3. 数据转换处理-transformation
    # TODO: map算子, 对集合中每条数据进行处理, 按照规定逻辑处理
    map_rdd = input_rdd.map(lambda item: item * item)
    print(map_rdd.collect())

    # TODO: filter算子, 对集合中每条数据进行过滤, 返回值为true保存, 否则删除
    filter_rdd = input_rdd.filter(lambda item: item % 2 == 1)
    print(filter_rdd.collect())

    # TODO: flatMap算子, 对集合中每条数据进行处理, 类似map算子, 但是要求处理每条数据结果为为集合, 将自动将集合数据扁平化(单行转多行explode)
    rdd = sc.parallelize(['爱情 / 犯罪', '剧情 / 灾难 / 动作'])
    flat_rdd = rdd.flatMap(lambda item: str(item).split(' / '))
    flat_rdd.foreach(lambda item: print(item))
    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
