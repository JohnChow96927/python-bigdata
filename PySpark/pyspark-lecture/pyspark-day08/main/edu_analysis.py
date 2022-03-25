#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import pyspark.sql.functions as F
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StringType, IntegerType, TimestampType

if __name__ == '__main__':
    """
    TODO:
    在线教育用户行为日志分析: 将数据封装到DataFrame, 注册为临时视图, 编写SQL
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = 'C:/Java/jdk1.8.0_241'
    os.environ['HADOOP_HOME'] = 'C:/Hadoop/hadoop-3.3.0'
    os.environ['PYSPARK_PYTHON'] = 'C:/Users/JohnChow/anaconda3/python.exe'
    os.environ['PYSPARK_DRIVER_PYTHON'] = 'C:/Users/JohnChow/anaconda3/python.exe'

    # 1. 获取会话实例对象-session
    spark = SparkSession.builder \
        .appName("Online_Edu_Analysis") \
        .master("local[*]") \
        .config('spark.sql.shuffle.partitions', 2) \
        .getOrCreate()

    # 2. 加载数据源-source
    # 2-1. 定义Schema信息
    edu_schema = StructType() \
        .add('student_id', StringType()) \
        .add('recommendations', StringType()) \
        .add('textbook_id', StringType()) \
        .add('grade_id', StringType()) \
        .add('subject_id', StringType()) \
        .add('chapter_id', StringType()) \
        .add('question_id', StringType()) \
        .add('score', IntegerType()) \
        .add('answer_time', StringType()) \
        .add('ts', TimestampType())

    # 2-2. 加载csv数据文件
    edu_df = spark.read.format("csv") \
        .option('sep', '\t') \
        .option('header', True) \
        .schema(edu_schema) \
        .load('../datas/eduxxx.csv')
    edu_df.printSchema()
    edu_df.show(10, False)

    # 3. 数据转换处理-transformation
    # 3-1. 注册DataFrame为临时视图
    edu_df.createOrReplaceTempView('view_tmp_edu')

    # TODO: 3-2. 需求一: 找到Top50热点题对应科目, 然后统计这些科目中, 分别包含这几道热点题的条目数
    top50_df = spark.sql(
        """
            with tmp as (
                select
                    question_id
                from
                    view_tmp_edu
                group by
                    question_id
                order by
                    sum(score) desc
                limit 50
            )
            select
                t2.subject_id,
                count(1) as total
            from
                tmp t1 
            join view_tmp_edu t2
            on
                t1.question_id = t2.question_id
            group by
                t2.subject_id
        """
    )
    top50_df.printSchema()
    top50_df.show(n=50, truncate=False)

    # TODO: 3-3. 需求二: 找到top20热点题对应的推荐题目, 然后找到推荐题目对应的科目, 并统计每个科目分辨包含推荐题目的条数
    # 3-3-1. 找到Top20热点题对应的推荐题目
    top20_question_df = edu_df \
        .groupBy(F.col('question_id')) \
        .agg(F.sum(F.col('score')).alias('score_total')) \
        .orderBy(F.col('score_total').desc()) \
        .limit(20)
    top20_question_df.printSchema()
    top20_question_df.show(20, truncate=False)

    # 3-3-2. Top20热点题关联原数据, 获取推荐题目
    recommend_question_df = top20_question_df \
        .join(edu_df, on='question_id', how='inner') \
        .select(F.explode
                (F.split(F.col('recommendations'), ','))
                .alias('question_id')) \
        .distinct()
    recommend_question_df.printSchema()
    recommend_question_df.show(10, False)

    # 3-3-3. 关联原始数据, 获取科目, 分组统计推荐题条目数
    result_df = recommend_question_df \
        .join(edu_df.dropDuplicates(['question_id']), on='question_id', how='inner') \
        .groupBy(F.col('subject_id')) \
        .agg(F.count(F.col('subject_id')).alias('total'))

    # 4. 处理结果输出-sink
    result_df.printSchema()
    result_df.show(truncate=False)

    # 5. 关闭上下文对象-close
    spark.stop()
