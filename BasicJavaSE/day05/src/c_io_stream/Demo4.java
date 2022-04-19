package c_io_stream;

import java.io.FileInputStream;
import java.io.IOException;

/*
FileInputStream的简介:
    概述: 它表示基本的字节输入流, 即以字节为单位的读取数据

    构造方法:
        public FileInputStream(String name)  // 使用字符串绑定文件位置
        public FileInputStream(File file) // 使用file对象绑定文件位置

    成员方法:
        public int read();一次读取一个字节,并返回读取到的内容, 如果读取不到返回-1
        public int read(byte[] bys); 一次读取一个字节数组,然后将读取到的有效字节数返回 而读取到的数据加载到了bys中
        public void close;

 */
public class Demo4 {
    public static void main(String[] args) throws IOException {
        // 需求1: 一次读取一个字节
        // 1. 创建输入流, 并且关联文件
        FileInputStream fileInputStream = new FileInputStream("day05/data/1.txt");
        // 2. 读取文件数据 使用read反复读取可继续往下读
        int read = fileInputStream.read();
        int read2 = fileInputStream.read();
        System.out.println(read);
        System.out.println(read2);

        // 创建一个变量保存读取到的数据信息
        int len = 0;
        // 循环读取
        while (len != -1) {
            len = fileInputStream.read();
            System.out.println(len);
        }
        while ((len = fileInputStream.read()) != -1) {
            System.out.println((char) len);
        }
        // 3. 关闭流, 释放资源
        fileInputStream.close();

        // 需求2: 一次读取一个字节数组
        FileInputStream fileInputStream1 = new FileInputStream("day05/data/1.txt");
        int len1 = 0;
        byte[] bytes = new byte[4];     // 实际开发中为1024的倍数, 或者1024*1024的倍数
        while((len1=fileInputStream1.read(bytes)) != -1) {
            System.out.println(new String(bytes, 0, len1));
        }
        fileInputStream1.close();
    }
}
