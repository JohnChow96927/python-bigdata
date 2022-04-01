#!/usr/bin/env python
# @desc : todo 常量定义公共对象,固定不变的一些值对应的变量，例如数据库名称、数据格式等
__coding__ = "utf-8"
__author__ = "itcast"

from auto_create_hive_table.cn.itcast.datatohive.fileformat.AvroTableProperties import AvroTableProperties
from auto_create_hive_table.cn.itcast.datatohive.fileformat.OrcSnappyTableProperties import OrcSnappyTableProperties
from auto_create_hive_table.cn.itcast.datatohive.fileformat.OrcTableProperties import OrcTableProperties

# 数据库名常量
ODS_NAME = 'one_make_ods'
DWD_NAME = 'one_make_dwd'

# ODS层全量增量路径名
FULL_IMP = 'full_imp'
INCR_IMP = 'incr_imp'

# 数据库名 → 分层文件夹名
# python基础语法中的map集合
DBNAME_FOLDER_MAPPING = {ODS_NAME: 'ods', DWD_NAME: 'dwd'}
# 位置的文件夹
UNKOWN_TEXT = 'unknown'
# 分层数据库文件存储格式映射
DBNAME_FMT_MAPPING = {ODS_NAME: 'avro', DWD_NAME: 'orc'}
# 表存储属性和压缩属性
TBL_STORE_PROP = {'orc': OrcTableProperties(), 'orc_snappy': OrcSnappyTableProperties(), 'avro': AvroTableProperties()}
# // 分层数据库与用户名属性映射
DBNAME_USERNAME_MAPPING = {ODS_NAME: 'ciss4.', DWD_NAME: ''}


# 根据数据库名对应获取指定的文件夹名
def getDBFolderName(dbName) -> str:
    if dbName in DBNAME_FOLDER_MAPPING.keys():
        return DBNAME_FOLDER_MAPPING.get(dbName)
    else:
        return UNKOWN_TEXT


# 根据数据库名获取HDFS中的位置，如果db是ods按照dynamicDir设置目录，如果db是dwd无需设置额外的路径，否则，放入到unknown目录
def getDynamicDir(dbName: str, dynamicDir):
    if dbName.__contains__('ods'):
        return dynamicDir
    elif dbName.__contains__('dwd'):
        return ''
    else:
        return UNKOWN_TEXT


# 根据数据库名和表名获取表存储属性
def getTableProperties(dbName, tableName):
    # 根据数据库获取是哪种存储格式
    fmtName = DBNAME_FMT_MAPPING.get(dbName)
    # 获取对应格式的类的对象
    tableProperties = TBL_STORE_PROP.get(fmtName)
    # 返回这种格式对应的建表语句的属性
    return tableProperties.getStoreFmtAndProperties(tableName)


# 根据数据库名得到HDFS文件的前缀，ods层的为ciss4.，dwd层为空
def getUserNameByDBName(dbName):
    if dbName in DBNAME_USERNAME_MAPPING.keys():
        return DBNAME_USERNAME_MAPPING.get(dbName)
    else:
        return UNKOWN_TEXT
