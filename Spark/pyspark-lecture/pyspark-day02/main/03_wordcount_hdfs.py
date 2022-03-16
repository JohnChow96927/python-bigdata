#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    基于Python语言，编程实现Spark中词频统计WordCount
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = 'C:/Java/jdk1.8.0_241'
    os.environ['HADOOP_HOME'] = 'C:/Hadoop/hadoop-3.3.0'
    os.environ['PYSPARK_PYTHON'] = 'C:/Users/JohnChow/anaconda3/python.exe'
    os.environ['PYSPARK_DRIVER_PYTHON'] = 'C:/Users/JohnChow/anaconda3/python.exe'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark WordCount").setMaster("local[2]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.textFile('hdfs://node1.itcast.cn:8020/datas/input/words.txt')

    # 3. 数据转换处理-transformation
    """
        a. 分割单词，扁平化
        d. 转换二元组，每个单词出现一次
        c. 按照单词Key分组，并且对组内聚合
    """
    word_rdd = input_rdd.flatMap(lambda line: str(line).split(' '))
    tuple_rdd = word_rdd.map(lambda word: (word, 1))
    output_rdd = tuple_rdd.reduceByKey(lambda tmp, item: tmp + item)

    # 4. 结果数据输出-sink
    output_rdd.saveAsTextFile('hdfs://node1.itcast.cn:8020/datas/wc-output')

    # 5. 关闭上下文对象-close
    sc.stop()
