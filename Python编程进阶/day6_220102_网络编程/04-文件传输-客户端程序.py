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
client.connect(('192.168.41.30', 8080))
print('客户端连接服务器成功！')

# TODO：给服务端程序发送文件数据
# 边读边发送给服务端
# 创建文件操作对象
file = open('./src/小电影.mp4', 'rb')
# 循环读取文件数据, 并将每次读取的数据发送给服务端
while True:
    # 每次从文件中读取1024字节
    data = file.read(1024)  # bytes, 如果data是'', 表示文件读取完毕
    # 文件读取结束, 结束循环
    if len(data) == 0:
        break
    # 将读取的数据发送给服务端程序
    client.send(data)

# 关闭打开的文件, 释放资源
file.close()
print("客户端发送文件完成")

# 关闭客户端套接字
client.close()
