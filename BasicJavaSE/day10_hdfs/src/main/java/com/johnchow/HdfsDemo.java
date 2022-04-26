package com.johnchow;

import org.apache.commons.io.IOUtils;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.*;
import org.junit.Test;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URI;

public class HdfsDemo {
    @Test
    public void getFileSystem() throws IOException {
        Configuration configuration = new Configuration();
        configuration.set("fs.defaultFS", "hdfs://hadoop.bigdata.cn:9000");
        FileSystem fileSystem = FileSystem.get(configuration);
        System.out.println(fileSystem.toString());
    }

    @Test
    public void getFileSystem2() throws Exception {
        FileSystem fileSystem = FileSystem.get(new URI("hdfs://hadoop.bigdata.cn:9000"), new Configuration());
        System.out.println("fileSystem:" + fileSystem);
    }

    @Test
    public void show1() throws Exception {
        //LocalFileSystem 当前win文件系统对象 (C D E F)
        Configuration conf1 = new Configuration();
        FileSystem fs1 = FileSystem.newInstance(conf1);
        System.out.println(fs1);
        System.out.println("-------------------");
        //获取hdfs的文件系统对象 但是用户名使用的是本机的
        Configuration conf2 = new Configuration();
        conf2.set("fs.defaultFS", "hdfs://node1:9000");
        FileSystem fs2 = FileSystem.newInstance(conf2);
        System.out.println(fs2);
        System.out.println("-------------------");
        //获取hdfs的文件系统对象 设置用户名
        //URI uri, 地址 file:///  虚拟机:  hdfs://
        // final Configuration conf, 配置文件对象
        // String user 用户名
        //伪装一个用户 创建文件系统对象
        FileSystem fs3 = FileSystem.newInstance(new URI("hdfs://node1:9000"), new Configuration(), "root");
        System.out.println(fs3);
    }
    //查看根节点下 所有的文件
    @Test
    public void show2() throws Exception{
        //1.获取文件系统对象
        FileSystem fileSystem = FileSystem.newInstance(new URI("hdfs://node1:9000"), new Configuration(), "root");
        //2.获取根路径下所有的文件(集合/迭代器/数组)
        //final Path f, 路径
        //final boolean recursive 是否递归 true代表递归
        //文件状态对象的迭代器
        RemoteIterator<LocatedFileStatus> listFiles = fileSystem.listFiles(new Path("/"), true);
        //获取每一个文件状态的对象
        while(listFiles.hasNext()){
            LocatedFileStatus fileStatus = listFiles.next();
            System.out.println(fileStatus.getPath());//获取文件路径
            System.out.println(fileStatus.getPath().getName());//获取文件名
            System.out.println("-----------------------------------------------------------------------");
        }
        //释放资源
        fileSystem.close();
    }
    @Test
    public void mkdirs() throws  Exception{
        FileSystem fileSystem = FileSystem.get(new URI("hdfs://node01:8020"), new Configuration());
        boolean mkdirs = fileSystem.mkdirs(new Path("/hello/mydir/test"));
        fileSystem.close();
    }

    @Test
    public void getFileToLocal()throws  Exception{
        FileSystem fileSystem = FileSystem.get(new URI("hdfs://node01:8020"), new Configuration());
        FSDataInputStream inputStream = fileSystem.open(new Path("/timer.txt"));
        FileOutputStream outputStream = new FileOutputStream("e:\\timer.txt");
        IOUtils.copy(inputStream,outputStream );
        IOUtils.closeQuietly(inputStream);
        IOUtils.closeQuietly(outputStream);
        fileSystem.close();
    }

    @Test
    public void putData() throws  Exception{
        FileSystem fileSystem = FileSystem.get(new URI("hdfs://node1:8020"), new Configuration());
        fileSystem.copyFromLocalFile(new Path("file:///c:\\install.log"),new Path("/hello/mydir/test"));
        fileSystem.close();
    }
}
