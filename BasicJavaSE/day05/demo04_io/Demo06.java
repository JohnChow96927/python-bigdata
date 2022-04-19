package cn.itcast.demo04_io;

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
public class Demo06 {
    private static final int FILE_KEY = 1234;
    public static void main(String[] args) throws IOException {
//        System.out.println(4 ^ 3);  // 7  转换为二进制数据如果相同二进制位上的数字不相等则为1, 相等则为0  此为异或
//        System.out.println(4 ^ 3 ^4);
//        System.out.println(5 ^ 127869 ^ 127869); // 一个数字异或两次相同的数据结果不变

        /*//1.创建一个输入流, 关联源文件
        FileInputStream fis = new FileInputStream("Day05/data/1.png");
        //2.创建一个输出流 关联目的地文件
        FileOutputStream fos = new FileOutputStream("Day05/data/2.png");
        //3.定义变量,记录读取到的数据
        int len;
        //4.循环读取
        while ((len = fis.read()) != -1 ){
            //5.将读取到的数据写入目的地文件中,并进行加密
            fos.write(len ^ file_key);
        }
        //6.释放资源
        fis.close();
        fos.close();*/

//        此时已经加密成功

        // 解密流程,就是加密文件当做输入流源文件,读取出来后再加密一遍即可解密
        //1.创建一个输入流, 关联源文件
        FileInputStream fis = new FileInputStream("Day05/data/2.png");
        //2.创建一个输出流 关联目的地文件
        FileOutputStream fos = new FileOutputStream("Day05/data/3.png");
        //3.定义变量,记录读取到的数据
        int len;
        //4.循环读取
        while ((len = fis.read()) != -1 ){
            //5.将读取到的数据写入目的地文件中,并进行加密
            fos.write(len ^ FILE_KEY);
        }
        //6.释放资源
        fis.close();
        fos.close();

    }
}
