package cn.itcast.demo03_upload;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;

/*
    上传文件, 服务器端.
 */
public class ServerDemo {
    public static void main(String[] args) throws Exception{
        //1. 创建服务器端的Socket对象, 指定端口号.
        ServerSocket server = new ServerSocket(10010);
        //2. 监听连接.
        Socket accept = server.accept();
        //3. 创建输入流, 读取客户端写过来的数据.
        BufferedReader br = new BufferedReader(new InputStreamReader(accept.getInputStream()));
        //4. 创建输出流, 关联目的地文件.
        BufferedWriter bw = new BufferedWriter(new FileWriter("Day06/download/传智.txt"));
        //5. 正常的IO流代码.
        String line;
        while((line = br.readLine()) != null) {
            bw.write(line);
            bw.newLine();
            bw.flush();
        }


        //释放资源.
        bw.close();
        accept.close();
    }
}
