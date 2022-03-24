#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == '__main__':
    """
    TODO:
    注册DataFrame为临时视图, 编写SQL分析数据 
    加载鸢尾花数据集, 使用SQL分析, 基本聚合统计操作
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
    iris_rdd = spark.sparkContext.textFile('../datas/iris/iris.data')

    # 3. 数据转换处理-transformation
    """
    采用toDF函数方式, 转换RDD为DataFrame, 此时要求RDD中数据类型为元组Tuple
    """
    tuple_rdd = iris_rdd \
        .map(lambda line: str(line).split(',')) \
        .map(lambda lst: (float(lst[0]), float(lst[1]), float(lst[2]), float(lst[3]), lst[4]))
    # 调用toDF函数, 指定列名称
    iris_df = tuple_rdd.toDF(['sepal_length', 'sepal_width', 'petal_length', 'petal_width', 'category'])
    iris_df.printSchema()
    iris_df.show(10, False)

    # step1. 注册DataFrame为临时视图
    iris_df.createOrReplaceTempView('view_tmp_iris')
    # step2. 编写SQL语句执行分析
    result_df = spark.sql("""
        select
            category,
            count(1) as total,
            round(AVG(sepal_length), 2) as sepal_length_avg,
            round(AVG(sepal_width), 2) as sepal_width_avg,
            round(AVG(petal_length), 2) as petal_length_avg,
            round(avg(petal_width), 2) as petal_width_avg
        from
            view_tmp_iris
        group by
            category
    """)

    # 4. 处理结果输出-sink
    result_df.printSchema()
    result_df.show(10, False)

    # 5. 关闭上下文对象-close
    spark.stop()
