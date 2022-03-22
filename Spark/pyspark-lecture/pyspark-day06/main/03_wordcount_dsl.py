#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == '__main__':
    """
    TODO:
    使用pysparkSQL分析词频统计WordCount, 基于DSL实现.
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark = SparkSession.builder \
        .appName("Python SparkSQL Example") \
        .master("local[*]") \
        .getOrCreate()

    # 2. 加载数据源-source
    input_df = spark.read.text('../datas/words.txt')

    # 3. 数据转换处理-transformation
    """
    a. 分割单词, 进行扁平化(使用explode)
    b. 按照单词分组, 使用count函数统计个数
    c. 按照词频降序排序, 获取前10个
    """
    output_df = input_df \
        .select(explode(split(col('value'), ' ')).alias('word')) \
        .groupBy(col('word')) \
        .agg(count(col('word')).alias('total')) \
        .orderBy(col('total').desc()) \
        .limit(10)

    # 4. 处理结果输出-sink
    output_df.printSchema()
    output_df.show(n=10, truncate=False)

    # 5. 关闭上下文对象-close
    spark.stop()
