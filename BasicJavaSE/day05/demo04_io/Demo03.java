package cn.itcast.demo04_io;

import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.Array;
import java.util.Arrays;

/*
    案例: 字节输出流, 创建一个指定大小的空文件
    需求: 在data目录下创建一个文件叫做, 冀老师的上海生活.avi 大小为100M
 */
public class Demo03 {
    public static void main(String[] args) throws IOException {
        // 1.创建一个字节输出流对象
        FileOutputStream fos = new FileOutputStream("Day05/data/冀老师的上海生活.avi");
        // 2.往文件中写空数据
        //创建一个空数组
        byte[] bys = new byte[1024]; // KB
//        System.out.println(Arrays.toString(bys));
        //循环写入
        for (int i = 0; i < 1024 * 100; i++) {
            fos.write(bys);
        }
        // 3.关闭流,释放资源
        fos.close();
    }
}
