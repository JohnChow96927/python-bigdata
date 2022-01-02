"""
文件传输-recv阻塞处理-服务端程序
"""
import socket

# 创建服务端监听套接字
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# 监听套接字绑定地址和端口
server.bind(('127.0.0.1', 8080))

# 监听套接字开始监听，准备接收客户端的连接请求
server.listen(128)
print('服务器开始监听...')

# 接收客户端的连接请求
# service_client：专门和客户端通信的套接字
# ip_port：客户端的 IP 地址和端口号
service_client, ip_port = server.accept()
print(f'服务器接收到来自{ip_port}的请求')

# ① 创建文件对象
f = open("./dest/小电影.mp4", "wb")

# ② 循环接收客户端发送过来的数据，直到客户端发送完毕
while True:
    # ③ 每次接受 1024 个字节
    data = service_client.recv(1024)
    # ④ 将接收到的数据写入到文件中
    f.write(data)
    # ⑤ 读取结束，结束循环
    if len(data) == 0:
        break

# ⑥ 关闭文件
f.close()
print('服务器接收文件完成！')

# TODO：给客户端回复消息：接收完成！

# 关闭和客户端通信的套接字
service_client.close()
# 关闭服务器监听套接字
server.close()


