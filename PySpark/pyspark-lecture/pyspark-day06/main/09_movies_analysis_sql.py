#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == '__main__':
    """
    TODO:
    Top10电影分析(电影评分最高的10部, 并且每个电影评分大于2000)
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取会话实例对象-session
    spark = SparkSession.builder \
        .appName("SparkSQL: Top10 Movie Analysis") \
        .master("local[*]") \
        .config("spark.sql.shuffle.partition", "4") \
        .getOrCreate()

    # 2. 加载数据源-source
    rating_rdd = spark.sparkContext.textFile("../datas/ml-1m/ratings.dat")
    print("count: ", rating_rdd.count())
    print(rating_rdd.first())

    # 3. 数据转换处理-transformation
    # 3-1. 将RDD数据封装转换为DataFrame数据集
    rating_df = rating_rdd \
        .map(lambda line: str(line).split('::')) \
        .map(lambda lst: (lst[0], lst[1], float(lst[2]), int(lst[3]))) \
        .toDF(['user_id', 'item_id', 'rating', 'timestamp'])

    # 3-3. 加载电影基本信息数据
    movie_df = spark.sparkContext.textFile('../datas/ml-1m/movies.dat') \
        .map(lambda line: str(line).split("::")) \
        .toDF(['movie_id', 'title', 'genres'])
    movie_df.printSchema()
    movie_df.show(10, truncate=False)
    # 注册DataFrame为临时视图
    movie_df.createOrReplaceTempView("tmp_view_movies")

    # 3-2. 编写SQL分析数据
    # step1. 注册DataFrame为临时视图
    rating_df.createOrReplaceTempView('tmp_view_ratings')

    # step2. 编写SQL语句
    top10_movie_df_john = spark.sql("""
        with temp_1 as (
            select item_id, 
            count(item_id) as rating_total,
            round(avg(rating), 2) as avg_rating 
            from tmp_view_ratings 
            group by item_id
            having rating_total > 2000
            order by avg_rating DESC, rating_total DESC
            LIMIT 10
            )
        select v.title, tmp.avg_rating rating, tmp.rating_total total 
        from temp_1 tmp
        join tmp_view_movies v on tmp.item_id = v.movie_id 
    """)
    top10_movie_df_john.show(10, False)

    """
    上课标准
    a. 每个电影平均评分和评分人数
        group by item_id
        avg(rating), round
        count(item_id)
    b. top10电影
        rating_total > 2000
        rating_avg DESC
        limit 10
    """
    # top10_movie_df = spark.sql("""
    #
    # """)

    # 4. 处理结果输出-sink
    rating_df.printSchema()
    rating_df.show(10, False)

    # 5. 关闭上下文对象-close
    spark.stop()
