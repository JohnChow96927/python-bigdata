package b_socket;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.nio.charset.StandardCharsets;

public class Demo1_Client {
    public static void main(String[] args) throws Exception {
        Socket socket = new Socket("127.0.0.1", 12306);
        OutputStream outputStream = socket.getOutputStream();
        // 将上述的输出流封装成高效流
        BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(outputStream);
        bufferedOutputStream.write("你好啊".getBytes(StandardCharsets.UTF_8));
        bufferedOutputStream.flush();

        // 创建输入流, 读取数据
        BufferedInputStream bufferedInputStream = new BufferedInputStream(socket.getInputStream());

        byte[] bytes = new byte[1024];
        int len = bufferedInputStream.read(bytes);
        String s = new String(bytes, 0, len);
        System.out.println("客户端接受到: " + s);
        socket.close();
    }
}
