python高级 5天: 网络编程 web程序 简单爬虫 数据可视化

#### MySQL数据库: 重点核心, 写SQL(6-7天)

pandas数据分析: 6-7天

# 1. 网络编程基础知识

- ##### IP地址: 标识网络中唯一的一台设备

    - IPv4: 点分十进制, 由32个二进制位组成:

        255.255.255.0

        最多标识42亿九千四百多万设备

    - IPv6: 冒号十六进制, 由128个二进制位组成:

        2345:0425:2CA1:0000:0000:0567:5673:23B5

    - Windows系统使用ipconfig查看

    - Mac/Linux系统使用ifconfig查看

    - ping 网址 检查网络情况

    - ping 127.0.0.1 本地回环地址, 检查网卡是否正常

- ##### 端口和端口号

    - > 端口: 标识一台设备的一个网络应用程序

    - 端口号: (0-65535)

        0-1023为系统预留的一些端口号, 不建议使用

        1024-65535为动态端口号, 但有一些端口号被常见程序占用了, 不建议使用: MySQL 3306/redis 6379/ HDFS 9870

    - 若不指定端口号, 则机器随机分配一个动态端口号

- ##### TCP协议: Transmission Control Protocol

    - 面向连接, 可靠的, 基于字节流的传输层通信协议

    - 面向连接:

        三次握手: 拨通电话等待接听为第一次握手, 对面接听说了声喂为第二次握手, 我说了声喂为第三次握手

    - 可靠传输: 保证不丢包, 不乱序

    - 面向字节流: 传输的都是二进制bytes数据

    - TCP通信步骤: 建立连接, 传输数据, 关闭连接

- ##### Socket: 

    > Socket套接字: **进程之间通信的一个工具(接口)**, 是操作系统提供的网络编程接口, 屏蔽了通过TCP/IP及端口进行网络数据传输的细节

- ##### 作用: 进程之间的网络数据传输

- ##### 使用场景: 网络相关的应用程序或软件都使用了socket

# 2. TCP网络程序开发

- ##### TCP网络程序开发流程

    服务器: 

    1. 创建一个监听的socket
    2. 绑定IP和端口号(bind)
    3. 设置监听(listen)
    4. 等待客户端连接(accept)
    5. 一直阻塞到客户连接到达
    6. 接收客户端数据(recv)
    7. 处理数据
    8. 发送(应答)数据(send)
    9. 关闭服务端套接字(close)

    客户端:

    1. 创建socket
    2. 连接服务器(要知道服务器的ip和端口号)(connect)
    3. 发送数据(send)
    4. 接收数据(recv)
    5. 关闭客户端套接字(close)

- ##### str和bytes字节流的互相转换:

    ```python
    """
    str和bytes的互相转换
    学习目标：知道str和bytes数据之间的互相转换
    """
    # str -> bytes：str.encode('编码方式：默认utf8')
    # bytes -> str：bytes.decode('解码方式：默认utf8')
    
    my_str = '你好！中国！'  # str
    print(type(my_str), my_str)
    
    # bytes: 字节流
    res1 = my_str.encode()  # 等价于 res1 = my_str.encode('utf8')
    print(type(res1), res1)
    
    print(res1.decode())
    # 编解码方式必须一致, 否则可能会出现乱码或报错
    ```

- ##### 基本流程实例: 服务端程序

    ```python
    """
    TCP 服务端程序开发
    学习目标：理解 TCP 服务端程序的开发流程
    """
    
    """
    TCP服务端程序开发步骤：
    1）创建服务端监听套接字对象
    2）绑定端口号
    3）设置监听
    4）等待接受客户端的连接请求
    5）接收数据
    6）发送数据
    7）关闭套接字
    """
    import socket
    
    # 创建服务端监听的套接字
    # socket.AF_INET表示使用IPv4地址
    # socket.SOCK_STREAM表示使用TCP协议
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)   # 门迎
    
    # 绑定服务器程序的IP和端口号
    server_socket.bind(('127.0.0.1', 8080))
    
    # 设置监听
    # 127: 表示服务端监听套接字同一时间最多支持127个客户端发起连接请求
    server_socket.listen(127)
    print("服务端程序开始监听...")
    
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
    recv_msg = service_client.recv(1024)    # 类型为bytes字节流
    print(f"接收到客户端的消息: {recv_msg.decode()}")
    
    # 服务器给客户端回应一个消息
    send_msg = input("请输入响应的消息:")   # str
    service_client.send(send_msg.encode())
    
    # 关闭服务端套接字: 关闭顺序没有要求, 看你是要停止传输还是停止接收新的连接请求
    # 关闭和客户端通信的套接字
    service_client.close()
    # 关闭服务器监听套接字
    server_socket.close()
    ```

- ##### 基本流程实例: 客户端程序

    ```python
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
    recv_msg = client_socket.recv(1024)    # 阻塞
    print('接收到服务端响应的消息: ', recv_msg.decode())
    
    # 关闭客户端套接字
    client_socket.close()
    ```

- ##### 文件传输实例: 服务端程序

- ##### 文件传输实例: 客户端程序

- ##### 文件传输-recv方法解阻塞的三种情况:

    1. 对端发送过来了数据(send)
    2. 对端socket套接字被关闭(close)
    3. 对端socket套接字关闭了输出流(shutdown(socket.SHUT_WR))

- 文件传输-客户端vs服务器端recv阻塞处理

    - 客户端

    ```python
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
    ```

    - 服务端

    ```python
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
        print("服务端等待接收客户端发送的数据...")
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
    service_client.send("接收完成!".encode())
    
    # 关闭和客户端通信的套接字
    service_client.close()
    # 关闭服务器监听套接字
    server.close()
    ```

# 3. 本机回环IP地址, 局域网IP地址, 外网IP地址(了解)

- 本机回环地址: 127.0.0.1或localhost域名, 只有在本机才能进行访问
- 局域网地址: 可以被局域网内其他机器进行访问
- 外网地址: 也叫公网地址