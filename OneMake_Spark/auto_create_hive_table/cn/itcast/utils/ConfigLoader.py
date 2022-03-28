#!/usr/bin/env python
# @desc : todo 加载并读取数据库连接信息工具类
__coding__ = "utf-8"
__author__ = "itcast"

import configparser

# load and read config.ini
config = configparser.ConfigParser()
config.read('D:\\PythonProject\\OneMake_Spark\\auto_create_hive_table\\resources\\config.txt')


# 根据key获得value
def getProperty(section, key):
    return config.get(section, key)


# 根据key获得oracle数据库连接的配置信息
def getOracleConfig(key):
    return config.get('OracleConn', key)


# 根据key获得spark连接hive数据库的配置信息
def getSparkConnHiveConfig(key):
    return config.get('SparkConnHive', key)

# 根据key获得hive数据库的配置信息
def getHiveConfig(key):
    return config.get('HiveConn', key)
