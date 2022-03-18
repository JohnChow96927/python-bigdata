#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    TODO:
    使用PySpark中RDD算子实现词频统计WordCount
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark WordCount").setMaster("local[2]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    raw_dataset_rdd = sc.textFile('../datas/words.txt', minPartitions=2)
    print(raw_dataset_rdd.collect())
    """
    ['spark python spark hive spark hive', 
    'python spark hive spark python', 
    'mapreduce spark hadoop hdfs hadoop spark', 
    'hive mapreduce']
    """

    # 3. 数据转换处理-transformation
    # TODO: 使用flatMap算子扁平化分割单词, 分隔符" "
    word_rdd = raw_dataset_rdd.flatMap(lambda str_line: str(str_line).split(' '))
    print(word_rdd.collect())
    """
    ['spark', 'python', 'spark', 'hive', 
    'spark', 'hive', 'python', 'spark', 
    'hive', 'spark', 'python', 'mapreduce', 
    'spark', 'hadoop', 'hdfs', 'hadoop', 
    'spark', 'hive', 'mapreduce']
    """
    # TODO: 使用map算子转换二元组, (word, 1)形式
    word_tuple_rdd = word_rdd.map(lambda word: (word, 1))
    print(word_tuple_rdd.collect())
    """
    [('spark', 1), ('python', 1), ('spark', 1), ('hive', 1), 
    ('spark', 1), ('hive', 1), ('python', 1), ('spark', 1), 
    ('hive', 1), ('spark', 1), ('python', 1), ('mapreduce', 1), 
    ('spark', 1), ('hadoop', 1), ('hdfs', 1), ('hadoop', 1), 
    ('spark', 1), ('hive', 1), ('mapreduce', 1)]
    """
    # TODO: 使用reduceByKey算子按单词聚合单词出现次数
    word_count_rdd = word_tuple_rdd.reduceByKey(lambda temp, item: temp + item)
    print(word_count_rdd.collect())
    """
    [('python', 3), ('hive', 4), ('hadoop', 2), ('hdfs', 1), 
    ('spark', 7), ('mapreduce', 2)]
    """

    # 4. 处理结果输出-sink
    # TODO: 使用saveAsTextFile算子将结果rdd按分区保存为文本文件至本地文件系统
    word_count_rdd.saveAsTextFile('../datas/output_wordCount_John')

    # 5. 关闭上下文对象-close
    sc.stop()
