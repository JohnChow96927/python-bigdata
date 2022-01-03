"""
简单Web服务器-返回任意html内容
学习目标：能够实现Web服务器给浏览器返回任意html内容
"""
import os
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

    # TODO：解析请求报文内容，获取浏览器请求的 URL 地址
    # 将请求报文按照\r\n进行切割, 然后获取请求行的内容
    recv_msg = recv_msg.decode()
    recv_msg_list = recv_msg.split('\r\n')  # list
    request_line = recv_msg_list[0]
    # 将请求行按照空格进行切割, 然后获取资源路径内容
    request_line_tags = request_line.split(' ')  # list
    request_url = request_line_tags[1]
    # TODO：组织 HTTP 响应报文并返回，根据浏览器请求的 URL 地址并返回相应的 html 内容
    # 响应行
    response_line = b'HTTP/1.1 200 OK\r\n'
    # 响应头
    response_head = b'Server: JohnChow\r\nContent-Type: text/html;charset=utf-8\r\n'
    if request_url == '/':
        file_path = './sources/html/gdp.html'
    else:
        file_path = './sources/html' + request_url
    if os.path.isfile(file_path):   # os.path.exists()只判断路径是否存在, 并不能保证是一个文件, 应使用isfile()
        file = open(file_path, 'rb')
        response_body = file.read()
        file.close()
    else:
        response_body = b'not found!'
    response_msg = response_line + response_head + b'\r\n' + response_body
    server_client.send(response_msg)

    # 关闭和客户端通信的套接字、监听套接字
    server_client.close()

server.close()
