#!/usr/bin/env python
# @Time : 2021/7/12 15:57
# @desc : hdfs存储数据为avro格式
__coding__ = "utf-8"
__author__ = "itcast"

from auto_create_hive_table.cn.itcast.datatohive.fileformat.TableProperties import TableProperties


class AvroTableProperties(TableProperties):
    #  Avro schema Folder存放位置
    AVSC_FOLDER = "hdfs:///data/dw/ods/one_make/avsc/"

    #  AVSC schema文件前缀
    AVSC_FILE_PREFIX = "CISS4_"

    def getStoreFmtAndProperties(self, tableName):
        return "ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'\n" + "STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'\n" + " OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'\n" + "tblproperties ('avro.schema.url'='" + self.AVSC_FOLDER + self.AVSC_FILE_PREFIX + tableName.upper() + ".avsc')\n"
