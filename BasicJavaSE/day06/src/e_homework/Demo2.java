package e_homework;


import java.io.*;

public class Demo2 {
    //2. 复制文本文件.
    //	高效的字符流一次读写一行. 					//必须, 必须, 必须掌握.
    public static void main(String[] args) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new FileReader("day06/data/homework.txt"));
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter("day06/data/homeworkcopy.txt"));
        String line;
        while ((line = bufferedReader.readLine()) != null) {
            bufferedWriter.write(line);
            bufferedWriter.newLine();
        }
        bufferedReader.close();
        bufferedWriter.close();
    }
}
