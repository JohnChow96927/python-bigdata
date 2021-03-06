package c_io_stream;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

/*
FileOutputStream:
    概述: 它表示基本的字节输出流, 即以字节为单位往文件中写入数据

    构造方法:
        public FileOutputStream(String name) 往文件中添加数据  默认是覆盖
        public FileOutputStream(File file)  往文件中添加数据第二个参数是true就是追加,否则就是覆盖
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
public class Demo2 {
    public static void main(String[] args) throws IOException {
        // 1. 创建流对象
        FileOutputStream fileOutputStream = new FileOutputStream("day05/data/1.txt", true);     // 追加模式
        // 2. 向文件中写入数据
        // 方式一: 一次写入一个字节
        fileOutputStream.write(97);
        fileOutputStream.write(98);

        // 方式二: 一次写入一个字节数组
        byte[] bytes = {65, 66, 67, 111};
        fileOutputStream.write(bytes);

        // 方式三: 一次写入字节数组的一部分
        byte[] bytes1 = {1, 2, 3, 4, 5};
        // 第一个参数式字节数组, 第二个参数是起始位置, 第三个位置是长度
        fileOutputStream.write(bytes1, 1, 3);

        // 3. 关闭流, 释放资源
        fileOutputStream.close();
    }
}
