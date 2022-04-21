package a_io;

import java.io.FileWriter;
import java.io.IOException;

/*
flush() 和 close()方法的区别是什么?
    答案:
        flush(): 用来刷新缓冲区的, 把缓冲区的数据刷出来, 刷新之后, 流对象还可以继续使用.
        close(): 用来关闭流释放资源的, 关闭之前会自动刷新一次缓冲区, 关闭之后, 流对象不能继续使用.
 */
public class Demo6 {
    public static void main(String[] args) throws IOException {
        FileWriter fileWriter = new FileWriter("day06/data/2.txt");
        fileWriter.write("niubi!");
        fileWriter.flush();
        fileWriter.write("shuangshuang!");
        fileWriter.close();
    }
}
