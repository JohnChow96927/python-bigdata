#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == '__main__':
    """
    TODO:
    SparkSQL内置外部数据源: text, 加载load和保存save案例演示
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
    # TODO: 1. 加载text格式数据
    dataframe = spark.read.text('../datas/resources/people.txt')
    dataframe.printSchema()
    dataframe.show(truncate=False)

    # 3. 数据转换处理-transformation

    # 4. 处理结果输出-sink
    # TODO: 2. 保存text格式数据
    dataframe.write.mode('overwrite').text('../datas/save-text')

    # 5. 关闭上下文对象-close
    spark.stop()
