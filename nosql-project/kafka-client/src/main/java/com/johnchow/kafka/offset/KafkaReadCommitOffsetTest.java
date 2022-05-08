package com.johnchow.kafka.offset;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;

import java.time.Duration;
import java.util.Collections;
import java.util.Properties;

public class KafkaReadCommitOffsetTest {
    public static void main(String[] args) {
        // TODO: 1. 构建KafkaConsumer连接对象
        Properties props = new Properties();
        // 指定Kafka服务集群地址
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
        // 指定消费组ID
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "gid-1001");
        // TODO: 第一次消费起始位置
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest");
        // TODO: 关闭自动提交偏移
        props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
        // 传递参数创建连接
        KafkaConsumer<String, String> kafkaConsumer = new KafkaConsumer<String, String>(props);

        // TODO: 2. 指定topic名称, 消费数据
        // 设置消费topic名称, 可以是多个队列
        kafkaConsumer.subscribe(Collections.singletonList("test-topic"));
        // 拉取数据, 一直消费数据
        while (true) {
            ConsumerRecords<String, String> records = kafkaConsumer.poll(Duration.ofMillis(100));
            // 循环遍历拉取数据
            for (ConsumerRecord<String, String> record : records) {
                // TODO: 3. 获取每条消息具体值
                String topic = record.topic();
                int partition = record.partition();
                String key = record.key();
                String message = record.value();
                long timestamp = record.timestamp();
                // 获取偏移量
                long offset = record.offset();
                System.out.println(topic + "\t" + partition + "\t" + offset + "\t" + key + "\t" + message + "\t" + timestamp);

            }
            // 手动提交偏移量
            kafkaConsumer.commitSync();
        }
    }
}
