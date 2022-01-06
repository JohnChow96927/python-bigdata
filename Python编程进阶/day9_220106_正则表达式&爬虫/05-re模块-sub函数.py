"""
re模块：sub函数
学习目标：能够使用 re 模块中的 sub 函数进行字符串的替换
"""

"""
sub函数：re.sub(pattern, repl, string, count=0, flags=0)
功能：根据正则表达式匹配字符串中的所有子串，然后使用指定内容进行替换
    1）函数返回的是替换后的新字符串
"""

"""
示例1:
"""
import re

my_str = "传智播客-Python-666"

# 需求： 将字符串中的 - 替换成 _
new_str = re.sub(r'-', r'_', my_str, count=1)
print(new_str)

my_str2 = "传智播客,Python:666"

new_str2 = re.sub(r'[,:]', r'-', my_str2)
print(new_str2)
"""
示例2：
"""
import re

# 需求：将字符串 `abc.123` 替换为 `123.abc`
my_str3 = 'abc.123'
new_str3 = re.sub(r'([a-z]+)\.(\d+)', r'\2.\1', my_str3)
print(new_str3)
