"""
简单Web服务器-返回固定html内容
学习目标：能够实现Web服务器给浏览器返回固定html内容
"""

import socket

# 创建一个服务端监听套接字socket对象
# socket.AF_INET：表示使用 IPV4 地址
# socket.SOCK_STREAM：表示使用 TCP 协议
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  # 门迎
# 设置端口重用，服务器程序关闭之后，端口马上能够重复使用
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, True)

# 绑定服务端程序监听的 IP 和 PORT
server.bind(('127.0.0.1', 8080))

# 设置服务器监听，127表示同一时间最多处理127个客户端连接请求
server.listen(127)
print('服务器开始进行监听...')

while True:
    # 等待接受客户端的连接：如果没有客户端连接时，这句代码会阻塞等待，直到有客户端连接
    # server_client：和客户端进行通信的 socket 对象，服务员
    # ip_port：客户端的 IP 和 Port
    server_client, ip_port = server.accept()
    print(f'接受到来自客户端{ip_port}的连接请求...')

    # 接受客户端发送的消息，1024表示最多接受1024个字节
    # 如果客户端没有发消息，recv方法会阻塞等待
    recv_msg = server_client.recv(1024)  # 返回值是 bytes 类型
    print('客户端发送的消息为：\n', recv_msg.decode())

    # TODO：给浏览器返回 gdp.html 网页的内容
    # ...

    # 关闭和客户端通信的套接字、监听套接字
    server_client.close()

server.close()
