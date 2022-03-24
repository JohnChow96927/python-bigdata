#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == '__main__':
    """
    TODO:
    SparkSQL内置数据源: csv, 加载数据和保存数据
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
    # TODO: 1. 加载csv格式数据
    csv_df = spark.read.csv('../datas/resources/people.csv', sep=';', header=True, inferSchema=True)
    csv_df.printSchema()
    csv_df.show(10, truncate=False)

    # 3. 数据转换处理-transformation

    # 4. 处理结果输出-sink
    csv_df.coalesce(1).write.mode('overwrite').csv('../datas/save-csv', sep=',', header=True)

    # 5. 关闭上下文对象-close
    spark.stop()
