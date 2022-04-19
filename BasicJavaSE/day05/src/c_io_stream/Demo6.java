package c_io_stream;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/*
1.	对项目下的a.jpg图片进行加密, 获取到一个新的加密图片b.jpg.
2.	对加密后的图片b.jpg进行解密, 获取解密后的图片c.jpg.

扩展知识:
加密原理:
    采用位运算实现加密
    一个数字呗同一个数字位移两侧,该数字数值不变
    a ^ b ^ b = a
    b ^ a ^ b = a
 */
public class Demo6 {
    private static final int FILE_KEY = 1234;

    public static void main(String[] args) throws IOException {
        // 1. 创建一个输入流, 关联源文件
        FileInputStream fileInputStream = new FileInputStream("day05/data/1.png");
        // 2. 创建一个输出流, 关联目的地文件
        FileOutputStream fileOutputStream = new FileOutputStream("day05/data/2.png");
        // 3. 定义变量, 记录读取到的数据
        int len;
        // 4. 循环读取
        while ((len = fileInputStream.read()) != -1) {
            // 5. 将读取到的数据写入目的地文件中, 并进行加密
            fileOutputStream.write(len ^ FILE_KEY);
        }
        // 6. 释放资源
        fileInputStream.close();
        fileOutputStream.close();

        // 解密
        // 1. 创建输入流, 关联加密文件
        FileInputStream fileInputStream1 = new FileInputStream("day05/data/2.png");
        // 2. 创建一个输出流, 关联目的地文件
        FileOutputStream fileOutputStream1 = new FileOutputStream("day05/data/3.png");
        // 3. 定义变量, 记录读取到的数据
        int len1;
        // 4. 循环读取
        while ((len1 = fileInputStream1.read()) != -1) {
            // 5. 将读取到的数据写入目的地文件中, 并进行解密
            fileOutputStream1.write(len1 ^ FILE_KEY);
        }
        fileInputStream1.close();
        fileOutputStream1.close();
    }
}
