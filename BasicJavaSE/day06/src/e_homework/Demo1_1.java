package e_homework;


import java.io.FileInputStream;
import java.io.FileOutputStream;

public class Demo1_1 {
    //1. 复制图片, 或者视频.
    //	1. 普通的字节流一次读写一个字节.
    public static void main(String[] args) throws Exception {
        FileInputStream fileInputStream = new FileInputStream("day06/data/1.png");
        FileOutputStream fileOutputStream = new FileOutputStream("day06/data/1copy.png");
        int len;
        while ((len = fileInputStream.read()) != -1) {
            fileOutputStream.write(len);
        }
        fileInputStream.close();
        fileOutputStream.close();
    }
}
