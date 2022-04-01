#!/usr/bin/env python
# @desc : todo 功能一：创建ODS层数据库。功能二：从oracle中获得表结构，在hive中创建对应表。
__coding__ = "utf-8"
__author__ = "itcast"

# 导包
from pyhive import hive  # 导入Hive操作包
from auto_create_hive_table.cn.itcast.datatohive import CreateMetaCommon  # 导入常量数据包
from auto_create_hive_table.cn.itcast.utils import OracleMetaUtil  # 导入Oracle表信息的工具类
import logging  # 导入日志记录包


class CHiveTableFromOracleTable:

    # 构建当前类的对象时,初始化Oracle和Hive的连接
    def __init__(self, oracleConn, hiveConn):
        self.oracleConn = oracleConn
        self.hiveConn = hiveConn

    # 创建数据库方法
    def executeCreateDbHQL(self, dbName):
        """
        根据传递的数据库名称，在Hive中创建数据库
        :param dbName: 数据库名称
        :return: None
        """
        # 拼接创建数据库的SQL语句
        createDbHQL = 'create database if not exists ' + dbName
        # 从连接中获取游标实际的SQL对象
        cursor = self.hiveConn.cursor()
        try:
            # SQL对象执行SQL语句
            cursor.execute(createDbHQL)
        # 异常处理
        except hive.Error as error:
            print(error)
        # 执行结束，最后释放游标
        finally:
            if cursor:
                cursor.close()

    # 执行Hive建表
    def executeCreateTableHQL(self, dbName, tableName, dynamicDir):
        """
        用于根据传递的数据库名称、表名在Hive中创建对应的表，self为当前类的实例对象
        :param dbName: 数据库名称【ODS、DWD】
        :param tableName: 表名
        :param dynamicDir: 全量或者增量【full_imp、incr_imp】
        :return: None
        """
        # 准备一个空的列表，用于拼接HiveSQL的建表的语句
        buffer = []
        # 准备一个游标【SQL对象】，用于执行SQL语句
        cursor = None
        try:
            # 从Oracle中获取这张表的Schema：表的信息【表名、注释】、列的信息【列名、类型、注释】
            tableMeta = OracleMetaUtil.getTableMeta(self.oracleConn, tableName.upper())
            # 通过Oracle中获取的表的信息，拼接HiveSQL的建表语句
            buffer.append("create external table if not exists " + dbName + ".")  # 指定基本语法和数据库名称
            buffer.append(tableName.lower())  # 将表名转换为小写
            # 添加列的信息：只有DWD层才有列的信息，ODS层通过avsc文件加载
            buffer = getODSStringBuffer(buffer, dbName, tableMeta)
            if tableMeta.tableComment:  # 如果表的注释不为空
                buffer.append(" comment '" + tableMeta.tableComment + "' \n")  # 添加表的注释
            buffer.append(' partitioned by (dt string) ')  # 添加分区字段为dt，String类型
            # 根据数据库名称和表名获取表的配置属性：ODS=>AVRO或者DWD=>ORC的配置
            buffer.append(CreateMetaCommon.getTableProperties(dbName, tableName))
            # 根据数据库名称，指定这张表属于ODS层还是DWD层
            dbFolderName = CreateMetaCommon.getDBFolderName(dbName)
            # 根据数据库名称，获取Oracle数据库名称
            userName = CreateMetaCommon.getUserNameByDBName(dbName)
            # 指定该表在HDFS上的映射地址:/data/dw/层次/one_make/全量/用户名表名
            buffer.append(" location '/data/dw/" + dbFolderName + "/one_make/" + CreateMetaCommon.getDynamicDir(dbName,
                                                                                                                dynamicDir) + "/" + userName + tableName + "'")
            # 获取HiveSQL执行的游标
            cursor = self.hiveConn.cursor()
            # 把拼接的列表转换为一个字符串，然后执行该SQL
            cursor.execute(''.join(buffer))
            # 输出执行的Hive SQ
            logging.warning(f'oracle表转换{dbFolderName}后的Hive DDL语句为:\n{"".join(buffer)}')
        # 异常处理
        except Exception as exception:
            print(exception)
        # 释放游标
        finally:
            if cursor:
                cursor.close()


# 根据数据库得到部分建表语句，ODS 与 DWD差别部分处理
def getODSStringBuffer(buffer, dbName, tableMeta):
    """
    用于实现将Oracle的列的信息，解析为Hive的列的信息，实现类型转换等
    :param buffer: 当前拼接的建表语句
    :param dbName: 当前数据库名称
    :param tableMeta: 当前表的信息
    :return: None
    """
    # 根据数据库名称获取当前表属于ODS还是DWD，不同层次的配置不一样
    simpleName = CreateMetaCommon.getDBFolderName(dbName)
    # 如果不是ODS层
    if not 'ods'.__eq__(simpleName):
        # 添加一个换行
        buffer.append('(\n\t')
        # 获取每一列的信息
        for cmeta in tableMeta.columnMetaList:
            # 将Oracle的类型转换为Hive的类型：timestamp => long , number => bigint | dicimal ,other => String
            hiveDataType = convertDataType(cmeta.dataType, cmeta.dataScale, cmeta.dataScope)
            # 添加列的名称
            buffer.append(cmeta.columnName)
            # 添加空格
            buffer.append(' ')
            # 添加列的类型
            buffer.append(hiveDataType)
            # 如果该列有注释，则添加注释
            if cmeta.columnComment:
                buffer.append(" comment '")
                buffer.append(cmeta.columnComment)
                buffer.append("'")
            # 在列的定义后加上逗号
            buffer.append(',\n\t')
        # 循环结束后，把最后一列的那个逗号删除
        buffer.pop(-1)
        # 添加最后的括号
        buffer.append('\n)')
    # 返回列的定义
    return buffer


def convertDataType(oracleDType: str, dataScale, dataScope):
    """
    将Oracle中列的类型转换为Hive中的数据类型
    :param oracleDType: 列的类型
    :param dataScale: 列的长度
    :param dataScope: 列的精度
    :return:
    """
    # 字段名称和字段类型不为空
    if oracleDType:
        # 如果Oracle中为timestamp，返回long类型,注意:long类型Hive不支持，SparkSQL支持
        if oracleDType.startswith('TIMESTAMP'):
            return 'long'
        # 如果Oracle中为数值类型
        elif equalsIgnoreCase('NUMBER', oracleDType):
            # 如果长度为None或者长度小于1
            if dataScale is None or dataScale < 1:
                # 整数类型，返回bigint
                return 'bigint'
            # 为数值，但是有小数点
            else:
                # 返回dicimal类型
                return f'decimal({dataScope}, {dataScale})'
        # 其他类型全部返回String类型
        else:
            return 'string'
    else:
        print('未获取到字段对应类型')


def equalsIgnoreCase(a, b):
    """
    比较两个字符串，并不区分大小写
    """
    if isinstance(a, str):
        if isinstance(b, str):
            return len(a) == len(b) and a.upper() == b.upper()
    return False
