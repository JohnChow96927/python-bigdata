#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import pyspark.sql.functions as F
from pyspark.sql import SparkSession

if __name__ == '__main__':
    """
    TODO:
    Top10电影分析(电影评分最高10个, 并且每个电影评分人数大于2000)
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取会话实例对象-session
    spark = SparkSession.builder \
        .appName("TOP10 movies implement with DSL") \
        .master("local[*]") \
        .config('spark.sql.shuffle.partitions', '4') \
        .getOrCreate()

    # 2. 加载数据源-source
    rating_rdd = spark.sparkContext.textFile('../datas/ml-1m/ratings.dat')
    print('count: ', rating_rdd.count())
    print(rating_rdd.first())

    # 3. 数据转换处理-transformation
    """
        数据格式：
            1::1193::5::978300760
        转换DataFrame：
            采用toDF函数指定列名称
    """
    # 3-1. 将rdd转换为DataFrame
    rating_df = rating_rdd \
        .map(lambda line: str(line).split('::')) \
        .map(lambda lst: (lst[0], lst[1], float(lst[2]), int(lst[3]))) \
        .toDF(['user_id', 'item_id', 'rating', 'timestamp'])
    rating_df.printSchema()
    rating_df.show(10, False)

    # 3-2. 基于DSL方式分析数据, 调用DataFrame函数(尤其是SQL函数)
    """
        Top10电影：电影评分人数>2000, 电影平均评分降序排序，再按照电影评分人数降序排序
        a. 按照电影进行分组：groupBy
        b. 每个电影数据聚合：agg
            count、avg
        c. 过滤电影评分人数：where/filter
        d. 评分和人数降序排序：orderBy/sortBy
        e. 前10条数据：limit
    """
    top10_movie_df = rating_df \
        .groupBy(F.col('item_id')) \
        .agg(F.count(F.col('item_id')).alias('rating_total'),
             F.round(F.avg(F.col('rating')), 2).alias('rating_avg')
             ) \
        .where(F.col('rating_total') > 2000) \
        .orderBy(F.col('rating_avg').desc(),
                 F.col('rating_total').desc()) \
        .limit(10)
    top10_movie_df.printSchema()
    top10_movie_df.show(truncate=False)

    # 3-3. 加载电影基本信息数据
    movie_df = spark.sparkContext \
        .textFile('../datas/ml-1m/movies.dat') \
        .map(lambda line: str(line).split('::')) \
        .toDF(['movie_id', 'title', 'genres'])

    # 3-4. 将Top10电影与电影基本信息数据进行join, 采用DSL
    result_df = top10_movie_df.join(
        movie_df,
        on=F.col('item_id') == F.col('movie_id'),
        how='inner'
    ) \
        .select(
        F.col('title'),
        F.col('rating_avg').alias('rating'),
        F.col('rating_total').alias('total')
    )\
        .orderBy(F.col('rating').desc())

    # 4. 处理结果输出-sink
    result_df.printSchema()
    result_df.show(10, truncate=False)

    # 5. 关闭上下文对象-close
    spark.stop()
