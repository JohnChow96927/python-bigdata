"""
文件传输-TCP 客户端程序开发
学习目标：理解文件传输-TCP 客户端程序的开发流程
"""
import socket

# 创建客户端 socket 套接字对象
# socket.AF_INET：表示 IPV4
# socket.SOCK_STREAM：表示 TCP 传输协议
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# 客户端请求和服务端程序建立连接
client.connect(('127.0.0.1', 8080))
print('客户端连接服务器成功！')

# TODO：给服务端程序发送文件数据

# 关闭客户端套接字
client.close()