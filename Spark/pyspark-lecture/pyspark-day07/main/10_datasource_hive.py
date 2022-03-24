#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == '__main__':
    """
    TODO:
    SparkSQL内置数据源: Hive, 从其中加载load数据, 和保存数据save
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
        .config("spark.sql.warehouse.dir", 'hdfs://node1.itcast.cn:8020/user/hive/warehouse') \
        .config('hive.metastore.uris', 'thrift://node1.itcast.cn:9083') \
        .enableHiveSupport() \
        .getOrCreate()

    # 2. 加载数据源-source
    emp_df = spark.read.format('hive').table('db_hive.emp')
    emp_df.printSchema()
    emp_df.show(20, truncate=False)

    # 3. 数据转换处理-transformation

    # 4. 处理结果输出-sink
    emp_df \
        .coalesce(1) \
        .write \
        .format('hive') \
        .mode('append') \
        .saveAsTable('db_hive.emp_v2')

    # 5. 关闭上下文对象-close
    spark.stop()
