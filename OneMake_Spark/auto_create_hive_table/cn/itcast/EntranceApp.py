#!/usr/bin/env python
# @desc : todo ODS&DWD建库、建表、装载数据主类
__coding__ = "utf-8"
__author__ = "itcast"

# 导入读Oracle表、建Hive表的包
from auto_create_hive_table.cn.itcast.datatohive import CHiveTableFromOracleTable, CreateMetaCommon, CreateHiveTablePartition, LoadData2DWD
# 导入工具类：连接Oracle工具类、文件工具类、表名构建工具类
from auto_create_hive_table.cn.itcast.utils import OracleHiveUtil, FileUtil, TableNameUtil
# 导入日志工具包
from auto_create_hive_table.config import common

# 根据不同功能接口记录不同的日志
admin_logger = common.get_logger('itcast')


def recordLog(modelName):
    """
    记录普通级别日志
    :param modelName: 模块名称
    :return: 日志信息
    """
    msg = f'{modelName}'
    admin_logger.info(msg)
    return msg


def recordWarnLog(msg):
    """
    记录警告级别日志
    :param msg: 日志信息
    :return: 日志信息
    """
    admin_logger.warning(msg)
    return msg


if __name__ == '__main__':

    # =================================todo: 1-初始化Oracle、Hive连接，读取表的名称=========================#
    # 输出信息
    recordLog('ODS&DWD Building AND Load Data')
    # 分区常量
    partitionVal = '20210101'
    # 调用工具类获得oracle连接
    oracleConn = OracleHiveUtil.getOracleConn()
    # 调用工具类获取Hive连接
    hiveConn = OracleHiveUtil.getSparkHiveConn()
    # 读取文件，获取所有表的名字，放入一个列表中
    tableList = FileUtil.readFileContent("C:\\GitHub Desktop\\ITheima_python_bigdata\\OneMake_Spark\\dw\\ods\\meta_data\\tablenames.txt")
    # 获取所有ODS层的表名，区分全量表与增量表：List[全量表名List，增量表名List]
    tableNameList = TableNameUtil.getODSTableNameList(tableList)
    # ------------------测试：输出获取到的连接以及所有表名
    # print(oracleConn)
    # print(hiveConn)
    # for tbnames in tableNameList:
    #     print("---------------------")
    #     for tbname in tbnames:
    #         print(tbname)

    # =================================todo: 2-ODS层建库=============================================#
    # 使用Oracle连接以及Hive的连接，构建一个HiveSQL的操作对象
    cHiveTableFromOracleTable = CHiveTableFromOracleTable(oracleConn, hiveConn)
    # 打印日志
    recordLog('ODS层创建数据库')
    # 调用Hive操作对象的方法，实现创建ODS层数据
    cHiveTableFromOracleTable.executeCreateDbHQL(CreateMetaCommon.ODS_NAME)

    # =================================todo: 3-ODS层建表=============================================#
    # 打印日志
    recordLog('ODS层创建全量表...')
    # 获取所有全量表的表名列表
    fullTableList = tableNameList[0]
    # 取出每个全量表的表名
    for tblName in fullTableList:
        # Hive中创建这张全量表：数据库名称、表名、表的类型
        cHiveTableFromOracleTable.executeCreateTableHQL(CreateMetaCommon.ODS_NAME, tblName, CreateMetaCommon.FULL_IMP)
    # 打印日志
    recordLog('ODS层创建增量表...')
    # 获取所有增量表的表名列表
    incrTableList = tableNameList[1]
    # 取出每个增量表的表名
    for tblName in incrTableList:
        # Hive中创建这张增量表：数据库名称、表名、表的类型
        cHiveTableFromOracleTable.executeCreateTableHQL(CreateMetaCommon.ODS_NAME, tblName, CreateMetaCommon.INCR_IMP)

    # =================================todo: 4-ODS层申明分区=============================================#
    recordLog('创建ods层全量表分区...')
    createHiveTablePartition = CreateHiveTablePartition(hiveConn)
    # 全量表执行44次创建分区操作
    for tblName in fullTableList:
        createHiveTablePartition.executeCPartition(CreateMetaCommon.ODS_NAME, tblName, CreateMetaCommon.FULL_IMP, partitionVal)

    recordLog('创建ods层增量表分区...')
    # 增量表执行57次创建分区操作
    for tblName in incrTableList:
        createHiveTablePartition.executeCPartition(CreateMetaCommon.ODS_NAME, tblName, CreateMetaCommon.INCR_IMP, partitionVal)

    # # =================================todo: 5-DWD层建库建表=============================================#
    # # 5.1 建库记录日志
    # recordLog('DWD层创建数据库')
    # # 创建DWD层数据库
    # cHiveTableFromOracleTable.executeCreateDbHQL(CreateMetaCommon.DWD_NAME)
    #
    # # 5.2 建表记录日志
    # recordLog('DWD层创建表...')
    # # dwd层创建表是不需要分全量和增量，需求：把全量和增量表名合并为一个集合
    # allTableName = [i for j in tableNameList for i in j]
    # # 取出每张表的表名
    # for tblName in allTableName:
    #     # 在DWD层创建每张表
    #     cHiveTableFromOracleTable.executeCreateTableHQL(CreateMetaCommon.DWD_NAME, tblName, None)
    #
    # # =================================todo: 6-DWD层数据抽取=============================================#
    # # 记录日志
    # recordWarnLog('DWD层加载数据，此操作将启动Spark JOB执行，请稍后...')
    # # 取出每张表名
    # for tblName in allTableName:
    #     recordLog(f'加载dwd层数据到{tblName}表...')
    #     try:
    #         # 抽取ODS层表的数据到DWD层
    #         LoadData2DWD.loadTable(oracleConn, hiveConn, tblName, partitionVal)
    #     #异常处理
    #     except Exception as error:
    #         print(error)
    #     recordLog('完成!!!')

# =================================todo: 7-程序结束，释放资源=============================================#
oracleConn.close()
hiveConn.close()
