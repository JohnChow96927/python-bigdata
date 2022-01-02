"""
recv阻塞演示-TCP 客户端程序开发
"""

"""
TCP客户端程序开发步骤：
1）创建客户端套接字对象
2）和服务端套接字建立连接
3）发送数据
4）接收数据
5）关闭客户端套接字
"""
import socket
import time

# 创建一个客户端的套接子 socket 对象
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# 通过客户端socket连接服务器
client.connect(('127.0.0.1', 8080))

# 服务端recv解阻塞情况1：给服务器发送一个消息
# time.sleep(10)
send_msg = 'hello!'
client.send(send_msg.encode())

# 服务端recv解阻塞情况2：客户端关闭输出流
# client.shutdown(socket.SHUT_WR)

# 服务端recv解阻塞情况3：关闭客户端的套接字对象
# time.sleep(10)
client.close()
