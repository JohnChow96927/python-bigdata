package c_io_stream;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/*
需求:
1.将项目下的1.txt中的内容复制到2.txt文件中.
2.通过两种方式实现.
 提示:
1.方式一: 一次读写一个字节.
2.方式二: 一次读写一个字节数组.

IO流的核心步骤:
    1.创建输入流  绑定数据源文件 (源文件必须存在)
    2.创建输出流  绑定目的地文件 (目的地文件可以不存在)
    3.定义变量, 记录读取到的内容(字节, 有效字节数)
    4.循环读取, 并且将读取到的内容赋值给变量, 只要满足条件一直读取
    5.将读取到的数据写入到目的地文件中
    6.关闭流,释放资源(输入输出都需要关闭)
 */
public class Demo5 {
    public static void main(String[] args) throws IOException {
        // 方式一: 一次读取一个字节
        // 1. 创建输入流, 绑定数据源文件(源文件必须存在)
        FileInputStream fileInputStream = new FileInputStream("day05/data/1.txt");
        // 2. 创建输出流, 绑定目的地文件(目的地文件可以不存在)
        FileOutputStream fileOutputStream = new FileOutputStream("day05/data/2.txt");
        // 3. 定义变量记录读取到的内容(字节, 有效字节数)
        int len;
        // 4. 循环读取, 并且将读取到的内容赋值给变量
        while ((len = fileInputStream.read()) != -1) {
            // 5. 将读取到的数据写入到目的地文件中
            fileOutputStream.write(len);
        }
        // 6. 关闭流, 释放资源
        fileInputStream.close();
        fileOutputStream.close();

        //方式二: 一次读取一个字节数组
        //1.创建输入流  绑定数据源文件 (源文件必须存在)
        FileInputStream fis = new FileInputStream("day05/data/1.txt");
        //2.创建输出流  绑定目的地文件 (目的地文件可以不存在)
        FileOutputStream fos = new FileOutputStream("day05/data/3.txt");
        //3.定义变量, 记录读取到的内容(字节, 有效字节数)
        int len1;  //获取读取的有效字节数
        byte[] bys = new byte[1024];
        //4.循环读取, 并且将读取到的内容赋值给变量, 只要满足条件一直读取
        while ((len1 = fis.read(bys)) != -1) {
            //5.将读取到的数据写入到目的地文件中
            fos.write(bys, 0, len1);
        }
        //6.关闭流,释放资源(输入输出都需要关闭)
        fis.close();
        fos.close();
    }
}
