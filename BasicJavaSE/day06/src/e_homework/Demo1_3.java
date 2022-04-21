package e_homework;


import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class Demo1_3 {
    //1. 复制图片, 或者视频.
    //	3. 高效的字节流一次读写一个字节.				//必须掌握.
    public static void main(String[] args) throws IOException {
        BufferedInputStream bufferedInputStream = new BufferedInputStream(Files.newInputStream(Paths.get("day06/data/1.png")));
        BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(Files.newOutputStream(Paths.get("day06/data/1copy.png")));
        int len;
        while ((len = bufferedInputStream.read()) != -1) {
            bufferedOutputStream.write(len);
        }
        bufferedInputStream.close();
        bufferedOutputStream.close();
    }
}
