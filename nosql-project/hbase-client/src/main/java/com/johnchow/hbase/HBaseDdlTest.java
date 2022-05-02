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
        HBaseAdmin admin = (HBaseAdmin) conn.getAdmin();
        NamespaceDescriptor descriptor = NamespaceDescriptor.create("itcast").build();
        admin.createNamespace(descriptor);
        admin.close();
    }

    // TODO: 创建表, 如果表存在, 先删除, 再创建
    @Test
    public void createTable() throws Exception {
        HBaseAdmin admin = (HBaseAdmin) conn.getAdmin();
        TableName tableName = TableName.valueOf("itcast:students");
        if (admin.tableExists(tableName)) {
            admin.disableTable(tableName);
            admin.deleteTable(tableName);
        }
        ColumnFamilyDescriptor familyBasic = ColumnFamilyDescriptorBuilder.newBuilder(Bytes.toBytes("basic")).build();
        ColumnFamilyDescriptor familyOther = ColumnFamilyDescriptorBuilder.newBuilder(Bytes.toBytes("other")).build();
        TableDescriptor desc = TableDescriptorBuilder.newBuilder(tableName).setColumnFamily(familyBasic).setColumnFamily(familyOther).build();
        admin.createTable(desc);
        admin.close();
    }

    @After
    public void close() throws Exception {
        if (null != conn) conn.close();
    }

}
