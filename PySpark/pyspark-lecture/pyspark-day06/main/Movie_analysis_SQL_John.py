#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

from pyspark.sql import SparkSession

if __name__ == '__main__':
    """
    TODO:
    完整Top10电影分析代码
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 获取会话实例对象-session
    # 根据性能自动指定线程数, 指定分区数为4
    spark = SparkSession.builder \
        .appName("Top10 Movies Analysis PySparkSQL Implement By John Chow") \
        .master("local[*]") \
        .config("spark.sql.shuffle.partition", "4") \
        .getOrCreate()

    # textFile加载用户评分数据集为RDD
    # 使用map算子转换
    # 使用toDF指定列名称转换成DataFrame
    # 一气呵成链式处理成评分表临时视图
    """
    评分数据格式:
      user_id(string)::
      item_id(string)::
      rating(double)::
      timestamp(long)
    """
    spark.sparkContext \
        .textFile('../datas/ml-1m/ratings.dat') \
        .map(lambda line: str(line).split('::')) \
        .map(lambda lst: (lst[0], lst[1], float(lst[2]), int(lst[3]))) \
        .toDF(['user_id', 'item_id', 'rating', 'timestamp']) \
        .createOrReplaceTempView("rating_temp_view")

    # textFile加载电影基本信息数据为RDD
    # 使用map算子转换
    # 使用toDF指定列名称转换成DataFrame
    # 一气呵成链式处理成电影基本信息表临时视图
    """
    电影基本信息数据格式:
        movie_id(string)::
        title(string)::
        genres(string)
    """
    spark.sparkContext \
        .textFile('../datas/ml-1m/movies.dat') \
        .map(lambda line: str(line).split('::')) \
        .map(lambda lst: (lst[0], lst[1], lst[2])) \
        .toDF(['movie_id', 'title', 'genres']) \
        .createOrReplaceTempView("movie_temp_view")

# 编写Spark SQL语句
top10_movie_df = spark.sql(
    """
        with temp_result as (
            select 
                item_id,
                round(avg(rating), 2) avg_rating,
                count(item_id) total
            from 
                rating_temp_view
            group by 
                item_id
            having 
                total > 2000
        )
        select 
            mtv.title,
            tr.avg_rating rating,
            tr.total
        from 
            temp_result tr
        join 
            movie_temp_view mtv 
        on 
            tr.item_id = mtv.movie_id
        order by 
            rating desc 
        limit 10
    """
)

# 输出结果(不裁剪长度)
top10_movie_df.show(truncate=False)

# 关闭上下文对象
spark.stop()

"""
排序逻辑问题: 
    如果把order by写在CTE中则无法按照评分为第一优先级排序, 第一名不是<肖申克的救赎>
    将order by写在最外层后用limit 10限制结果行数则得到想要结果
"""
