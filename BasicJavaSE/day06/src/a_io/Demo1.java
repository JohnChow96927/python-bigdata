package a_io;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;

/*
    案例: 演示字节高效流的用法.

    字节高效流简介:
        概述:
            字节高效流也叫高效字节流, 字节缓冲流, 缓冲字节流, 指的是: BufferedInputStream, BufferedOutputStream.
        构造方法:
            BufferedInputStream:   字节高效输入流.
                public BufferedInputStream(InputStream is);
            BufferedOutputStream:   字节高效输出流.
                public BufferedOutputStream(OutputStream os);
 */
public class Demo1 {
    public static void main(String[] args) throws IOException {
        FileInputStream fis = new FileInputStream("day06/data/1.txt");
        BufferedInputStream bis = new BufferedInputStream(fis);

        BufferedOutputStream bos = new BufferedOutputStream(Files.newOutputStream(Paths.get("day06/data/3.txt")));

        int len;
        byte[] bys = new byte[1024];
        while ((len = bis.read(bys)) != -1) {
            bos.write(bys, 0, len);
        }
        bis.close();
        bos.close();
    }
}
