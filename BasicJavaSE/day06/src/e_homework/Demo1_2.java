package e_homework;


import java.io.FileInputStream;
import java.io.FileOutputStream;

public class Demo1_2 {
    //1. 复制图片, 或者视频.
    //	2. 普通的字节流一次读写一个字节数组.			//必须掌握.
    public static void main(String[] args) throws Exception {
        FileInputStream fileInputStream = new FileInputStream("day06/data/1.png");
        FileOutputStream fileOutputStream = new FileOutputStream("day06/data/1copy.png");
        int len;
        byte[] bytes = new byte[1024];
        while ((len = fileInputStream.read(bytes)) != -1) {
            fileOutputStream.write(bytes, 0, len);
        }
        fileInputStream.close();
        fileOutputStream.close();
    }
}
