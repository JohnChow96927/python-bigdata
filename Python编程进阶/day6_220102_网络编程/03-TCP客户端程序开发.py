"""
TCP客户端程序开发
学习目标：理解 TCP 客户端程序的开发流程
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

# 创建客户端套接字
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# 通过客户端套接字连接服务端程序
client_socket.connect(('127.0.0.1', 8080))
# 给服务端发送消息
send_msg = input('请输入给服务端发送的消息: ')
client_socket.send(send_msg.encode())

# 接收服务端回应的消息
recv_msg = client_socket.recv(1024)  # 阻塞
print('接收到服务端响应的消息: ', recv_msg.decode())

# 关闭客户端套接字
client_socket.close()
