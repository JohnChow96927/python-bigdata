package cn.itcast.demo04_io;

import javax.jnlp.FileOpenService;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/*
FileOutputStream:
    概述: 它表示基本的字节输出流, 即以字节为单位往文件中写入数据

    构造方法:
        public FileOutputStream(String name) 往文件中添加数据  默认是覆盖
        public FileOutputStream(File file)  王文建忠添加数据第二个参数是true 就是追加,否则就是覆盖
    成员方法:
        public void write(int n); 一次写入一个字节
        public void write(byte[] bys);  一次写入一个字节数组
        public void write(byte[] bys, int start, int len); 一次写入字节数组的一部分
        public void close()  关闭流对象

    注意: 如果输入位置的文件不存在则会自动创建, 前提是该文件的父目录必须存在.

    文件操作的步骤:
        1.创建流对象
        2.向文件中写入数据
        3.关闭流,释放资源

 */
public class Demo02 {
    public static void main(String[] args) throws IOException {
        //1.创建流对象
//        FileOutputStream fos = new FileOutputStream("Day05/data/1.txt");  // 覆盖
        FileOutputStream fos = new FileOutputStream("Day05/data/1.txt", true); //追加模式
        //2.向文件中写入数据
        //方式一: 一次写入一个字节
//        fos.write(97);
//        fos.write(98);
//        fos.write(99);

        //方式二: 一次写入一个字节数组
//        byte[] bys = {65,66,67,68,69};
//        fos.write(bys);

        //方式三: 一次写入字节数组的一部分
        byte[] bys = {65, 66, 67, 68, 69};
        // 第一个参数是字节数组, 第二个参数是起始位置, 第三个参数是长度
        fos.write(bys, 1, 3);


        //3.关闭流,释放资源
        fos.close();
    }
}
