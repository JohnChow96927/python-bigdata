#!/usr/bin/env python
# @desc : todo 用户将所有表名进行划分，构建全量列表和增量列表
__coding__ = "utf-8"
__author__ = "itcast"


def getODSTableNameList(fileNameList):
    """
    基于传递的所有表名，将增量表与全量表进行划分到不同的列表中
    :param fileNameList: 所有表名的列表
    :return: 增量与全量列表
    """
    # 初始化全量表集合
    full_list = []
    # 初始化增量表集合
    incr_list = []
    # 构建返回的列表，用于存放全量列表和增量列表
    result_list = []
    # 初始化一个bool变量，文件前半部分@符号之前的全部为全量表，默认为true，表示是全量
    isFull = True
    # 读取列表中每张表的名字
    for line in fileNameList:
        # 是否为全量表
        if isFull:
            # 如果当前的符号是@,表示全量表已结束
            if "@".__eq__(line):
                # 更改标志为false，不再放入全量列表
                isFull = False
                # 本次不做操作，继续下一条
                continue
            # 为全量表，就放入全量列表
            full_list.append(line)
        # 不是全量表
        else:
            # 将表名放入增量列表
            incr_list.append(line)
    # 将全量列表放入结果列表
    result_list.append(full_list)
    # 将增量列表放入结果列表
    result_list.append(incr_list)
    # 返回结果列表
    return result_list