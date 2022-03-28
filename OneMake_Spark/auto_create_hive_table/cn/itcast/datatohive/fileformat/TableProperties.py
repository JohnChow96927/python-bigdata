#!/usr/bin/env python
# @desc : 创建表的属性
__coding__ = "utf-8"
__author__ = "itcast"

# python中，定义抽象类的语法，需要引入abc包，导入两个abstractmethod、ABCMeta对象
from abc import abstractmethod, ABCMeta


class TableProperties(object):
    __metaclass__ = ABCMeta

    #  获取建表格式与表配置属性
    @abstractmethod
    def getStoreFmtAndProperties(self, tableName):
        pass
