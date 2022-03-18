#!/usr/bin/env python
# -*- coding: utf-8 -*-

if __name__ == '__main__':
    # 定义列表
    list = [1, 2, 3, 4, 5]
    # 定义聚合临时变量，存储聚合中间值
    tmp = 0
    # 对列表数据聚合：累加求和
    for item in list:
        tmp = tmp + item
    # 获取聚合中间值，就是聚合结果
    print(tmp)
