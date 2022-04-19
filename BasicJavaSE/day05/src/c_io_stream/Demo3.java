package c_io_stream;

import java.io.FileOutputStream;
import java.io.IOException;

/*
    案例: 字节输出流, 创建一个指定大小的空文件
    需求: 在data目录下创建一个文件叫我和霜霜的上海生活.avi 大小为12M
 */
public class Demo3 {
    public static void main(String[] args) throws IOException {
        // 创建一个字节输出流对象
        FileOutputStream fileOutputStream = new FileOutputStream("day05/data/我和霜霜的上海生活.avi");
        // 2. 往文件内写空数据
        // 创建一个空数组
        byte[] bytes = new byte[1024];
        for (int i = 0; i < 1024 * 12; i++) {
            fileOutputStream.write(bytes);
        }
        // 3. 关闭流, 释放资源
        fileOutputStream.close();
    }
}
