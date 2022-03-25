#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark.sql import SparkSession
import pyspark.sql.functions as F
from pyspark.sql.types import DecimalType

if __name__ == '__main__':
    """
    TODO:
    零售数据分析, json格式业务数据, 加载数据封装到DataFrame中, 再进行转换处理分析
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取会话实例对象-session
    spark = SparkSession.builder \
        .appName("Retail Analysis") \
        .master("local[*]") \
        .config('spark.sql.shuffle.partitions', '2') \
        .getOrCreate()

    # 2. 加载数据源-source
    dataframe = spark.read.json('../datas/retail.json')
    print('count: ', dataframe.count())
    dataframe.printSchema()
    dataframe.show(10, False)

    # 3. 数据转换处理-transformation
    """
    3-1. 过滤测试数据和提取字段与转换值, 此外字段名称重命名
    """
    retail_df = dataframe \
        .filter(
            (F.col('receivable') < 10000) &
            (F.col('storeProvince').isNotNull()) &
            (F.col('storeProvince') != 'null')
        ) \
        .select(
            F.col('storeProvince').alias('store_province'),
            F.col('storeID').alias('store_id'),
            F.col('payType').alias('pay_type'),
            F.from_unixtime(
                F.substring(F.col('dateTS'), 0, 10), 'yyyy-MM-dd'
            ).alias('day'),
            F.col('receivable').cast(DecimalType(10, 2)).alias('receivable_money')
        )

    # 注册临时视图
    dataframe.createOrReplaceTempView('view_tmp_ods')
    # 编写SQL并执行
    retail_df_sql = spark.sql(
        """
            select
                storeProvince as store_province,
                storeID as store_id,
                CAST(receivable as decimal(10, 2)) as receivable_money,
                payType as pay_type,
                from_unixtime(substring(dateTS, 0, 10), 'yyyy-MM-dd') as day
            from
                view_tmp_ods
            where
                receivable < 10000 and 
                storeProvince is not null and 
                storeProvince != 'null'
        """)
    retail_df_sql.show(10, False)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    spark.stop()
