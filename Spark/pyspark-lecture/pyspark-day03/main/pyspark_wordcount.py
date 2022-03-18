#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import re
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    使用PySpark实现词频统计WordCount：加载文本文件数据为RDD集合，调用转换算子处理数据，最后数据触发算子输出数据   
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
    input_rdd = sc.textFile('../datas/words.data', minPartitions=2)
    print(input_rdd.collect())

    # 3. 数据转换处理-transformation
    """
        a. 过滤脏数据，空行
            filter
        b. 分割每行数据，转换为单词 -> 使用正则分割
            flatMap
        c. 将每个单词转换为二元组，表示每个单词出现一次
            map
        d. 按照单词分组，再组内求和
            reduceByKey
    """
    # a. 过滤脏数据，空行
    line_rdd = input_rdd.filter(lambda line: len(str(line).strip()) > 0)
    print(line_rdd.collect())

    # b. 分割每行数据，转换为单词 -> 使用正则分割
    word_rdd = line_rdd.flatMap(lambda line: re.split('\\s+', line))
    print(word_rdd.collect())

    # c. 将每个单词转换为二元组，表示每个单词出现一次
    tuple_rdd = word_rdd.map(lambda word:  (word, 1))
    print(tuple_rdd.collect())

    # d.按照单词分组，再组内求和
    output_rdd = tuple_rdd.reduceByKey(lambda tmp, item: tmp + item)
    print(output_rdd)

    # 4. 处理结果输出-sink
    output_rdd.foreach(lambda tuple: print(tuple))

    # 5. 关闭上下文对象-close
    sc.stop()
