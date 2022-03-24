#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

from pyspark import StorageLevel
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == '__main__':
    """
    TODO:
    加载json格式数据, 封装到DataFrame中, 使用DataFrame API进行操作(类似RDD算子)
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
    emp_df = spark.read.json('hdfs://node1.itcast.cn:8020/datas/resources/employees.json')
    emp_df.printSchema()
    emp_df.show(10, False)
    """
        root
             |-- name: string (nullable = true)
             |-- salary: long (nullable = true)
            
            +-------+------+
            |name   |salary|
            +-------+------+
            |Michael|3000  |
            |Andy   |4500  |
            |Justin |3500  |
            |Berta  |4000  |
            +-------+------+
    """

    # 3. 数据转换处理-transformation
    # TODO: count/collect/take/first/head/tail
    print("emp_df.count(): ", emp_df.count())
    print("emp_df.collect(): ", emp_df.collect())
    print("emp_df.take(2): ", emp_df.take(2))
    print("emp_df.head(): ", emp_df.head())
    print("emp_df.first(): ", emp_df.first())
    print("emp_df.tail(2): ", emp_df.tail(2))

    # TODO: foreach/foreachPartition
    print("emp_df.foreach(lambda row: print(row)): ", emp_df.foreach(lambda row: print(row)))

    # TODO: coalesce/repartition
    print("emp_df.rdd.getNumPartitions(): ", emp_df.rdd.getNumPartitions())
    print("emp_df.coalesce(1).rdd.getNumPartitions(): ", emp_df.coalesce(1).rdd.getNumPartitions())
    print("emp_df.repartition(3).rdd.getNumPartitions(): ", emp_df.repartition(3).rdd.getNumPartitions())

    # TODO：cache/persist
    print("emp_df.cache(): ", emp_df.cache())
    print("emp_df.unpersist(): ", emp_df.unpersist())
    print("emp_df.persist(storageLevel=StorageLevel.MEMORY_AND_DISK): ", emp_df.persist(storageLevel=StorageLevel.MEMORY_AND_DISK))

    # TODO: columns/schema/rdd/printSchema
    print("emp_df.columns: ", emp_df.columns)
    print("emp_df.schema: ", emp_df.schema)
    emp_df.printSchema()

    """
        emp_df.count():  4
        emp_df.collect():  [Row(name='Michael', salary=3000), Row(name='Andy', salary=4500), Row(name='Justin', salary=3500), Row(name='Berta', salary=4000)]
        emp_df.take(2):  [Row(name='Michael', salary=3000), Row(name='Andy', salary=4500)]
        emp_df.head():  Row(name='Michael', salary=3000)
        emp_df.first():  Row(name='Michael', salary=3000)
        emp_df.tail(2):  [Row(name='Justin', salary=3500), Row(name='Berta', salary=4000)]
        emp_df.foreach(lambda row: print(row)):  
        Row(name='Michael', salary=3000)
        Row(name='Andy', salary=4500)
        Row(name='Justin', salary=3500)
        Row(name='Berta', salary=4000)
        emp_df.rdd.getNumPartitions():  1
        emp_df.coalesce(1).rdd.getNumPartitions():  1
        emp_df.repartition(3).rdd.getNumPartitions():  3
        emp_df.cache():  DataFrame[name: string, salary: bigint]
        emp_df.unpersist():  DataFrame[name: string, salary: bigint]
        emp_df.persist(storageLevel=StorageLevel.MEMORY_AND_DISK):  DataFrame[name: string, salary: bigint]
        emp_df.columns:  ['name', 'salary']
        emp_df.schema:  StructType(List(StructField(name,StringType,true),StructField(salary,LongType,true)))
        root
         |-- name: string (nullable = true)
         |-- salary: long (nullable = true)
    """

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    spark.stop()
