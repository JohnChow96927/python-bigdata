package com.johnchow.kafka.offset;

import org.apache.kafka.clients.consumer.*;
import org.apache.kafka.common.TopicPartition;

import java.time.Duration;
import java.util.*;

public class KafkaReadCommitPartitionOffsetTest {
    public static void main(String[] args) {
        // TODO: 1. 构建KafkaConsumer连接对象
        Properties props = new Properties();
        // 指定Kafka服务集群地址
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "node1.itcast.cn:9092,node2.itcast.cn:9092,node3.itcast.cn:9092");
        // 指定消费数据key和value类型，此处从topic文件中读数据，反序列化
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
        // 指定消费组ID
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "gid-1001");
        // todo: 第一次消费起始位置
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest");
        // todo: 关闭自动提交偏移
        props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
        // 传递参数，创建连接
        KafkaConsumer<String, String> kafkaConsumer = new KafkaConsumer<String, String>(props);

        // TODO: 2. 指定topic名称, 消费数据
        // 设置消费topic名称, 可以是多个队列
        kafkaConsumer.subscribe(Collections.singletonList("test-topic"));
        // 拉取数据，一直消费数据
        while (true) {
            // 设置超时时间，可以理解为每隔多久拉取一次数据
            ConsumerRecords<String, String> records = kafkaConsumer.poll(Duration.ofMillis(100));
            // 第1步、获取拉取数据的分区信息
            Set<TopicPartition> partitions = records.partitions();
            // 第2步、获取每个分区数据，进行消费
            for (TopicPartition partition : partitions) {
                // 分区数据
                List<ConsumerRecord<String, String>> partitionRecords = records.records(partition);
                // 遍历消费
                long consumerOffset = 0;
                for (ConsumerRecord<String, String> record : partitionRecords) {
                    String topic = record.topic();
                    int part = record.partition();
                    long offset = record.offset();
                    String key = record.key();
                    String value = record.value();
                    //模拟处理：输出
                    System.out.println(topic + "\t" + part + "\t" + offset + "\t" + key + "\t" + value);
                    // 记录消费偏移量
                    consumerOffset = offset;
                }
                // TODO: 每个分区数据处理完成, 手动提交offset
                Map<TopicPartition, OffsetAndMetadata> offsets = new HashMap<>();
                offsets.put(partition, new OffsetAndMetadata(consumerOffset));
                kafkaConsumer.commitSync(offsets);
            }
        }
        // TODO: 4. 关闭连接
        // kafkaConsumer.close();
    }
}
