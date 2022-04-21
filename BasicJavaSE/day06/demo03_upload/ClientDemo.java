package cn.itcast.demo03_upload;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.Socket;

/*
    上传文件, 客户端.
 */
public class ClientDemo {
    public static void main(String[] args) throws IOException {
        //1. 创建客户端Socket对象, 指定: 服务器端IP, 端口号.
        Socket socket = new Socket("127.0.0.1", 10010);
        //2. 获取输出流, 可以往服务器端写数据.
        //高效字符流        =                       转换流                  基本的字节流
        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
        //3. 创建输入流, 读取数据源信息.
        BufferedReader br = new BufferedReader(new FileReader("Day06/data/2.txt"));
        //4. 具体的文件上传的动作.
        String line;
        while((line = br.readLine()) != null) {
            bw.write(line);
            bw.newLine();
            bw.flush();
        }

        //释放资源.
        br.close();
        socket.close();
    }
}
