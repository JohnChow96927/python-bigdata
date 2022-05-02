package com.johnchow.hbase;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.*;
import org.apache.hadoop.hbase.client.*;
import org.apache.hadoop.hbase.filter.PrefixFilter;
import org.apache.hadoop.hbase.filter.SingleColumnValueFilter;
import org.apache.hadoop.hbase.util.Bytes;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

/**
 * 使用HBase Java Client API对数据库进行DML操作:
 *      TODO: 插入数据put, 删除数据delete, 查询数据get, 扫描数据scan
 */
public class HBaseDmlTest {
    // 定义连接Connection
    private Connection conn = null;

    @Before
    public void open() throws Exception {
        // 1-1. 设置连接属性
        Configuration conf = HBaseConfiguration.create();
        // 设置HBase依赖ZK集群地址
        conf.set("hbase.zookeeper.quorum", "node1.itcast.cn,node2.itcast.cn,node3.itcast.cn");
        // 1-2. 传递配置, 构建连接
        conn = ConnectionFactory.createConnection(conf);
    }

    // 创建HBase Table表的对象
    public Table getHTable() throws Exception {
        // TableName对象
        TableName tableName = TableName.valueOf("itcast:students");
        // 获取Table表句柄对象
        Table table = conn.getTable(tableName);
        // 返回实例
        return table;
    }

    // 测试Table对象
    @Test
    public void testTable() throws Exception {
        System.out.println(getHTable());
    }

    // 插入数据Put
    @Test
    public void testPut() throws Exception {
        // a. 获取Table对象
        Table table = getHTable();
        // b. TODO: 构建Put对象, 表示1个RowKey数据, 指定RowKey
        Put put = new Put(Bytes.toBytes("20220501_001"));
        // 添加列
        put.addColumn(Bytes.toBytes("basic"), Bytes.toBytes("name"), Bytes.toBytes("laoda"));
        put.addColumn(Bytes.toBytes("basic"), Bytes.toBytes("age"), Bytes.toBytes("18"));
        put.addColumn(Bytes.toBytes("other"), Bytes.toBytes("phone"), Bytes.toBytes("110"));
        put.addColumn(Bytes.toBytes("other"), Bytes.toBytes("address"), Bytes.toBytes("beijing"));
        // c. 插入数据
        table.put(put);
        // d. 关闭连接
        table.close();
    }

    // 批量插入数据Put
    @Test
    public void testBatchPut() throws Exception {
        // a. 获取Table对象
        Table table = getHTable();
        // b. TODO: 构建Put对象, 表示一个RowKey数据, 指定RowKey
        List<Put> listPut = new ArrayList<>();
        // 第1条数据
        Put put1 = new Put(Bytes.toBytes("20220501_002"));
        put1.addColumn(Bytes.toBytes("basic"), Bytes.toBytes("name"), Bytes.toBytes("laoer"));
        put1.addColumn(Bytes.toBytes("basic"), Bytes.toBytes("age"), Bytes.toBytes("16"));
        put1.addColumn(Bytes.toBytes("basic"), Bytes.toBytes("gender"), Bytes.toBytes("male"));
        put1.addColumn(Bytes.toBytes("other"), Bytes.toBytes("phone"), Bytes.toBytes("120"));
        put1.addColumn(Bytes.toBytes("other"), Bytes.toBytes("address"), Bytes.toBytes("shanghai"));
        listPut.add(put1);
        // 第2条数据
        Put put2 = new Put(Bytes.toBytes("20220501_003"));
        put2.addColumn(Bytes.toBytes("basic"), Bytes.toBytes("name"), Bytes.toBytes("laosan"));
        put2.addColumn(Bytes.toBytes("basic"), Bytes.toBytes("age"), Bytes.toBytes("16"));
        put2.addColumn(Bytes.toBytes("other"), Bytes.toBytes("address"), Bytes.toBytes("hangzhou"));
        listPut.add(put2);
        // 第3条数据
        Put put3 = new Put(Bytes.toBytes("20220501_004"));
        put3.addColumn(Bytes.toBytes("basic"), Bytes.toBytes("name"), Bytes.toBytes("laosi"));
        put3.addColumn(Bytes.toBytes("basic"), Bytes.toBytes("age"), Bytes.toBytes("24"));
        put3.addColumn(Bytes.toBytes("other"), Bytes.toBytes("job"), Bytes.toBytes("programmer"));
        put3.addColumn(Bytes.toBytes("other"), Bytes.toBytes("address"), Bytes.toBytes("shanghai"));
        listPut.add(put3);
        // 第4条数据
        Put put4 = new Put(Bytes.toBytes("20220501_005"));
        put4.addColumn(Bytes.toBytes("basic"), Bytes.toBytes("name"), Bytes.toBytes("laoer"));
        put4.addColumn(Bytes.toBytes("other"), Bytes.toBytes("job"), Bytes.toBytes("doctor"));
        listPut.add(put4);
        // c. 插入数据
        table.put(listPut);
        // d. 关闭连接
        table.close();
    }

