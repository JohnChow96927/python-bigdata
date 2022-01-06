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


# my_str1 = 'aabb\nbbcc'


# my_str1 = '\nabc'
