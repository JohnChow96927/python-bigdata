package a_io;

/*
 字符流简介:
        背景: 即, 为什么有字符流?
        原因: 因为中文字符在不同的码表中占用字节数不一样, 如果采用字节流拷贝文本文件, 当数据源和目的地文件码表不一致的时候, 可能会产生乱码问题.
             即: 字符流 = 字节流 + 编码表.

        常见的码表:
            ASCII: 美国信息通用交换码表
            ISO-8859-1: 欧洲通用码表.
            GBK: 国内用的码表.
            utf-8: 国际通用码表, 也叫: 万国码, 统一码.
 */

import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class Demo2 {
    public static void main(String[] args) throws Exception {
        String s = "abc123你好!";
        byte[] bytes1 = s.getBytes();    // utf-8
        byte[] bytes2 = s.getBytes(StandardCharsets.UTF_8);    // utf-8
        byte[] bytes3 = s.getBytes("gbk");  // gbk编码

        System.out.println(Arrays.toString(bytes1));    // [97, 98, 99, 49, 50, 51, -28, -67, -96, -27, -91, -67, 33]
        System.out.println(Arrays.toString(bytes2));    // [97, 98, 99, 49, 50, 51, -28, -67, -96, -27, -91, -67, 33]
        System.out.println(Arrays.toString(bytes3));    // [97, 98, 99, 49, 50, 51, -60, -29, -70, -61, 33]

        byte[] bytes = {97, 98, 99, 49, 50, 51, -28, -67, -96, -27, -91, -67, 33};
        String utf8toStr = new String(bytes);
        System.out.println(utf8toStr);
        byte[] bytesGbk = {97, 98, 99, 49, 50, 51, -60, -29, -70, -61, 33};
        String gbktoStr = new String(bytesGbk, "gbk");
        System.out.println(gbktoStr);
    }
}
