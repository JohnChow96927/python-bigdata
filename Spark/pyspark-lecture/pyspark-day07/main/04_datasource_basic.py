#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == '__main__':
    """
    SparkSQL提供一套外部数据源接口, 方便用户读取数据和写入数据, 采用一定格式
    TODO:
    从本地文件系统加载JSON格式数据, 保存为Parquet格式
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
    # TODO: 1. 加载JSON格式数据
    json_df = spark.read \
        .format('json') \
        .option('path', '../datas/resources/employees.json') \
        .load()
    json_df.printSchema()
    json_df.show(10, truncate=False)

    # 3. 数据转换处理-transformation

    # 4. 处理结果输出-sink
    # TODO: 2. 保存Parquet格式数据
    json_df.write \
        .mode('overwrite') \
        .format('parquet') \
        .option('path', '../datas/resources/emp-parquet') \
        .save()

    # 5. 关闭上下文对象-close
    spark.stop()
