package cn.itcast.demo02_socket;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.net.Socket;

/*
    案例: 1. TCP协议之客户端给服务器端发送一句话, 服务器端给出回执信息.
 */
public class ClientDemo01 {
    public static void main(String[] args) throws Exception {
        //1. 创建客户端的Socket对象, 指定: 服务器端的IP, 端口号.
        Socket socket = new Socket("127.0.0.1", 12306);
        //2. 获取输出流, 可以给服务器端写数据.
        OutputStream os = socket.getOutputStream();
        //将上述的流封装成: 高效流.
        BufferedOutputStream bos = new BufferedOutputStream(os);
        bos.write("你好呀".getBytes());
        bos.flush();

        //3. 创建输入流, 读取数据.
        BufferedInputStream bis = new BufferedInputStream(socket.getInputStream());
        //4. 解析并打印数据.
        byte[] bys = new byte[1024];
        int len = bis.read(bys);
        String s = new String(bys, 0, len);
        System.out.println("客户端端接收到: " + s);
        //5. 释放资源.
        //bos.close();
        socket.close();
    }
}
