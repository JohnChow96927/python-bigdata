"""
文件传输-TCP 服务端程序开发
学习目标：理解文件传输-TCP 服务端程序的开发流程
"""

import socket

# 创建服务端监听套接字
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# 监听套接字绑定地址和端口
server.bind(('127.0.0.1', 8080))

# 监听套接字开始监听，准备接收客户端的连接请求
server.listen(127)
print('服务器开始监听...')

# 接收客户端的连接请求
# service_client：专门和客户端通信的套接字
# ip_port：客户端的 IP 地址和端口号
service_client, ip_port = server.accept()
print(f'服务器接收到来自{ip_port}的请求')

# TODO：接收客户端发送的文件数据并保存到本地
# 创建文件操作对象
file = open('./dest/小电影.mp4', 'wb')
# 循环接收来自客户端的数据, 并将M诶次接收的文件数据写入到文件中
while True:
    # 接收来自于客户端发送的文件数据, 每次最多接收1024个bytes
    # 当recv返回的data是'', 表示接收结束
    data = service_client.recv(1024)
    # 如果接收完成, 结束循环
    if len(data) == 0:
        break
    # 将接收的数据写入到文件中
    file.write(data)
file.close()
print("文件传输完成!")


# 关闭和客户端通信的套接字
service_client.close()
# 关闭服务器监听套接字
server.close()
