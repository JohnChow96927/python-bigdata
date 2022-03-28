#!/usr/bin/env python
# @Time : 2021/7/8 12:38
# @desc : 表对应元数据对象
__coding__ = "utf-8"
__author__ = "itcast"

from auto_create_hive_table.cn.itcast.entity.ColumnMeta import ColumnMeta


class TableMeta(object):

    @property
    def tableName(self):
        return self._tableName

    @tableName.setter
    def tableName(self, tableName):
        self._tableName = tableName

    @property
    def tableComment(self):
        return self._tableComment

    @tableComment.setter
    def tableComment(self, tableComment):
        self._tableComment = tableComment

    @property
    def columnMetaList(self):
        return self._columnMetaList

    # 给列的集合添加元素, 往columnMetaList中添加ColumnMeta对象
    def addColumnMeta(self, columnMeta):
        self._columnMetaList.append(columnMeta)

    # 根据列的名称，得到列的元数据信息
    def getColumnMeta(self, columnName):
        for columnMeta in self.columnMetaList:
            if columnName.__eq__(columnMeta.columnName):
                return columnMeta

    # 得到该表下面的所有的列的名
    def getColumnNameList(self):
        columnNameList = []
        for cm in self.columnMetaList:
            columnNameList.append(cm.columnName)
        return columnNameList

    # 初始化列集合信息
    def __init__(self, tableName, tableComment):
        self._tableName = tableName
        self._tableComment = tableComment
        self._columnMetaList: [ColumnMeta] = list()

    # overwrite toString
    def __str__(self) -> str:
        # cmList = '\n'
        # for cm in self.columnMetaList:
        #     cmList += str(cm) + '\n'
        # [] -> 把中括号中的内容变成集合 ；for cm in self.columnMetaList -> 得到一个个ColumnMeta对象； str(cm) -> 把ColumnMeta对象，调用ColumnMeta对象__str__方法，转换成一个字符串
        return f'TableMeta:\n tableName: {self.tableName}, tableComment: {self.tableComment}, \n' \
               f'columnMetaList:\n {[str(cm) for cm in self.columnMetaList]}'
