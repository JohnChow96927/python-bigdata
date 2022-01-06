[TOC]

## Day09-正则表示式vs爬虫程序

### 今日课程学习目标

```shell
熟悉正则表达式的基本语法
熟悉re正则模块中常用方法是使用
常握使用正则提取指定分组的数据
理解正则中的贪婪模式和非贪婪模式
熟悉 FastAPI 提取URL地址数据
熟悉爬虫的概念和作用
```

### 今日课程内容大纲

```shell
# 1. 正则表达式
	正则表达式的作用
	正则表达式的语法
		匹配单个字符
		匹配多个字符
		正则分组
	re正则模块的使用
	贪婪模式vs非贪婪模式
# 2. 爬虫程序
	FastAPI返回图片数据
	FastAPI提取URL地址数据
	爬虫的概念和作用
	requests简单使用
```

### 基础概念题

#### 1. 什么是正则表达式？正则表达式有什么作用？

**参考答案:**

```bash
# 你的答案
正则表达式是一种字符串的匹配模式, 可以用来对字符串进行匹配, 提取, 替换等操作

作用有:
	数据的验证, 检索, 隐藏, 过滤
```

#### 2. 正则的贪婪模式和非贪婪模式是什么？

**参考答案**：

```shell
# 你的答案
贪婪模式表示正则表达式会尽可能多的去进行匹配
非贪婪模式表示正则表达式尽可能少的去匹配(匹配成功的前提下)

在量词{m, n}, ?, *, +后面加?将其变为非贪婪模式
```



#### 3. 什么是爬虫？爬虫有什么作用？

**参考答案:**

```shell
# 你的答案
爬虫是一种模拟浏览器获取网页信息的程序
其作用是进行数据采集, 在我们这行往往用于数据分析的前期准备工作
```



#### 4. 爬虫的工作流程是什么？

**参考答案:**

```bash
# 你的答案
1. 向起始的url发送请求, 并获取响应数据
2. 对响应内容进行提取
3. 若提取到url则重复1, 2步
4. 若提取到数据内容, 将数据内容进行保存
```



### 代码练习题

#### 1. 完成课上的代码【3遍】



#### 2. 正则练习-匹配手机号

提示用户输入手机号码，然后使用正则判断用户的输入是否符合手机号的格式。

**参考答案**：

```python
# 你的答案
import re

def isCellPhoneNumber() -> bool:
    mobile = input("请输入手机号: ")
    result = re.search(r'^1[3-9]\d{9}$', mobile)
    if result:
        return True
    else:
        return False
```



#### 3. 正则练习-判断全小写

提示用户输入内容，然后使用正则判断用户的输入是否是全小写字母。

**参考答案**：

```python
# 你的答案
import re

def isLowerCase() -> bool:
    content = input("请输入内容进行判断:")
    result = re.search(r'^[a-z]+$', content)
    if result:
        return True
    else:
        return False

```



#### 4. 正则练习-提取手机号

创建一个文件 stu.txt，内容如下：

```text
smart,18,13155667788
david,20,13377881010
lucy,21,15367892103
```

读取该文件的内容，使用正则从中提取出所有手机号码。

**参考答案**：

```python
# 你的答案
def getMobileNumber(filepath):
    with open(filepath, 'r', encoding='utf8') as f:
        content = f.read()
        return re.findall(r'^1[3-9]\d{9}$', content)
```



#### 5. 正则练习-分组提取数据

有字符串内容如下，使用正则从中提取出`大数据分析`文字

```python
my_str = """
    <!DOCTYPE html>
    <html> 
    <head>   
        <title>徐清风</title> 
    <head> 
    <body>   
        <h2>     
            <em>大数据分析</em>
        </h2> 
    </body>
    </html>
    """
```

**参考答案**：

```python
# 你的答案
import re

def question4():
    my_str = """
        <!DOCTYPE html>
        <html> 
        <head>   
            <title>徐清风</title> 
        <head> 
        <body>   
            <h2>     
                <em>大数据分析</em>
            </h2> 
        </body>
        </html>
        """

    # 进行字符串匹配
    re_obj = re.search(r'<em>(?P<text>.*)</em>', my_str)

    # 根据分组别名获取指定分组匹配的内容
    result = re_obj.group('text')
    print(result)
```



#### 6. 正则练习-隐藏手机号

将如下手机号的中间4位替换为 `****`

```python
my_str = '13155661013'
```

**参考答案**：

```python
# 你的答案
def question5(mobile: str) -> str:
    result = re.sub(r'(\d{3})\d{4}(\d{4})', r'\1****\2', mobile)
    return result
```
