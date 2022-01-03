"""
re 正则模块：match、search、findall
学习目标：能够使用 re 模块中 match、search、findall 三个函数进行字符串的匹配
"""
import re

"""
match函数：re.match(pattern, string, flags=0)
功能：尝试从字符串起始位置匹配一个正则表达式
        1）如果不能从起始位置匹配成功，则返回None；
        2）如果能从起始位置匹配成功，则返回一个匹配的对象
"""

my_str = 'abc_123_DFG_456'

# 匹配字符串bc(注：从头开始)


# 匹配字符串abc(注：从头开始)


"""
search函数：re.search(pattern, string, flags=0)
功能：根据正则表达式扫描整个字符串，并返回第一个成功的匹配
        1）如果不能匹配成功，则返回None；
        2）如果能匹配成功，则返回一个匹配对象
"""

# my_str = 'abc_123_DFG_456'

# 匹配连续的3位数字


"""
findall函数：re.findall(pattern, string, flags=0)
功能：根据正则表达式扫描整个字符串，并返回所有能成功匹配的子串
        1）如果不能匹配成功，则返回一个空列表；
        2）如果能匹配成功，则返回包含所有匹配子串的列表
"""

# my_str = 'abc_123_DFG_456'

# 匹配字符串中的所有连续的3位数字

