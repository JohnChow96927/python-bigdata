#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == '__main__':
    """
    TODO:
    SparkSQL内置数据源: parquet列式存储, 默认加载文件格式就是parquet
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
    # TODO: 1. 加载parquet格式数据
    parquet_df = spark.read.parquet('../datas/resources/users.parquet')
    parquet_df.printSchema()
    parquet_df.show(10, truncate=False)

    # TODO: 默认数据格式读取(不指定数据格式)
    default_df = spark.read.load('../datas/resources/users.parquet')
    default_df.printSchema()
    default_df.show(truncate=False)

    # 3. 数据转换处理-transformation

    # 4. 处理结果输出-sink
    parquet_df.coalesce(1).write.mode('overwrite').parquet('../datas/save-parquet')

    # 5. 关闭上下文对象-close
    spark.stop()
