[TOC]

## Day07-HTTP协议和Web服务器

### 今日课程学习目标

```shell
知道 HTTP协议的作用及其URL地址、请求报文、响应报文的格式
理解 Web服务器的作用及其简单实现原理
常握 FastAPI框架的基本使用
```

### 今日课程内容大纲

```python
# 1. HTTP协议
	C/S架构和B/S架构
	HTTP协议
		功能简介
		URL地址
		请求报文
		响应报文
	谷歌浏览器开发者工具
# 2. Web服务器
	Web服务器简介
	简单Web服务器的实现
# 3. FastAPI框架
	框架简介
	基本使用
```

### 基础概念题

#### 1. 什么是 HTTP 协议？

参考答案：

```bash
HTTP 协议的全称是(HyperText Transfer Protocol)，翻译过来就是超文本传输协议，它规定了浏览器和 Web 服务器通信数据的格式，也就是说浏览器和 Web 服务器通信需要使用HTTP协议。
```

#### 2. URL地址的组成包括那几部分？

参考答案：

```http
URL地址详细格式：
schema：//host[:port]/path/.../[?query-string]

— schema：协议部分，常见的http和https
- host：服务器IP或域名
- port：服务器端口号，可省略，http端口默认为80，https端口默认为443
- /path/.../：访问的资源路径
- ?query-string：可选，查询参数，客户端发送给服务器的数据，也叫查询字符串
```

#### 3. HTTP请求报文和响应报文的格式？

参考答案：

```http
HTTP请求报文：请求行、请求头、空行、请求体
HTTP响应报文：响应行、响应头、空行、响应体
```

#### 4. 什么是 Web 服务器？Web服务器的作用是什么？

参考答案：

```http
Web服务器本质也是一个TCP服务器，但是它能解析HTTP请求报文，并且能组织返回响应报文。
```

### 代码练习题

#### 1. 完成课上的代码【3遍】



### Python基础题

#### 1. 要求用户输入一个不多于5位的正整数，求它是几位数

**参考答案**：

```python
num = int(input('请输入一个不多于5位的正整数：'))

# 保存 num 是几位数的结果
count = 0

# 临时变量 temp=num，下面计算 num 是几位数时，不改变 num 的值，而是使用 temp 进行计算
temp = num

while temp != 0:
    # 位数加1
    count += 1
    # temp 除以 10 取整，每循环一次去掉最后一位数字
    temp = temp // 10

print(f'{num}为{count}位数')
```

#### 2. `2/1，3/2，5/3，8/5，13/8，21/13...`求出这个数列的前20项之和

**参考答案**：

```python
# 根据题目中的数字规律，计算公式为：
# f(n)/g(n) = (f(n-1) + g(n-1))/f(n-1)

# 保存计算出的每个数字
arr = []

# 起始：fn、gn都为1
fn, gn = 1, 1

for i in range(20):
    fn, gn = fn + gn, fn
    # 将计算出的每个数添加到 arr 列表中
    arr.append(fn/gn)

# 对列表中的数字进行求和
res = sum(arr)
print('结果为：', res)
```

