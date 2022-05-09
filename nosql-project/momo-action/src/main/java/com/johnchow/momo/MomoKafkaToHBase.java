package com.johnchow.momo;

import org.apache.commons.lang3.StringUtils;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.Connection;
import org.apache.hadoop.hbase.client.ConnectionFactory;import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Table;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.kafka.clients.consumer.*;
import org.apache.kafka.common.TopicPartition;


import java.time.Duration;
import java.util.*;

/**
 * 实时程序: 从Kafka消费陌陌小社交数据, 解析ETL后存储HBase表
 */
public class MomoKafkaToHBase {

    private static TableName tableName = TableName.valueOf("htbl_momo_msg");
    private static byte[] cfBytes = Bytes.toBytes("info");
    private static Table table;
    // todo: 静态代码块, 构建HBase连接
    static {
        try {
            // 构建配置对象
            Configuration conf = HBaseConfiguration.create();
            conf.set("hbase.zookeeper.quorum", "node1.itcast.cn,node2.itcast.cn,node3.itcast.cn");
            // 构建连接
            Connection conn = ConnectionFactory.createConnection(conf);
            // 获取表对象
            table = conn.getTable(tableName);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws Exception {
        // TODO: 1. 从Kafka Topic队列实时消费数据
        // 1-1. 设置Kafka消费属性
        Properties props = new Properties();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "node1.itcast.cn:9092,node2.itcast.cn:9092,node3.itcast.cn:9092");
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "gid-momo-2");
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest");
        props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
        // 1-2. 创建KafkaConsumer连接对象
        KafkaConsumer<String, String> kafkaConsumer = new KafkaConsumer<>(props);
        // 1-3. 设置消费Topic
        kafkaConsumer.subscribe(Collections.singletonList("momo-msg"));
        // 1-4. 实时拉取pull数据
        while (true) {
            // 向Kafka请求拉取数据, 等待Kafka相应, 在100ms以内如果相应, 就拉取数据, 如果100ms内没有相应, 就提交下一次请求
            ConsumerRecords<String, String> consumerRecords = kafkaConsumer.poll(Duration.ofMillis(100));
            /*
                todo: 1-5. 获取每个分区数据, 存储HBase表, 最后手动提交分区偏移量
             */
            // a. 获取所有分区信息
            Set<TopicPartition> partitions = consumerRecords.partitions();
            // b. 循环遍历分区信息, 获取每个分区数据
            for (TopicPartition partition : partitions) {
                // c. 依据分区信息, 获取分区数据
                List<ConsumerRecord<String, String>> records = consumerRecords.records(partition);
                // d. 循环遍历分区数据, 获取每天数据单独处理
                long consumerOffset = 0L;
                for (ConsumerRecord<String, String> record : records) {
                    // 获取信息Message
                    String message = record.value();
                    System.out.println(message);

                    // todo: 2. 实时存储数据至HBase表
                    if (StringUtils.isNotEmpty(message) && message.split("\001").length == 20) {
                        writeMessageToHBase(message);
                    }
                    // 获取偏移量
                    consumerOffset = record.offset();
                }
                // e. 手动提交分区偏移量
                Map<TopicPartition, OffsetAndMetadata> offsets = Collections.singletonMap(partition, new OffsetAndMetadata(consumerOffset + 1));
                kafkaConsumer.commitSync(offsets);
            }
        }

    }

    /**
     * 将社交聊天数据实时写入HBase表中: message消息 -> Put对象 -> 写入表
     *
     * @param message: 社交消息
     * @throws Exception
     */
    private static void writeMessageToHBase(String message) throws Exception {
        // step1. 分割数据
        String[] items = message.split("\001");

        // step2. 构建RowKey
        /*
            RowKey = 发件人id + 消息日期 + 收件人id
         */
        String senderAccount = items[2];
        String msgTime = items[0];
        String receiverAccount = items[11];
        String rowKey = StringUtils.reverse(senderAccount) + "_" + msgTime + "_" + receiverAccount;

        // step3. 创建Put对象
        Put put = new Put(Bytes.toBytes(rowKey));

        // step4. 添加列
        put.addColumn(cfBytes, Bytes.toBytes("msg_time"), Bytes.toBytes(items[0]));
        put.addColumn(cfBytes, Bytes.toBytes("sender_nickyname"), Bytes.toBytes(items[1]));
        put.addColumn(cfBytes, Bytes.toBytes("sender_account"), Bytes.toBytes(items[2]));
        put.addColumn(cfBytes, Bytes.toBytes("sender_sex"), Bytes.toBytes(items[3]));
        put.addColumn(cfBytes, Bytes.toBytes("sender_ip"), Bytes.toBytes(items[4]));
        put.addColumn(cfBytes, Bytes.toBytes("sender_os"), Bytes.toBytes(items[5]));
        put.addColumn(cfBytes, Bytes.toBytes("sender_phone_type"), Bytes.toBytes(items[6]));
        put.addColumn(cfBytes, Bytes.toBytes("sender_network"), Bytes.toBytes(items[7]));
        put.addColumn(cfBytes, Bytes.toBytes("sender_gps"), Bytes.toBytes(items[8]));
        put.addColumn(cfBytes, Bytes.toBytes("receiver_nickyname"), Bytes.toBytes(items[9]));
        put.addColumn(cfBytes, Bytes.toBytes("receiver_ip"), Bytes.toBytes(items[10]));
        put.addColumn(cfBytes, Bytes.toBytes("receiver_account"), Bytes.toBytes(items[11]));
        put.addColumn(cfBytes, Bytes.toBytes("receiver_os"), Bytes.toBytes(items[12]));
        put.addColumn(cfBytes, Bytes.toBytes("receiver_phone_type"), Bytes.toBytes(items[13]));
        put.addColumn(cfBytes, Bytes.toBytes("receiver_network"), Bytes.toBytes(items[14]));
        put.addColumn(cfBytes, Bytes.toBytes("receiver_gps"), Bytes.toBytes(items[15]));
        put.addColumn(cfBytes, Bytes.toBytes("receiver_sex"), Bytes.toBytes(items[16]));
        put.addColumn(cfBytes, Bytes.toBytes("msg_type"), Bytes.toBytes(items[17]));
        put.addColumn(cfBytes, Bytes.toBytes("distance"), Bytes.toBytes(items[18]));
        put.addColumn(cfBytes, Bytes.toBytes("message"), Bytes.toBytes(items[19]));

        // step5. 执行写入
        table.put(put);
    }
}