    // 依据RowKey查询数据
    @Test
    public void testGet() throws Exception {
        // a. 获取Table对象
        Table table = getHTable();
        // b. 构建Get对象, 传递RowKey
        Get get = new Get(Bytes.toBytes("20220501_002"));
        // c. 设置指定列族及列名称
        get.addFamily(Bytes.toBytes("basic"));
        get.addColumn(Bytes.toBytes("other"), Bytes.toBytes("address"));
        // d. 查询数据
        Result result = table.get(get);
        // e. 遍历每列数据，封装在KeyValue中，此处为Cell单元
        for (Cell cell : result.rawCells()) {
            // 使用CellUtil工具类，获取值
            String rowKey = Bytes.toString(CellUtil.cloneRow(cell));
            String family = Bytes.toString(CellUtil.cloneFamily(cell));
            String column = Bytes.toString(CellUtil.cloneQualifier(cell));
            String value = Bytes.toString(CellUtil.cloneValue(cell));
            long version = cell.getTimestamp();
            System.out.println(rowKey + "\tcolumn=" + family + ":" + column + ", timestamp=" + version + ", value=" + value);
        }
        // f. 关闭连接
        table.close();
    }

    // 依据RowKey删除数据
    @Test
    public void testDelete() throws Exception {
        // a. 获取Table对象
        Table table = getHTable();
        // b. 构建Delete对象, 传递RowKey
        Delete delete = new Delete(Bytes.toBytes("20220501_004"));
        // c. 添加删除列族及列名
        delete.addFamily(Bytes.toBytes("other"));
        delete.addColumn(Bytes.toBytes("basic"), Bytes.toBytes("age"));
        // d. 执行删除
        table.delete(delete);
        // e. 关闭连接
        table.close();
    }

    // 使用Scan全表扫描查询数据
    @Test
    public void testScan() throws Exception {
        // a. 获取Table对象
        Table table = getHTable();
        // b. 构建Scan对象
        Scan scan = new Scan();
        scan.addFamily(Bytes.toBytes("basic"));
        scan.addColumn(Bytes.toBytes("other"), Bytes.toBytes("address"));
        // c. 扫描表的数据
        ResultScanner resultScanner = table.getScanner(scan);
        // d. 循环遍历, 获取每条数据Result
        for (Result result : resultScanner) {
            // 获取RowKey值
            System.out.println(Bytes.toString(result.getRow()));
            // 遍历每行数据中所有Cell, 获取相应列族, 列名称, 值等
            for (Cell cell : result.rawCells()) {
                // 使用CellUtil工具类获取值
                String family = Bytes.toString(CellUtil.cloneFamily(cell));
                String column = Bytes.toString(CellUtil.cloneQualifier(cell));
                String value = Bytes.toString(CellUtil.cloneValue(cell));
                long version = cell.getTimestamp();
                System.out.println("\t" + family + ":" + column + ", timestamp = " + version + ", value = " + value);
            }
        }
        // e. 关闭连接
        table.close();
    }

