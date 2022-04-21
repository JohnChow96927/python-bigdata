package cn.itcast.demo02_socket;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.Socket;

/*
    案例: 1. TCP协议之客户端给服务器端发送一句话, 服务器端给出回执信息.
 */
public class ServiceDemo01 {
    public static void main(String[] args) throws Exception {
        //1. 创建服务器端Socket对象, 指定端口号.
        ServerSocket server = new ServerSocket(12306);
        //2. 监听连接.
        Socket accept = server.accept();

        //3. 获取输入流, 可以读取客户端写过来的数据.
        BufferedInputStream bis = new BufferedInputStream(accept.getInputStream());

        //4. 解析数据, 打印.
        byte[] bys = new byte[1024];
        int len = bis.read(bys);
        String s = new String(bys, 0, len);
        System.out.println("服务器端接收到: " + s);


        //5. 获取输出流, 给客户端写数据.
        BufferedOutputStream bos = new BufferedOutputStream(accept.getOutputStream());
        bos.write("我很好".getBytes());
        bos.flush();

        //6. 具体写回执信息.

        //7. 释放资源.
        //bis.close();
        accept.close();
        //server.close();       //实际开发中, 服务器是不关闭的.
    }
}
