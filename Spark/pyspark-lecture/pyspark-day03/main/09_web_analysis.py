#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext


if __name__ == '__main__':
    """
    基于阿里提供用户行为日志数据，使用Spark RDD进行基本指标统计分析：pv和uv   
    """

    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[4]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.textFile('../datas/tianchi_user.csv', minPartitions=4)
    # print(input_rdd.first())
    # print("count:", input_rdd.count())
    """
    98047837,232431562,1,,4245,2014-12-06 02
    count: 1048575
    """

    # 3. 数据转换处理-transformation
    """
        3-1. 过滤脏数据，解析数据，每条数据封装到元组中
        3-2. pv统计
        3-3. uv统计
    """
    # 3-1. 过滤脏数据，解析数据，每条数据封装到元组中
    """
    对原始日志数据进行ETL转换操作，包括过滤、解析和转换
        数据格式：98047837,232431562,1,,4245,2014-12-06 02
    """
    parse_rdd = input_rdd\
        .map(lambda line: str(line).split(',')) \
        .filter(lambda line: len(str(line).split(',')) == 6) \
        .map(lambda list: (
            list[0], list[1], int(list[2]), list[3], list[4], list[5], str(list[5])[0:10]
        ))
    # print("count:", parse_rdd.count())
    # print(parse_rdd.first())
    """
        ('98047837', '232431562', 1, '', '4245', '2014-12-06 02', '2014-12-06')
    """

    # 3-2. pv统计
    """
        ('2014-12-06', 1)
        ('2014-12-06', 1)       ->  reduceByKey
        ('2014-12-06', 1)
        ----------------------------
        解析数据  -map->  ('2014-12-06', 1) -reduceByKey-> ('2014-12-06', 988777) -> coalesce降低RDD分区数目为1 -> sortBy降序排序
        ......
    """
    pv_rdd = parse_rdd\
        .map(lambda tuple: (tuple[6], 1))\
        .reduceByKey(lambda tmp, item: tmp + item)\
        .coalesce(1)\
        .sortBy(lambda tuple: tuple[1], ascending=False)
    pv_rdd.foreach(lambda item: print(item))

    # 3-3. uv统计
    """
        原始数据
            ('98047837', '232431562', 1, '', '4245', '2014-12-06 02', '2014-12-06')
        a. 提取字段： map
            ('2014-12-06', '98047837')
            ('2014-12-06', '98047837')
            ('2014-12-06', '98047837')
            ('2014-12-06', '96610296')
            ('2014-12-06', '96610296')
        b. 去重: distinct
            ('2014-12-06', '98047837')
            ('2014-12-06', '96610296')
        c. 转换数据: map
            ('2014-12-06', 1)
            ('2014-12-06', 1)
        d. 分组聚合，每日uv: reduceByKey
            ('2014-12-06', 2)
        e. 按照uv降序排序: sortBy
    """
    uv_rdd = parse_rdd\
        .map(lambda tuple: (tuple[6], tuple[0]))\
        .distinct()\
        .map(lambda tuple: (tuple[0], 1))\
        .reduceByKey(lambda tmp, item: tmp + item)\
        .coalesce(1)\
        .sortBy(lambda tuple: tuple[1], ascending=False)
    uv_rdd.foreach(lambda item: print(item))

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
