#!/usr/bin/env python
# @desc : TODO 根据动态表，动态创建hive分区
__coding__ = "utf-8"
__author__ = "itcast"

from auto_create_hive_table.cn.itcast.datatohive import CreateMetaCommon
import logging


class CreateHiveTablePartition(object):

    def __init__(self, hiveConn):
        self.hiveConn = hiveConn

    def executeCPartition(self, dbName, hiveTName, dynamicDir, partitionDT):
        """
        用于实现给Hive表的数据手动申明分区
        :param dbName: 数据库名称
        :param hiveTName: 表名称
        :param dynamicDir: 全量或者增量
        :param partitionDT: 分区值
        :return: None
        """
        # 构建一个空列表，准备拼接字符串
        buffer = []
        # 构建一个Hive的游标，准备执行SQL语句
        cursor = None
        try:
            # 指定修改的数据库名
            buffer.append("alter table " + dbName + ".")
            # 指定修改的表名
            buffer.append(hiveTName)
            # 指定修改操作为添加分区
            buffer.append(" add if not exists partition (dt='")
            # 指定分区的具体值
            buffer.append(partitionDT)
            # 声明分区对应的HDFS目录
            buffer.append("') location '/data/dw/" + CreateMetaCommon.getDBFolderName(dbName) +
                          "/one_make/" + CreateMetaCommon.getDynamicDir(dbName, dynamicDir) + "/ciss4.")
            buffer.append(hiveTName)
            buffer.append("/")
            buffer.append(partitionDT)
            buffer.append("'")
            # 构建实际的游标对象
            cursor = self.hiveConn.cursor()
            # 通过游标执行SQL语句
            cursor.execute(''.join(buffer))
            # 输出日志
            logging.warning(f'执行创建hive\t{hiveTName}表的分区：{partitionDT},\t分区sql:\n{"".join(buffer)}')
        # 异常处理
        except Exception as e:
            print(e)
        # 释放游标
        finally:
            if cursor:
                cursor.close()
