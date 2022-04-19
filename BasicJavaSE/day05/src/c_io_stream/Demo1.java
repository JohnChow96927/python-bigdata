package c_io_stream;
/*
    IO流: 指的就是Input(输入)/Output(输出) 也叫做输入输出流,就是用来实现文件数据传输的
    应用场景:
        1.文件上传
        2.文件下载
    分类:
        按照流向分:
            输入流: 用来读取数据的
            输出流: 用来写入数据的
        按照操作分:
            字节流:
                特点: 以字节为单位拷贝数据,能操作任意类型的文件,也叫做万能流
                分类:
                    字节输入流: 顶层抽象类(InputStream)
                        FileInputStream 基本的字节输入流
                        BufferedInputStream  高效字节输入流
                    字节输出流: 顶层抽象类(OutputStream)
                        FileOutputStream 基本的字节输出流
                        BufferedOutputStream  高效字节输出流

            字符流:
                特点: 以字符为单位拷贝数据,只能操作纯文本数据(字符流=编码集+字节流)
                分类:
                    字符输入流: 顶层抽象类(Reader)
                        FileReader  基本字符输入流
                        BufferedReader  高效字符输入流
                    字符输出流: 顶层抽象类(Writer)
                        FileWriter  基本字符输出流
                        BufferedWriter  高效字符输出流

                input(输入)  output(输出)  Stream(流) file(文件)  buffered(缓冲)
                reader(读取)  writer(写入)

    记忆:
        1.实际开发中, 优先使用字符流, 字符流搞不定再使用字节流
        2.如果目的文件不存在,则会自动创建
        3.只要出现乱码问题就找编码集的问题
        4.如果一个类的对象,想实现序列化和反序列化,那么一定要实现Serializable接口
 */
public class Demo1 {
}
