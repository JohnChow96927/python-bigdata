package a_io;

import java.io.*;

public class Demo4 {
    public static void main(String[] args) throws IOException {
        long start = System.currentTimeMillis();
        method1();
        method2();
        method3();
        method4();
        long end = System.currentTimeMillis();
        System.out.println("time: " + (end - start) + "ms");
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
