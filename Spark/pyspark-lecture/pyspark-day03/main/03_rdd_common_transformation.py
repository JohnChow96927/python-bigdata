#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    RDD中最常用三个转换算子：map、filter、flatMap使用案例演示   
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
    # 并行化方式，创建RDD
    input_rdd = sc.parallelize([1, 2, 3, 4, 5])

    # TODO: map 算子，对集合中每条数据进行处理，按照指定逻辑处理
    map_rdd = input_rdd.map(lambda item: item * item)
    print(map_rdd.collect())

    # TODO: filter 算子，对集合中每条数据进行过滤，返回值为true保存，否则删除
    filter_rdd = input_rdd.filter(lambda item: item % 2 == 1)
    print(filter_rdd.collect())

    # TODO: flatMap 算子，对集合中每条数据进行处理，类似map算子，但是要求处理每条数据结果为集合，将自动将集合数据扁平化（explode）
    rdd = sc.parallelize(['爱情 / 犯罪', '剧情 / 灾难 / 动作'])
    flat_rdd = rdd.flatMap(lambda item: str(item).split(' / '))
    flat_rdd.foreach(lambda item: print(item))
    """
        1001,'剧情 / 犯罪' 
        1002, '剧情 / 爱情 / 灾难'
            |
        1001, ‘剧情’
        1001, ‘犯罪’
        1002， ‘剧情'
        1002, ’爱情'
        1002， ‘灾难’
    """

    # 3. 数据转换处理-transformation

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
