"""
re模块：split函数
学习目标：能够使用 re 模块中的 split 函数进行字符串的分割操作
"""

"""
split函数：re.split(pattern, string, maxsplit=0, flags=0)
功能：根据正则表达式匹配的子串对原子符串进行分割，返回分割后的列表
"""

import re

my_str = '传智播客, Python, 数据分析'

# 需求：按照 `, ` 对上面的字符串进行分割
