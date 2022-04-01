#!/usr/bin/env python
# @desc : todo 实现构建Oracle、Hive、SparkSQL的连接
__coding__ = "utf-8"
__author__ = "itcast"

# 导包
from auto_create_hive_table.cn.itcast.utils import ConfigLoader  # 导入配置文件解析包
import cx_Oracle  # 导入Python连接Oracle依赖库包
from pyhive import hive  # 导入Python连接Hive依赖包
import os  # 导入系统包

# 配置Oracle的客户端驱动文件路径
LOCATION = r"D:\\instantclient_12_2"
os.environ["PATH"] = LOCATION + ";" + os.environ["PATH"]


def getOracleConn():
    """
    用户获取Oracle的连接对象：cx_Oracle.connect(host='', port='', username='', password='', param='')
    :return:
    """
    oracleConn = None  # 构建Oracle连接对象
    try:
        ORACLE_HOST = ConfigLoader.getOracleConfig('oracleHost')  # 通过配置管理对象获取Oracle的机器地址
        ORACLE_PORT = ConfigLoader.getOracleConfig('oraclePort')  # 通过配置管理对象获取Oracle的服务端口
        ORACLE_SID = ConfigLoader.getOracleConfig('oracleSID')  # 通过配置管理对象获取Oracle的SID
        ORACLE_USER = ConfigLoader.getOracleConfig('oracleUName')  # 通过配置管理对象获取Oracle的用户名
        ORACLE_PASSWORD = ConfigLoader.getOracleConfig('oraclePassWord')  # 通过配置管理对象获取Oracle的密码
        # 通过oracle服务的主机名+端口+SID，监听oracle服务
        dsn = cx_Oracle.makedsn(ORACLE_HOST, ORACLE_PORT, ORACLE_SID)
        # 通过oracle的用户+密码+dsn，得到oracle的connect
        oracleConn = cx_Oracle.connect(ORACLE_USER, ORACLE_PASSWORD, dsn)
    # 异常处理
    except cx_Oracle.Error as error:
        print(error)
    # 返回Oracle连接对象
    return oracleConn


def getSparkHiveConn():
    """
    用户获取SparkSQL的连接对象
    :return:
    """
    # 构建SparkSQL的连接对象
    sparkHiveConn = None
    try:
        SPARK_HIVE_HOST = ConfigLoader.getSparkConnHiveConfig('sparkHiveHost')  # 获取SparkSQL的机器地址
        SPARK_HIVE_PORT = ConfigLoader.getSparkConnHiveConfig('sparkHivePort')  # 获取SparkSQL的端口地址
        SPARK_HIVE_UNAME = ConfigLoader.getSparkConnHiveConfig('sparkHiveUName')  # 获取SparkSQL的用户名
        SPARK_HIVE_PASSWORD = ConfigLoader.getSparkConnHiveConfig('sparkHivePassWord')  # 获取SparkSQL的密码
        # 构建SparkSQL连接
        sparkHiveConn = hive.Connection(host=SPARK_HIVE_HOST, port=SPARK_HIVE_PORT, username=SPARK_HIVE_UNAME,
                                        auth='CUSTOM', password=SPARK_HIVE_PASSWORD)
    # 异常处理
    except Exception as error:
        print(error)
    # 返回SparkSQL连接
    return sparkHiveConn


def getHiveConn():
    """
    用户获取HiveServer2的连接对象
    :return:
    """
    # 构建Hive的连接对象
    hiveConn = None
    try:
        HIVE_HOST = ConfigLoader.getHiveConfig("hiveHost")  # 获取HiveServer2的机器地址
        HIVE_PORT = ConfigLoader.getHiveConfig("hivePort")  # 获取HiveServer2的端口地址
        HIVE_USER = ConfigLoader.getHiveConfig("hiveUName")  # 获取HiveServer2的用户名
        HIVE_PASSWORD = ConfigLoader.getHiveConfig("hivePassWord")  # 获取HiveServer2的密码
        # 构建HiveServer的连接
        hiveConn = hive.Connection(host=HIVE_HOST, port=HIVE_PORT, username=HIVE_USER, auth='CUSTOM',
                                   password=HIVE_PASSWORD)
    # 异常处理
    except Exception as error:
        print(error)
    # 返回HiveServer的连接
    return hiveConn
