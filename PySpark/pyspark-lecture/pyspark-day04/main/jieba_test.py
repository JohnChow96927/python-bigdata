#!/usr/bin/env python
# -*- coding: utf-8 -*-

import jieba

if __name__ == '__main__':
    """
    Jieba中文分词使用   
    """

    # 定义一个字符串
    line = '我来到北京清华大学'

    # TODO：全模式分词
    seg_list = jieba.cut(line, cut_all=True)
    print(",".join(seg_list))

    # TODO: 精确模式
    seg_list_2 = jieba.cut(line, cut_all=False)
    print(",".join(seg_list_2))

    # TODO: 搜索引擎模式
    seg_list_3 = jieba.cut_for_search(line)
    print(",".join(seg_list_3))