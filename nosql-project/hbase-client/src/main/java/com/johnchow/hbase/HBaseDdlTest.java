package com.johnchow.hbase;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.NamespaceDescriptor;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;
import org.apache.hadoop.hbase.util.Bytes;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

/*
使用HBase Java Client API对数据进行DDL操作:
    TODO: 创建命名空间namespace\ 创建表table(如果表存在, 先禁用, 再删除)
 */
public class HBaseDdlTest {
    // 定义连接Connection
    private Connection conn = null;

    @Before
    public void open() throws Exception {
        Configuration conf = HBaseConfiguration.create();
        conf.set("hbase.zookeeper.quorum", "node1.itcast.cn,node2.itcast.cn,node3.itcast.cn");
        conn = ConnectionFactory.createConnection(conf);
    }

    // TODO: 创建命名空间namespace
    @Test
    public void createNamespace() throws Exception {
        // a. 获取Admin对象
        HBaseAdmin admin = (HBaseAdmin) conn.getAdmin();
        // b. 构建命名空间描述符, 设置属性
        NamespaceDescriptor descriptor = NamespaceDescriptor.create("itcast").build();
        // c. 创建命名空间
        admin.createNamespace(descriptor);
        // d. 关闭
        admin.close();
    }

    // TODO: 创建表, 如果表存在, 先删除, 再创建
    @Test
    public void createTable() throws Exception {
        // a. 获取Admin对象
        HBaseAdmin admin = (HBaseAdmin) conn.getAdmin();
        // b. 构建表的对象
        TableName tableName = TableName.valueOf("itcast:students");
        // c. 判断表是否存在, 如果存在, 将其删除
        if (admin.tableExists(tableName)) {
            // 禁用表
            admin.disableTable(tableName);
            // 删除表
            admin.deleteTable(tableName);
        }
        // d. 创建表
        ColumnFamilyDescriptor familyBasic = ColumnFamilyDescriptorBuilder.newBuilder(Bytes.toBytes("basic")).build();
        ColumnFamilyDescriptor familyOther = ColumnFamilyDescriptorBuilder.newBuilder(Bytes.toBytes("other")).build();
        TableDescriptor desc = TableDescriptorBuilder.newBuilder(tableName).setColumnFamily(familyBasic).setColumnFamily(familyOther).build();
        admin.createTable(desc);
        // 关闭连接
        admin.close();
    }

    @After
    public void close() throws Exception {
        if (null != conn) conn.close();
    }

}
