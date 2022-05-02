package com.johnchow.hbase;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.client.Connection;
import org.apache.hadoop.hbase.client.ConnectionFactory;

import java.io.IOException;


/*
使用HBase Client API获取连接, 类似Java JDBC获取MySQL数据库连接
 */
public class HBaseClientTest {
    public static void main(String[] args) throws Exception {
        // TODO: 1. 设置参数, 获取连接
        // 1-1. 设置连接属性
        Configuration conf = HBaseConfiguration.create();
        // 设置HBase依赖ZK集群地址
        conf.set("hbase.zookeeper.quorum", "node1.itcast.cn,node2.itcast.cn,node3.itcast.cn");
        // 1-2. 传递配置, 构建连接
        Connection conn = ConnectionFactory.createConnection(conf);
        System.out.println(conn);

        // TODO: 2. 使用连接, 进行数据操作

        // TODO: 3. 关闭连接, 释放资源
        conn.close();
    }
}
