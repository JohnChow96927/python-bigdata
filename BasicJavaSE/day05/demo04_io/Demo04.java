package cn.itcast.demo04_io;

import java.io.File;
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
public class Demo04 {
    public static void main(String[] args) throws IOException {
        // 需求1: 一次读取一个字节
        /*//1.创建输入流 并且关联文件
        FileInputStream fis = new FileInputStream("Day05/data/1.txt");
        //2.读取文件数据 使用read反复读取可继续向下读
//        int read = fis.read();
//        int read2 = fis.read();
//        System.out.println(read);
//        System.out.println(read2);

        // 创建一个变量保存读取到的数据信息
        int len = 0;
        // 循环读取
//        while(len != -1){
//            len = fis.read();
//            System.out.println(len);
//        }
        *//*
        (len = fis.read()) != -1一共做了3件事
        1.执行了fis.read()读取了一个字节,并返回读取到的内容
        2.执行len=fis.read() 把上一步读取道德数据赋值给了变量
        3.len != -1 判断暖气是否为-1,如果为-1 则终止循环读取完毕
         *//*
        while ((len = fis.read()) != -1) {
            System.out.println((char) len);
        }
        //3.关闭流,释放资源
        fis.close();*/


        // 需求2: 一次读取一个字节数组
        //1.创建输入流
        FileInputStream fis = new FileInputStream("Day05/data/1.txt");
        //2.读取数据
        //2.1 定义变量,记录接收到的数据
        int len = 0;  // 获取读取道德字节数
        byte[] bys = new byte[4]; // 实际开发中为1024的倍数,或者1024*1024的倍数
        //2.2循环读取数据
        while((len=fis.read(bys)) != -1){
            // 再显示文字时,可以加上len 指定有效字节数
            System.out.println(new String(bys, 0, len));
//            System.out.println(new String(bys));
        }
        //3.关闭流,释放资源
        fis.close();

        // 注意:
        // 读取字节数组时, len获取的不再是字节值,而是读取的有效字节数
        // 读取的字节内容已经寸放在字节数组中,如果不使用,第二次读取的时候就会将其覆盖
    }
}
