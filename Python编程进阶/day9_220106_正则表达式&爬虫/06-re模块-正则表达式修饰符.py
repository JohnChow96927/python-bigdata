"""
正则表达式修饰符
学习目标：知道re.I、re.M、re.S三个正则表示式修饰符的作用
"""

"""
re.I：匹配时不区分大小写
re.M：多行匹配，影响 ^ 和 $
re.S：影响 . 符号，设置之后，.符号就能匹配\n了
"""

import re

my_str = 'aB'
res = re.match(r'ab', my_str, flags=re.I)   # re.I: 匹配时不区分字母的大小写
print(res.group())

my_str2 = 'aabb\nbbcc'
res2 = re.search(r'^[a-z]{4}$', my_str2, flags=re.M)    # 多行匹配, 影响^和$

print(bool(res2))
print(res2.group())

my_str3 = '\nabc'
res3 = re.match(r'.', my_str3, flags=re.S)  # re.S使`.`能够匹配\n
print(bool(res))
print(res3.group())
