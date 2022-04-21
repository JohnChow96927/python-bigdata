package a_io;

import java.io.*;

/*
    案例: 演示高效的字符流独有的拷贝方式: 一次读写一行.

    涉及到的成员方法如下:
        BufferedReader:
            public String readLine();    一次读取一行, 结束标记是\r\n, 只要整行内容, 不获取结束标记.
        BufferedWriter:
            public void newLine();       根据当前操作系统, 给出对应的换行符.
 */
public class Demo5 {
    public static void main(String[] args) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new FileReader("day06/data/1.txt"));
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter("day06/data/2.txt"));
        String line;
        while ((line = bufferedReader.readLine()) != null) {
            bufferedWriter.write(line);
            bufferedWriter.newLine();
        }
        bufferedReader.close();
        bufferedWriter.close();
    }
}
