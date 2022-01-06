[TOC]

# 正则表达式&爬虫程序

## I. 正则表达式

1. ### 正则表达式的作用

    ##### 正则表达式(Regular Expression)描述了一种字符串匹配的模式, 可以用来检查有一个串是否有某种子串, 将匹配的子串做替换或者从某个串中取出符合某个条件的字串等

    功能:

    - 数据验证(表单验证: 如手机, 邮箱, IP地址格式验证)
    - 数据检索(数据检索, 数据抓取)
    - 数据隐藏(`132****5776` 周先生)
    - 数据过滤(论坛敏感关键词过滤)

    > ##### 正则表达式并不是Python特有的, 其他语言也可能支持正则表达式

2. ### 正则表达式的语法

    - ##### 在线练习网址: https://tool.oschina.net/regex

    - ##### 匹配单个字符:

        - 单个字符本身
        - `.`: 匹配任意1个字符(除了\n), 匹配`.`则用`\.`
        - `[]`: 匹配[]中列举的字符
        - `\d`: 匹配数字
        - `\D`: 匹配非数字
        - `\s`: 匹配空白(空格, tab等)
        - `\S`: 匹配非空白
        - `\w`: 匹配非特殊字符(字母, 数字)
        - `\W`: 匹配特殊字符

    - ##### 匹配多个字符(连续匹配):

        - `*`: 匹配前一个字符出现0次或无限次
        - `+`: 匹配前一个字符出现1次或无限次
        - `?`: 匹配前一个字符出现1次或0次, 即要么有1次, 要么没有

        - `{m}`: 匹配前一个字符出现m次
        - `{m, n}`: 匹配前一个字符出现从m到n次

    - ##### 匹配开头结尾vs其他匹配

        - `^`: 匹配字符串开头
        - `$`: 匹配字符串结尾
        - `[^指定字符]`: 匹配**除了**指定字符以外的所有字符
        - `|`: 匹配左右任意一个表达式

3. ### re正则模块的使用

    re: regex模块

    r-string: raw string原生字符串

    - match方法的使用

    ```python
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
    res1 = re.match('bc', my_str1)
    print(res1)  # None, 因为match从头开始匹配
    
    # 匹配字符串abc(注：从头开始)
    res2 = re.match('abc', my_str1)
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
    print(re.search('\d{3}', my_str2).group())
    print("=" * 20)
    """
    findall函数：re.findall(pattern, string, flags=0)
    功能：根据正则表达式扫描整个字符串，并返回所有能成功匹配的子串
            1）如果不能匹配成功，则返回一个空列表；
            2）如果能匹配成功，则返回包含所有匹配子串的列表
    """
    
    my_str3 = 'abc_123_DFG_456'
    
    # 匹配字符串中的所有连续的3位数字
    print(re.findall('\d{3}', my_str3))
    ```

    - split函数

    ```python
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
    
    res2 = re.split('[,;]', my_str2)
    print(res2)
    ```

    - 正则匹配分组操作

    ```python
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
    ```

    - 引用正则分组

    ```python
    """
    re模块：引用正则分组
    学习目标：能够在正则匹配时使用分组序号或分组名称引用分组内容
    """
    
    """
    需求：写一个正则表达式，匹配字符串形如：'xxx xxx xxx'
    注意：xxx可以是任意多位的数字，但是这三个xxx必须一致，比如：'123 123 123'
    """
    
    """
    引用正则分组的方式：
    1）\num：引用正则中第 num 个分组匹配到的字符串<br/>例如：`\1`表示第一个分组，`\2`表示第二个分组...
    2）(?P=name)：引用正则中别名为 name 分组匹配到的字符串
    """
    import re
    
    my_str = '123 123 123'
    
    res = re.match(r'(?P<num>\d+)\s(?P=num)\s\1', my_str)
    print(res)
    
    print(res.group(1))
    ```

    - sub方法

    ```python
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
    ```

    - 正则表达式修饰符

    ```python
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
    ```

4. ### 贪婪模式vs非贪婪模式

    - #### 贪婪模式: 在整个表达式匹配成功的前提下, 尽可能多的匹配

    - #### 非贪婪模式: 在整个表达式匹配成功的前提下, 尽可能少的匹配

        > ##### 正则中的量词包括: `{m, n}`, `?`, `*`和`+`, 这些量词默认都是贪婪模式的匹配, 可以在这些量词后面加`?`将其变为非贪婪模式.

    ```python
    """
    贪婪模式和非贪婪模式
    学习目标：知道正则中贪婪模式和非贪婪模式的区别
    """
    
    """
    贪婪模式：在整个表达式匹配成功的前提下，尽可能多的匹配
    非贪婪模式：在整个表达式匹配成功的前提下，尽可能少的匹配
    正则中的量词包括：{m,n}、?、*和+，这些量词默认都是贪婪模式的匹配，可以在这些量词后面加?将其变为非贪婪模式。
    """
    
    import re
    
    my_str = '<div>test1</div><div>test2</div>'
    
    # 贪婪模式：在整个表达式匹配成功的前提下，尽可能多的匹配
    re_obj_greedy = re.match('<div>.*</div>', my_str)
    print(re_obj_greedy)
    print(re_obj_greedy.group())  # 获取整个正则表达式匹配的内容
    
    # 非贪婪模式：在整个表达式匹配成功的前提下，尽可能少的匹配
    re_obj_not_greedy = re.match('<div>.*?</div>', my_str)
    print(re_obj_not_greedy)
    print(re_obj_not_greedy.group())  # 获取整个正则表达式匹配的内容
    ```

## II. 爬虫程序

1. ### 爬虫工作的流程

    ![爬虫工作的流程](爬虫工作的流程.png)

2. ### FastAPI返回图片数据

3. ### FastAPI提取URL地址数据

4. ### 爬虫的概念和作用

5. ### requests的简单使用