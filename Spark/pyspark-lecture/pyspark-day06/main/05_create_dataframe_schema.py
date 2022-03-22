#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import re

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import StructType, StructField, StringType, DoubleType, LongType

if __name__ == '__main__':
    """
    TODO:
    将RDD数据转换为DataFrame, 采用自定义Schema方式: 
        RDD[list/tuple], StructType, 组合RDD和Schema=DataFrame
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
    rating_rdd = spark.sparkContext.textFile('../datas/ml-100k/u.data')

    # 3. 数据转换处理-transformation
    """
    3-1. RDD[list]
    3-2. schema: StructType
    3-3. createDataFrame
    """
    # 3-1. RDD[list]
    list_add = rating_rdd \
        .map(lambda line: re.split('\\s+', line)) \
        .map(lambda lst: [lst[0], lst[1], float(lst[2]), int(lst[3])])

    # 3-2. schema: StructType
    list_schema = StructType(
        [
            StructField("user_id", StringType(), True),
            StructField("movie_id", StringType(), True),
            StructField("rating", DoubleType(), True),
            StructField("timestamp", LongType(), True)
        ]
    )

    # 3-3. createDataFrame
    rating_df = spark.createDataFrame(list_add, schema=list_schema)

    # 4. 处理结果输出-sink
    rating_df.printSchema()
    rating_df.show(10, False)

    # 5. 关闭上下文对象-close
    spark.stop()
