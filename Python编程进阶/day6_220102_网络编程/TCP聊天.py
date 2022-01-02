import socket

my_ip = "192.168.41.44"
# 创建服务端监听的套接字
# socket.AF_INET表示使用IPv4地址
# socket.SOCK_STREAM表示使用TCP协议
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  # 门迎

# 绑定服务器程序的IP和端口号
server_socket.bind((my_ip, 8080))
print(f'服务器ip: {my_ip}, 端口号为8080, 已绑定')

# 设置监听
# 127: 表示服务端监听套接字同一时间最多支持127个客户端发起连接请求
server_socket.listen(127)
print("服务端开始监听...")
print("等待客户端连接...")

# 等待客户端请求来连接服务端程序
# accept方法默认会阻塞, 直到有客户端进行连接
# service_client: 专门用于和客户端进行通信的套接字(服务员)
# ip_port: 客户端的IP和端口号
service_client, ip_port = server_socket.accept()  # 阻塞函数
print(f"服务端接收到来自于{ip_port}的连接")

# 服务器接收来自客户端的消息
# bufsize: 表示每次最多接收bufsize个bytes
# 当客户端没有给服务端发送消息时, recv方法会阻塞等待直到客户端发送了消息
print("等待接收客户端发送的消息...")
while True:
    recv_msg = service_client.recv(1024)  # 类型为bytes字节流
    print(f"接收到客户端的消息: {recv_msg.decode()}")

    # 服务器给客户端回应一个消息
    send_msg = input("请输入回复的消息:")  # str
    service_client.send(send_msg.encode())
    if send_msg == "再见":  # 如果发送"再见"则结束聊天
        break

# 关闭服务端套接字: 关闭顺序没有要求, 看你是要停止传输还是停止接收新的连接请求
# 关闭和客户端通信的套接字
service_client.close()
# 关闭服务器监听套接字
server_socket.close()
