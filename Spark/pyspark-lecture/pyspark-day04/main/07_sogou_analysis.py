#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import re

import jieba
from pyspark import SparkConf, SparkContext


def parse_data(rdd):
    """
    数据格式:
        00:00:00
        2982199073774412
        [360安全卫士]
        8
        3
        download.it.com.cn/softweb/software/firewall/antivirus/20067/17938.html
    step1. 简单过滤脏数据
    step2. 解析数据, 使用正则 \\s+
    step3. 封装到元组中
    """
    output_rdd = rdd.map(lambda line: re.split('\\s+', line)) \
        .filter(lambda lst: len(lst) == 6) \
        .map(lambda lst: (lst[0],
                          lst[1],
                          str(lst[2])[1:-1],
                          int(lst[3]),
                          int(lst[4]),
                          lst[5]))
    return output_rdd


def query_keyword_count(rdd):
    """
    搜索关键词统计：首先对查询词进行中文分词，然后对分词单词进行分组聚合，类似WordCount词频统计
        ('00:00:00', '2982199073774412', '360安全卫士', 8, 3, 'download.it.com.cn/softweb/software/firewall/antivirus/20067/17938.html')
        TODO:
            WITH tmp AS (
                SELECT explode(split_search(search_words)) AS keyword FROM tbl_logs
            )
            SELECT keyword, COUNT(1) AS total FROM tmp GROUP BY keyword
    :param rdd: 封装数据集
    :return: 聚合计数rdd
    """
    output_rdd = rdd \
        .flatMap(lambda tuple: list(jieba.cut(tuple[2], cut_all=False))) \
        .map(lambda keyword: (keyword, 1)) \
        .reduceByKey(lambda tmp, item: tmp + item)
    return output_rdd


if __name__ == '__main__':
    """
    TODO:
    SogouQ日志分析
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[*]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    log_rdd = sc.textFile('../datas/SogouQ.reduced', minPartitions=4)
    print('count: ', log_rdd.count())
    print('first line: ', log_rdd.first())

    # 3. 数据转换处理-transformation
    """
    3-1. 解析转换数据
    3-2. 依据业务分析数据
    """
    # 3-1. 解析转换数据
    sogou_rdd = parse_data(log_rdd)
    print("转换后的第一条数据: ", sogou_rdd.first())
    # 3-2. 搜索关键词统计
    query_keyword_rdd = query_keyword_count(sogou_rdd)
    top_10_keyword = query_keyword_rdd.top(10, key=lambda tuple: tuple[1])
    print(top_10_keyword)

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
