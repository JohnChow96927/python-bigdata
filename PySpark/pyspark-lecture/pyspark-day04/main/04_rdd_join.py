#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    TODO:
    针对KeyValue类型RDD，依据Key将2个RDD进行关联JOIN，等值JOIN
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python3'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python3'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Join算子").setMaster("local[*]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    emp_rdd = sc.parallelize([(1001, "zhangsan"), (1002, "lisi"), (1003, "wangwu"), (1004, "zhaoliu")])
    dept_rdd = sc.parallelize([(1001, "sales"), (1002, "tech")])

    # 3. 数据转换处理-transformation
    join_rdd = emp_rdd.join(dept_rdd)
    join_rdd.foreach(lambda item: print(item))

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()
