package a_io;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;

/*
    序列化操作:
        概述:
            指的是把对象写入到文件中, 用的是 ObjectOutputStream.
        成员方法:
            public void writeObject(Object obj);   把对象序列化到文件中.
            public void close();   释放资源.
        需求: 序列化学生对象到文件中.

 */
public class Demo7 {
    public static void main(String[] args) throws IOException {
        ObjectOutputStream objectOutputStream = new ObjectOutputStream(Files.newOutputStream(Paths.get("day06/data/2.txt")));
        Student s = new Student("shuang", 18);
        objectOutputStream.writeObject(s);
        objectOutputStream.close();

    }
}
