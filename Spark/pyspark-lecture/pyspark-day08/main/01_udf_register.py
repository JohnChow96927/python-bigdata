#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == '__main__':
    """
    TODO:
    SparkSQL中自定义UDF函数, 采用register方式注册定义函数
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
    people_df = spark.read.json('../datas/resources/people.json')
    people_df.printSchema()
    people_df.show(10, truncate=False)

    # 3. 数据转换处理-transformation
    """
    将DataFrame数据集中name字段值转换为大写UpperCase
    """
    # TODO: 注册定义函数
    upper_udf = spark.udf.register(
        'to_upper',
        lambda name: str(name).upper()
    )

    # TODO: 在SQL中使用函数
    people_df.createOrReplaceTempView('view_tmp_people')
    spark.sql(
        """
        select
            name, to_upper(name) as name_upper
        from
            view_tmp_people
        """
    ) \
        .show(n=10, truncate=False)

    # TODO: 在DSL中使用函数
    people_df.select(
        'name', upper_udf('name').alias('name_upper')
    ) \
        .show(10, False)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    spark.stop()
