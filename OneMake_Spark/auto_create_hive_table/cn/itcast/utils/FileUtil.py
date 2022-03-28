#!/usr/bin/env python
# @desc : todo 实现读取表名文件
__coding__ = "utf-8"
__author__ = "itcast"


def readFileContent(fileName):
    """
    加载表名所在的文件
    :param fileName:存有表名的文件路径
    :return:存有所有表名的列表集合
    """
    # 初始化一个空列表
    tableNameList = []
    # 读取文件
    fr = open(fileName)
    # 循环读取文件中的表名
    for line in fr.readlines():
        # 替换读取每一行文件的默认字符:'\n'
        curLine = line.rstrip('\n')
        # 将每一行的表名放入列表
        tableNameList.append(curLine)
    # 返回表名
    return tableNameList
