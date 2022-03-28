#!/usr/bin/env python
# @desc : todo 查询oracle一张表的元数据信息，封装为TableMeta对象
__coding__ = "utf-8"
__author__ = "itcast"

import logging
import cx_Oracle
# 列的信息对象
from auto_create_hive_table.cn.itcast.entity.ColumnMeta import ColumnMeta
# 表的信息对象
from auto_create_hive_table.cn.itcast.entity.TableMeta import TableMeta

def getTableMeta(oracleConn, tableName) -> TableMeta:
    """
    用于读取Oracle中表的信息【表名、列的信息、表的注释】封装成TableMeta
    :param oracleConn: Oracle连接对象
    :param tableName: 表的名称
    :return:
    """
    # 从连接中获取一个游标【SQL对象】
    cursor = oracleConn.cursor()
    try:
        # 定义Oracle查询表信息的SQL语句
        oracleSql = f"""select columnName, dataType, dataScale, dataPercision, columnComment, tableComment from
(select column_name columnName,data_type dataType, DATA_SCALE dataScale,DATA_PRECISION dataPercision, TABLE_NAME
from all_tab_cols where '{tableName}' = table_name) t1
left join (select comments tableComment,TABLE_NAME from all_tab_comments WHERE '{tableName}' = TABLE_NAME) t2 on t1.TABLE_NAME = t2.TABLE_NAME
left join (select comments columnComment, COLUMN_NAME from all_col_comments WHERE TABLE_NAME='{tableName}') t3 on t1.columnName = t3.COLUMN_NAME
"""
        # 记录运行的SQL语句
        logging.warning(f'query oracle table {tableName} metadata sql:\n{oracleSql}')
        # 执行SQL语句
        cursor.execute(oracleSql)
        # 获取执行的结果
        resultSet = cursor.fetchall()
        # 构建返回的表的信息对象：表名 + 列的信息 + 表的注释
        tableMeta = TableMeta(f'{tableName}', '')
        for line in resultSet:
            # 获取每一列的信息
            columnName = line[0]        # 获取列的名称
            dataType = line[1]          # 获取列的类型
            dataScale = line[2]         # 获取列值长度
            dataScope = line[3]         # 获取列值精度
            columnComment = line[4]     # 获取列的注释
            tableComment = line[5]      # 获取表的注释
            if dataScale is None:       # 如果列值的长度为空，则设置为0
                dataScale = 0
            if dataScope is None:       # 如果列值的精度为空，则设置为0
                dataScope = 0
            # 将每条数据封装成一个列的信息对象【列名 + 类型 + 长度 + 精度 + 注释】
            columnMeta = ColumnMeta(columnName, dataType, columnComment, dataScope, dataScale)
            # 将列的信息添加到表的对象中
            tableMeta.addColumnMeta(columnMeta)
            # 将表的注释添加到表的对象中
            tableMeta.tableComment = tableComment
        # 返回当前表的所有信息【表名 + 所有列的信息 + 表的注释】
        return tableMeta
    # 异常处理
    except cx_Oracle.Error as error:
        print(error)
    # 关闭游标
    finally:
        if cursor:
            cursor.close()
