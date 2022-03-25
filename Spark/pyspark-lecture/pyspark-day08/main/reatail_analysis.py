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
        .config('spark.sql.shuffle.partitions', '4') \
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
        .filter((F.col('receivable') < 10000) &
                (F.col('storeProvince').isNotNull()) &
                (F.col('storeProvince') != 'null')
                ) \
        .select(F.col('storeProvince').alias('store_province'),
                F.col('storeID').alias('store_id'),
                F.col('payType').alias('pay_type'),
                F.from_unixtime(F.substring(F.col('dateTS'), 0, 10), 'yyyy-MM-dd').alias('day'),
                F.col('receivable').cast(DecimalType(10, 2)).alias('receivable_money')
                )
    dataframe.printSchema()
    dataframe.show(10, False)

    """
    3-2. 需求一: 各个省份销售额统计, 按照省份分组, 统计销售额
    """
    province_total_df = retail_df \
        .groupBy('store_province') \
        .agg(F.sum('receivable_money').alias('total_money'))
    province_total_df.printSchema()
    province_total_df.show(34, False)

    """
    3-3. top3省份数据
    """
    # 3-3-1. top3省份
    top3_province_list = province_total_df \
        .orderBy(F.col('total_money').desc()) \
        .limit(3) \
        .select('store_province') \
        .rdd \
        .map(lambda row: row.store_province) \
        .collect()

    # 3-3-2. 过滤获取top3省份业务数据
    top3_retail_df = retail_df\
        .filter(F.col('store_province')
                .isin(top3_province_list))
    top3_retail_df.printSchema()
    top3_retail_df.printSchema()
    top3_retail_df.show(10, truncate=False)

    # TODO: 需求2,3,4使用SQL分析, 先注册临时视图
    top3_retail_df.createOrReplaceTempView('view_tmp_top3_retail')
    # 缓存数据
    spark.catalog.cacheTable('view_tmp_top3_retail')

    """
    3-4. Top3省份中, 日均销售金额1000+, 店铺总数统计
        a. 分组统计每个省份, 每个商铺每天的销售额
        b. 过滤获取大于1000数据
        c. 去重
        d. 按照省份分组, 统计商铺总数
    """
    top3_province_count_df = spark.sql(
        """
        with tmp as (
            select 
                store_province,
                store_id,
                day,
                sum(receivable_money) as total_money
            from
                view_tmp_top3_retail
            group by
                store_province,
                store_id,
                day
            having
                total_money
        )
        select
            store_province,
            count(distinct store_id) as total 
        from
            tmp
        group by
            store_province
        """
    )
    top3_province_count_df.printSchema()
    top3_province_count_df.show(truncate=False)

    """
    3-5. 需求三: Top3省份中, 每个省的平均单价
    先按照省份分组, 使用avg函数求取所有订单金额的平均值
    """
    top3_province_avg_df = spark.sql(
        """
        select
            store_province,
            round(avg(receivable_money), 2) as avg_money
        from
            view_tmp_top3_retail
        group by
            store_province
        """
    )
    top3_province_avg_df.printSchema()
    top3_province_avg_df.show(truncate=False)

    """
    3-6. 需求四: 各个省份的支付类型比例
        a. 各个省份各种支付类型总数
        b. 同一个省份数据, 添加一列: 各种类型总的支付次数
        c. 每行数据, 计算占比
    """
    top3_province_pay_df = spark.sql(
        """
        with tmp as (
            select
                store_province,
                pay_type,
                count(1) as total 
            from
                view_tmp_top3_retail
            group by
                store_province,
                pay_type
        ),
        tmp_1 as (
            select
                 t1.*,
                 sum(total) over (partition by store_province) as all_total
            from
                tmp t1
        )
        select
            t2.store_province,
            t2.pay_type,
            round(t2.total / (t2.all_total * 1.0), 2) as rate
        from
            tmp_1 t2
        """
    )
    top3_province_pay_df.printSchema()
    top3_province_pay_df.show(n=50, truncate=False)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    # 释放缓存资源
    spark.catalog.uncacheTable('view_tmp_top3_retail')
    spark.stop()
