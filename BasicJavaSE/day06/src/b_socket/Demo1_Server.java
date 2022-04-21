package b_socket;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;

// TCP协议之客户端给服务器发送一句话, 服务器端给出回执信息
public class Demo1_Server {
    public static void main(String[] args) throws Exception {
        // 创建服务器端Socket对象, 指定端口号
        ServerSocket serverSocket = new ServerSocket(12306);

        // 监听连接
        Socket accept = serverSocket.accept();

        // 获取输入流, 可以读取客户端写过来的数据
        BufferedInputStream bufferedInputStream = new BufferedInputStream(accept.getInputStream());

        // 解析数据, 打印
        byte[] bytes = new byte[1024];
        int len = bufferedInputStream.read(bytes);
        String s = new String(bytes, 0, len);
        System.out.println("服务器端接收到: " + s);

        // 获取输出流, 给客户端写数据
        BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(accept.getOutputStream());
        bufferedOutputStream.write("你好吗".getBytes(StandardCharsets.UTF_8));
        bufferedOutputStream.flush();

        accept.close();

    }
}
