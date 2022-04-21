package a_io;

import java.io.*;

/*
    字符流拷贝文件的4种方式:
        1. 基本的字符流一次读写一个字符.
        2. 基本的字符流一次读写一个字符数组.
        3. 高效的字符流一次读写一个字符.
        4. 高效的字符流一次读写一个字符数组.
        5. 高效的字符流独有的拷贝方式: 一次读写一行.
 */
public class Demo3 {
    public static void main(String[] args) throws Exception{
        method1();  // 基本字符流, 一次读写一个字符
        method2();  // 高效字符流, 一次读写一个字符数组
        method3();  // 高效字符流, 一次读写一个字符
        method4();  // 高效的字符流, 一次读写一个字符数组
    }

    private static void method1() throws IOException {
        FileReader fileReader = new FileReader("day06/data/1.txt");
        FileWriter fileWriter = new FileWriter("day06/data/2.txt");
        int len;
        while ((len = fileReader.read()) != -1) {
            fileWriter.write(len);
        }
        fileReader.close();
        fileWriter.close();
    }

    private static void method2() throws IOException {
        FileReader fileReader = new FileReader("day06/data/1.txt");
        FileWriter fileWriter = new FileWriter("day06/data/3.txt");
        int len;
        char[] chs = new char[1024];
        while ((len = fileReader.read(chs)) != -1) {
            fileWriter.write(chs, 0, len);
        }
        fileReader.close();
        fileWriter.close();
    }

    private static void method3() throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new FileReader("day06/data/1.txt"));
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter("day06/data/4.txt"));

        int len;
        while ((len = bufferedReader.read()) != -1) {
            bufferedWriter.write(len);
        }
        bufferedReader.close();
        bufferedWriter.close();
    }

    private static void method4() throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new FileReader("day06/data/1.txt"));
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter("day06/data/5.txt"));
        int len;
        char[] chars = new char[1024];
        while ((len = bufferedReader.read(chars)) != -1) {
            bufferedWriter.write(chars, 0, len);
        }
        bufferedReader.close();
        bufferedWriter.close();
    }

}
