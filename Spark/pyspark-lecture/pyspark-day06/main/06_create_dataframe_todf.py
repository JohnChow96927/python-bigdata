#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import re

from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == '__main__':
    """
    TODO:
    RDD数据集转换DataFrame, 采用toDF函数, 要求RDD数据类型必须是元组, 指定列名称即可.
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取会话实例对象-session
    spark = SparkSession.builder \
        .appName("Python SparkSQL Example") \
        .master("local[*]") \
        .getOrCreate()

    # 2. 加载数据源-source
    rating_rdd = spark.sparkContext.textFile('../datas/ml-100k/u.data')

    # 3. 数据转换处理-transformation
    """
    3-1. RDD[tuple]
    3-2. toDF()
    """
    # 3-1. RDD[tuple]
    tuple_rdd = rating_rdd.map(lambda line: re.split('\\s+', line)).map(
        lambda lst: (lst[0], lst[1], float(lst[2]), int(lst[3])))

    # 3-2. toDF()
    rating_df = tuple_rdd.toDF(['user_id', 'movie_id', 'rating', 'timestamp'])

    # 4. 处理结果输出-sink
    rating_df.printSchema()
    rating_df.show(10, False)

    # 5. 关闭上下文对象-close
    spark.stop()
