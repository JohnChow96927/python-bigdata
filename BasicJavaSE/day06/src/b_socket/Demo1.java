package b_socket;
/*
Socket简介:
        概述:
            网络编程也叫Socket编程, 套接字编程, 指的是: 用来实现 网络互联的 不同计算机上 运行的程序间 可以进行数据交互.
        网络编程原理:
            网络编程也叫网络通信, 通信两端都独有自己的Socket对象, 数据在两个Socket之间通过 数据报包或者IO流的方式进行传输.

        三要素:
            IP地址:
                概述:
                    指的是设备(电脑, 手机, Ipad...)在网络中的唯一标识.
                组成:
                    网络(网关)号码 + 主机地址
            端口号:
                概述:
                    指的是程序在设备上的唯一标识.
                范围:
                    0~65535, 其中0~1023之间不要用, 因为已经被系统占用了或者用作保留端口.
            协议:
                UDP:
                    1. 面向无连接.
                    2. 采用数据报包的形式发送数据, 每个包的大小不超过64KB.
                    3. 不安全(不可靠)协议.
                    4. 效率相对较高.
                    5. 不区分客户端和服务器端, 叫: 发送端和接收端.
                TCP:
                    1. 面向有连接(三次握手)
                    2. 采用IO流的形式发送数据, 理论上数据无大小限制.
                    3. 安全(可靠)协议.
                    4. 效率相对较低.
                    5. 区分客户端和服务器端.

        TCP协议的流程:
            1. 获取Socket对象.
            2. 通过Socket对象获取流, 可以和对方交互.
                public InputStream getInputStream();  获取输入流, 读取数据的.
                public OutputStream getOutputStream(); 获取输出流, 写数据的.
 */
public class Demo1 {
}