    // 需求1：查询2022年3月和4月的数据
    @Test
    public void testScanFilter_V1() throws Exception {
        // a. 获取Table对象
        Table table = getHTable();
        // b. 构建Scan对象
        Scan scan = new Scan();
        // TODO: 设置startRow和stopRow
        scan.withStartRow(Bytes.toBytes("202203"));
        scan.withStopRow(Bytes.toBytes("202205"));
        // c. 扫描表的数据
        ResultScanner resultScanner = table.getScanner(scan);
        // d. 循环遍历，获取每条数据Result
        for (Result result : resultScanner) {
            // 获取RowKey值
            System.out.println(Bytes.toString(result.getRow()));
            // 遍历每行数据中所有Cell，获取相应列族、列名称、值等
            for (Cell cell : result.rawCells()) {
                // 使用CellUtil工具类，获取值
                String family = Bytes.toString(CellUtil.cloneFamily(cell));
                String column = Bytes.toString(CellUtil.cloneQualifier(cell));
                String value = Bytes.toString(CellUtil.cloneValue(cell));
                long version = cell.getTimestamp();
                System.out.println("\t" + family + ":" + column + ", timestamp=" + version + ", value=" + value);
            }
        }
        // e. 关闭连接
        table.close();
    }

    // 需求2：查询2022年5月的所有数据
    @Test
    public void testScanFilter_V2() throws Exception {
        // a. 获取Table对象
        Table table = getHTable();
        // b. 构建Scan对象
        Scan scan = new Scan();
        // TODO: 添加过滤器Filter
        PrefixFilter prefixFilter = new PrefixFilter(Bytes.toBytes("202205"));
        scan.setFilter(prefixFilter);
        // c. 扫描表的数据
        ResultScanner resultScanner = table.getScanner(scan);
        // d. 循环遍历，获取每条数据Result
        for (Result result : resultScanner) {
            // 获取RowKey值
            System.out.println(Bytes.toString(result.getRow()));
            // 遍历每行数据中所有Cell，获取相应列族、列名称、值等
            for (Cell cell : result.rawCells()) {
                // 使用CellUtil工具类，获取值
                String family = Bytes.toString(CellUtil.cloneFamily(cell));
                String column = Bytes.toString(CellUtil.cloneQualifier(cell));
                String value = Bytes.toString(CellUtil.cloneValue(cell));
                long version = cell.getTimestamp();
                System.out.println("\t" + family + ":" + column + ", timestamp=" + version + ", value=" + value);
            }
        }
        // e. 关闭连接
        table.close();
    }

    // 需求3：查询所有age = 24的数据
    @Test
    public void testScanFilter_V3() throws Exception {
        // a. 获取Table对象
        Table table = getHTable();
        // b. 构建Scan对象
        Scan scan = new Scan();
        // TODO: 添加过滤器Filter
        SingleColumnValueFilter singleColumnValueFilter = new SingleColumnValueFilter(
                Bytes.toBytes("basic"), Bytes.toBytes("age"), CompareOperator.EQUAL, Bytes.toBytes("24")
        );
        scan.setFilter(singleColumnValueFilter);
        // c. 扫描表的数据
        ResultScanner resultScanner = table.getScanner(scan);
        // d. 循环遍历，获取每条数据Result
        for (Result result : resultScanner) {
            // 获取RowKey值
            System.out.println(Bytes.toString(result.getRow()));
            // 遍历每行数据中所有Cell，获取相应列族、列名称、值等
            for (Cell cell : result.rawCells()) {
                // 使用CellUtil工具类，获取值
                String family = Bytes.toString(CellUtil.cloneFamily(cell));
                String column = Bytes.toString(CellUtil.cloneQualifier(cell));
                String value = Bytes.toString(CellUtil.cloneValue(cell));
                long version = cell.getTimestamp();
                System.out.println("\t" + family + ":" + column + ", timestamp=" + version + ", value=" + value);
            }
        }
        // e. 关闭连接
        table.close();
    }

    @After
    public void close() throws Exception {
        if (null != conn) conn.close();
    }
}

