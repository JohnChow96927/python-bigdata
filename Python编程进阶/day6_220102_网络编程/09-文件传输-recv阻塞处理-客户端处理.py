"""
文件传输-recv阻塞处理-客户端程序
"""
import socket

# 创建客户端 socket 套接字对象
# socket.AF_INET：表示 IPV4
# socket.SOCK_STRAM：表示 TCP 传输协议
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# 客户端请求和服务端程序建立连接
client.connect(('127.0.0.1', 8080))
print('客户端连接服务器成功！')

# ① 创建文件对象
f = open("./src/小电影.mp4", "rb")

# ② 循环读取文件中的数据
while True:
    # ③ 每次从文件中读取1024个字节
    data = f.read(1024)
    # ④ 将读取的数据发送给服务器
    client.send(data)
    # ⑤ 文件读取结束，结束循环
    if len(data) == 0:
        # TODO：客户端关闭输出流，让服务端程序的recv解阻塞
        client.shutdown(socket.SHUT_WR)
        break

# ⑥ 关闭文件
f.close()
print('客户端发送文件完成！')
# TODO：收客户端回复的消息
print("阻塞等待服务端回复消息")
res_msg = client.recv(1024)
print("服务端回复: ", res_msg.decode())
# 关闭客户端套接字
client.close()
