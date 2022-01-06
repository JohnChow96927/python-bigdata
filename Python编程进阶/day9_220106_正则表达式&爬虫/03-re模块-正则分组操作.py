"""
re模块：正则匹配分组操作
学习目标：能够使用 re 模块进行正则匹配分组操作
"""

"""
示例1：正则匹配分组操作
语法：(正则表达式)
"""

import re

my_str = '13155667788'

# 需求：使用正则提取出手机号的前3位、中间4位以及后 4 位数据
res = re.match(r'(\d{3})(\d{4})(\d{4})', my_str)
print(type(res), res)

# 获取整个正则表达式匹配的内容
print(res.group())

# 获取正则表达式指定分组匹配的内容
# match对象.group(组号)
print(res.group(1))
print(res.group(2))
print(res.group(3))

"""
示例2：给正则分组起别名
语法：(?P<分组别名>正则表达式)
"""

my_str1 = '<div><a href="https://www.itcast.cn" target="_blank">传智播客</a><p>Python</p></div>'

# 需求：使用正则提取出 my_str1 字符串中的 `传智播客` 文本
res1 = re.search(r'<a.*>(?P<text>.*)</a>', my_str1)
print(type(res1), res1)

# 获取整个正则表达式匹配的内容
print(res1.group())

# 获取指定分组匹配到的内容
print(res1.group(1))    # 传智播客

# 根据分组的别名, 获取指定分组匹配到的内容
# Match对象.group(分组名称)
print(res1.group('text'))   # 传智播客
