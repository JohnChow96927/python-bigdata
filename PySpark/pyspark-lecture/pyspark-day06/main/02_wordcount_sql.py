#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession

if __name__ == '__main__':
    """
    TODO:
    使用SparkSQL实现词频统计WordCount, 基于SQL语句实现
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
    input_df = spark.read.text('../datas/words.txt')
    input_df.printSchema()
    input_df.show(n=10, truncate=False)

    # 3. 数据转换处理-transformation
    """
    当使用SQL方式分析数据时, 两个步骤:
    step1. 注册DataFrame为临时view
    step2. 编写SQL语句并执行
    """
    # step1. 注册DataFrame为临时视图view
    input_df.createOrReplaceTempView('view_tmp_lines')
    # step2. 编写SQL语句并执行
    output_df = spark.sql("""
    with tmp as (
    select explode(split(value, ' ')) as word from view_tmp_lines
    )
    select word, count(1) as total from tmp group by word order by total desc limit 10
    """)

    # 4. 处理结果输出-sink
    output_df.printSchema()
    output_df.show(n=10, truncate=False)

    # 5. 关闭上下文对象-close
    spark.stop()
