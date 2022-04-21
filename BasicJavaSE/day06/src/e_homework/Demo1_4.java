package e_homework;


import java.io.*;

public class Demo1_4 {
    //1. 复制图片, 或者视频.
    //	4. 高效的字节流一次读写一个字节数组.
    public static void main(String[] args) throws IOException {
        FileInputStream fileInputStream = new FileInputStream("day06/data/1.png");
        FileOutputStream fileOutputStream = new FileOutputStream("day06/data/1copy.png");
        BufferedInputStream bufferedInputStream = new BufferedInputStream(fileInputStream);
        BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(fileOutputStream);
        int len;
        byte[] bytes = new byte[1024];
        while ((len = bufferedInputStream.read(bytes)) != -1) {
            bufferedOutputStream.write(bytes, 0, len);
        }
        bufferedInputStream.close();
        bufferedOutputStream.close();
    }
}
