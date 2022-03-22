#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import re

from pyspark.sql import SparkSession, Row

if __name__ == '__main__':
    """
    TODO:
    RDD数据集转换为DataFrame, 通过自动推断类型方式, 要求RDD中数据为Row, 并且指定列名称
    RDD[Row(id=1001, name=zhangsan, age=24, ....)]
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
    3-1. 将RDD中每条数据string, 封装转换为Row对象
    3-2. 直接将Row RDD转换为DataFrame
    """
    row_rdd = rating_rdd \
        .map(lambda line: re.split('\\s+', line)) \
        .map(lambda lst: Row(user_id=lst[0], movie_id=lst[1], rating=float(lst[2]), timestamp=int(lst[3])))

    rating_df = spark.createDataFrame(row_rdd)

    # 4. 处理结果输出-sink
    rating_df.printSchema()
    rating_df.show(n=10, truncate=False)

    # 5. 关闭上下文对象-close
    spark.stop()
