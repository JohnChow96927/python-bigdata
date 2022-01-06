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

my_str1 = 'abc_123_DFG_456'

# 匹配字符串bc(注：从头开始)
res1 = re.match(r'[a-z]{1,3}', my_str1)
print(res1.group())  # None, 因为match从头开始匹配

# 匹配字符串abc(注：从头开始)
res2 = re.match(r'abc', my_str1)
# 匹配成功返回一个Match对象

print("=" * 20)
"""
search函数：re.search(pattern, string, flags=0)
功能：根据正则表达式扫描整个字符串，并返回第一个成功的匹配
        1）如果不能匹配成功，则返回None；
        2）如果能匹配成功，则返回一个匹配对象
"""

my_str2 = 'abc_123_DFG_456'

# 匹配连续的3位数字
print(re.search(r'\d{3}', my_str2).group())
print("=" * 20)
"""
findall函数：re.findall(pattern, string, flags=0)
功能：根据正则表达式扫描整个字符串，并返回所有能成功匹配的子串
        1）如果不能匹配成功，则返回一个空列表；
        2）如果能匹配成功，则返回包含所有匹配子串的列表
"""

my_str3 = 'abc_123_DFG_456'

# 匹配字符串中的所有连续的3位数字
print(re.findall(r'\d{3}', my_str3))
