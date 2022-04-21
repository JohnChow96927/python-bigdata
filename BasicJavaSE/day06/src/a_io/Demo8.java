package a_io;

import java.io.ObjectInputStream;
import java.nio.file.Files;
import java.nio.file.Paths;

/*
 反序列化操作:
        概述:
            指的是从文件中读取对象, 用的是 ObjectInputStream.
        成员方法:
            public Object readObject();   读取对象.
            public void close();   释放资源.
        需求: 序列化学生对象到文件中.
 */
public class Demo8 {
    public static void main(String[] args) throws Exception {
        ObjectInputStream objectInputStream = new ObjectInputStream(Files.newInputStream(Paths.get("day06/data/2.txt")));
        Object obj = objectInputStream.readObject();
        Student s = (Student) obj;
        System.out.println(s);
        objectInputStream.close();
    }
}
