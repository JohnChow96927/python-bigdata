#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    TODO:
    RDD中广播变量: 将Driver中变量(可以是变量, 或字典)广播到Executor中, 所有Task可以共享变量的值,节省内存
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[*]")
    sc = SparkContext(conf=spark_conf)

    # 字典信息
    dic = {1: "北京", 2: "上海", 3: "深圳"}
    # TODO: 1. 将小表数据(变量)进行广播
    broadcast_dic = sc.broadcast(dic)

    # 2. 加载数据源-source
    input_rdd = sc.parallelize([("张三", 1), ("李四", 2), ("王五", 3), ("赵六", 1), ("田七", 2)])

    # 3. 数据转换处理-transformation
    def map_func(tup):
        # TODO: 2. 使用广播变量
        city_dic = broadcast_dic.value
        # 依据城市ID获取城市名称
        city_id = tup[1]
        city_name = city_dic[city_id]
        # 返回
        return tup[0], city_name

    output_rdd = input_rdd.map(map_func)

    # 4. 处理结果输出-sink
    print(output_rdd.collect())

    # 5. 关闭上下文对象-close
    sc.stop()
