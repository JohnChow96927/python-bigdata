#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

import pandas as pd

if __name__ == '__main__':
    """
    TODO:
    SparkSQL DataFrame与Pandas DataFrame相互转换案例演示
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    spark = SparkSession.builder \
        .appName("Python SparkSQL Example") \
        .master("local[*]") \
        .getOrCreate()

    # TODO: step1. 使用pandas加载json数据
    pandas_df = pd.read_csv('../datas/resources/people.csv', sep=';')
    print(pandas_df)

    print('=' * 40)
    # TODO: step2. 转换pandas DataFrame为SoarkSQL DataFrame
    spark_df = spark.createDataFrame(pandas_df)
    spark_df.printSchema()
    spark_df.show()

    print('=' * 40)
    # TODO: step3. 转换sparkSQL DataFrame为Pandas DataFrame
    data_frame = spark_df.toPandas()
    print(data_frame)

    print()

    spark.stop()
