package e_homework;

import org.junit.Test;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;

public class Homework {
    //1. 复制图片, 或者视频.
    //	1. 普通的字节流一次读写一个字节.
    @Test
    public void question1() throws Exception {
        FileInputStream fileInputStream = new FileInputStream("day06/data/1.png");
        FileOutputStream fileOutputStream = new FileOutputStream("day06/data/1copy.png");
        int len;
        while ((len = fileInputStream.read()) != -1) {
            fileOutputStream.write(len);
        }
        fileInputStream.close();
        fileOutputStream.close();
    }

    //	2. 普通的字节流一次读写一个字节数组.			//必须掌握.
    @Test
    public void question2() throws Exception {
        FileInputStream fileInputStream = new FileInputStream("day06/data/1.png");
        FileOutputStream fileOutputStream = new FileOutputStream("day06/data/1copy.png");
        int len;
        byte[] bytes = new byte[1024];
        while ((len = fileInputStream.read(bytes)) != -1) {
            fileOutputStream.write(bytes, 0, len);
        }
    }

    //	3. 高效的字节流一次读写一个字节.				//必须掌握.
    @Test
    public void question3() throws IOException {
        BufferedInputStream bufferedInputStream = new BufferedInputStream(Files.newInputStream(Paths.get("day06/data/1.png")));
        BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(Files.newOutputStream(Paths.get("day06/data/1copy.png")));
        int len;
        while ((len = bufferedInputStream.read()) != -1) {
            bufferedOutputStream.write(len);
        }
        bufferedInputStream.close();
        bufferedOutputStream.close();
    }

    //	4. 高效的字节流一次读写一个字节数组.
    @Test
    public void question4() {

    }

    //2. 复制文本文件.
    //	高效的字符流一次读写一行. 					//必须, 必须, 必须掌握.
    @Test
    public void question5() {

    }

    //3. 随机点名器案例.
    //提示: 高效的字符流一次读写一行.
        /*
            项目下有一个names.txt, 里边记录的是学员的名字, 格式如下(一个名字占一行)
                张三
                李四
                王五
                赵六
                ...
            将上述所有数据读取出来, 存放到ArrayList<String>集合中, 然后随机从中获取一个名字即可.
        */
    @Test
    public void question6() {

    }

    //4. 已知项目下有个a.txt文本文件，里边有两行数据，如下：
    //		a,c,d,e,g,h
    //		a,g,b,o,q,r
    //
    //	需求：
    //		创建输入流，读取这两行数据，对这些元素进行去重操作，然后将去重后的结果写入到项目下的b.txt文本文件中, 格式如下:
    //			//可以不是如下的顺序, 但是要一个字符占一行.
    //			a
    //			b
    //			c
    //			d
    //			e
    //			...
    @Test
    public void question7() {

    }

    //5. 通过TCP协议实现发送数据.		//这个题选做, 有时间写一写, 没时间就算了.
    @Test
    public void question8() {

    }
}
