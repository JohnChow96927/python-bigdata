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
res = re.split(', ', my_str, maxsplit=1)  # 只分割一次
print(res)

my_str2 = '传智播客, Python; 数据分析'

res2 = re.split(r'[,;]', my_str2)
print(res2)
