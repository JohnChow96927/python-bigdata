#!/usr/bin/env python
# @Time : 2021/7/8 11:41
# @desc : todo 列的信息，抽象出的列对象
# @property : get属性值的方法
# @columnName.setter ： set属性值的方法
__coding__ = "utf-8"
__author__ = "itcast"


class ColumnMeta(object):

    @property
    def columnName(self):
        return self._columnName

    @columnName.setter
    def columnName(self, columnName):
        self._columnName = columnName

    @property
    def dataType(self):
        return self._dataType

    @dataType.setter
    def dataType(self, dataType):
        self._dataType = dataType

    @property
    def columnComment(self):
        return self._columnComment

    @columnComment.setter
    def columnComment(self, columnComment):
        self._columnComment = columnComment

    @property
    def dataScope(self):
        return self._dataScope

    @dataScope.setter
    def dataScope(self, dataScope):
        self._dataScope = dataScope

    @property
    def dataScale(self):
        return self._dataScale

    @dataScale.setter
    def dataScale(self, dataScale):
        self._dataScale = dataScale

    #  列的名称：columnName
    #  列的数据类型：dataType
    #  列的注释：columnComment
    #  列的范围：dataScope
    #  列的精度：dataScale
    def __init__(self, columnName, dataType, columnComment, dataScope, dataScale):
        self._columnName = columnName
        self._dataType = dataType
        self._columnComment = columnComment
        self._dataScope = dataScope
        self._dataScale = dataScale

    # overwrite toString
    def __str__(self) -> str:
        return f'ColumnMeta: columnName: {self.columnName}, dataType: {self.dataType}, ' \
               f'columnComment: {self.columnComment}, dataScope: {self.dataScope:d}, dataScale: {self.dataScale:d}'
