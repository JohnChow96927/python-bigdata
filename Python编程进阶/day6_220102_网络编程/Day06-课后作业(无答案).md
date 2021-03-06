[TOC]

## Day06-网络编程

### 今日课程学习目标

```shell
常握 网络编程的基础知识：IP、端口、TCP协议、Socket
熟悉 TCP网络程序的开发流程
```

### 今日课程内容大纲

```python
# 1. 网络编程基础知识
	IP地址
	端口和端口号
	TCP协议
	socket介绍
# 2. TCP网络程序开发 
	TCP网络程序开发流程
	TCP网络程序开发示例1：基本流程
		服务端程序
		客户端程序
	TCP网络程序开发示例2：文件传输
		服务端程序
		客户端程序
```

### 基础概念题

#### 1. 什么是IP地址？如何查看IP地址？

**参考答案:**

```bash
# 你的答案
IP地址是表示网络上唯一一台设备的一标识, ipconfig 和 ifconfig
```

#### 2. 什么是端口？什么是端口号？知名端口号和动态端口号的范围是什么？

**参考答案:**

```bash
# 你的答案
端口是用来标识连接互联网的不同应用程序的
端口号是用来区分端口的, 每台计算机都共有65536个端口号, 知名端口号是0-1023
```

#### 3. TCP 协议是什么？有什么特点？

**参考答案:**

```bash
# 你的答案
应用层传输控制协议
面向连接的
可靠性
基于字节流的
```

#### 4. 什么是socket？

**参考答案:**

```bash
# 你的答案
套接字, 是不同网络应用间建立连接的接口, 屏蔽通过TCP/IP及端口进行网络数据传输的细节
```

### 代码练习题

#### 1. 完成课上的代码【3遍】



### Python基础题

#### 1. 计算斐波那契数列的前 20 个数据

斐波那契数列指的是这样一个数列：0、1、1、2、3、5、8、13、21、34、……，即前两个数是0和1，后面的每个数都是其前两个数之和。

> 在数学上，斐波那契数列以如下被以递推的方法定义：F(0)=0，F(1)=1, F(n)=F(n - 1)+F(n - 2)（n ≥ 2，n ∈ N*）

**参考答案**：

```python
# 你的答案
def fib(n):
    if n == 1:
        return [0]
    elif n == 2:
        return [0, 1]
    else:
        result = [0, 1]
        for i in range(2, n):
            result.append(result[i - 2]+ result[i - 1])
        return result
```

#### 2. 输入一个数字，判断它是不是回文数

> 回文数：正读反读都一样的数，称为回文数，比如：1234321、123321

**参考答案**：

```python
# 你的答案
def palindrome(n: str):
    for i in range(len(n) // 2):
        if n[i] != n[-i - 1]:
            return False
    return True
```

