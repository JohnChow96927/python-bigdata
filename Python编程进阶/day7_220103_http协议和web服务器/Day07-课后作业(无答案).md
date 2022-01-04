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
# 你的答案
HyperText Transfer Protocol: 超文本传输协议
是浏览器和web服务器通信使用的协议, 规定了浏览器和Web服务器通信数据的格式
```

#### 2. URL地址的组成包括那几部分？

参考答案：

```bash
# 你的答案
协议名, 域名, 服务器端口号(可省略), 资源路径, 查询参数
```

#### 3. HTTP请求报文和响应报文的格式？

参考答案：

```bash
# 你的答案
请求报文: 请求行, 请求头, 空行, 请求体
响应报文: 响应行, 响应头, 空行, 响应体
```

#### 4. 什么是 Web 服务器？Web服务器的作用是什么？

参考答案：

```bash
# 你的答案
Web服务器本质是一个TCP服务器, 其可以解析HTTP请求报文并组织返回响应报文
```

### 代码练习题

#### 1. 完成课上的代码【3遍】



### Python基础题

#### 1. 要求用户输入一个不多于5位的正整数，求它是几位数

**参考答案**：

```python
# 你的答案
def fun(n):
    temp = n
    result = 0
    while temp != 0:
        result += 1
        temp = temp // 10
    return result
```

#### 2. `2/1，3/2，5/3，8/5，13/8，21/13...`求出这个数列的前20项之和

**参考答案**：

```python
# 你的答案
def sum_fun(n):
    up = [2, 3]
    down = [1, 2]
    if n == 1:
        return 2/1
    elif n == 2:
        return 2/1 + 3/2
    else:
        result = 3.5
        for i in range(2, n):
            up.append(up[i - 2] + up[i - 1])
            down.append(down[i - 2] + down[i - 1])
            
            result += up[i] / down[i]
        return result
```
