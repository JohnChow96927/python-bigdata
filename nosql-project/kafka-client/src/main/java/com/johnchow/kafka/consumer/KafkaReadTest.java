package com.johnchow.kafka.consumer;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;

import java.time.Duration;
import java.util.Collections;
import java.util.Properties;
import java.util.function.Consumer;

public class KafkaReadTest {
    public static void main(String[] args) {
        // TODO: 1. 构建KafkaConsumer连接对象
        // 1-1. 构建Consumer配置信息
        Properties props = new Properties();
        // 指定服务端地址
        props.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "node1.itcast.cn:9092,node2.itcast.cn:9092,node3.itcast.cn:9092");
        // 指定当前消费者属于哪个组
        props.setProperty(ConsumerConfig.GROUP_ID_CONFIG, "gid-10001");
        // 读取数据对KV进行反序列化
        props.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
        props.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
        // 1-2. 构建消费者对象
        KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);

        // TODO: 2. 消费数据
        // 2-1. 设置订阅topic
        consumer.subscribe(Collections.singletonList("test-topic"));
        // 2-2. 拉取数据
        while (true) {
            // 拉取订阅topic中数据, 设置超时时间
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));
            // 循环遍历拉取的数据
            for (ConsumerRecord<String, String> record : records) {
                String topic = record.topic();
                int part = record.partition();
                String key = record.key();
                String value = record.value();
                // 模拟处理: 输出
                System.out.println(topic + "\t" + part + "\t" + key + "\t" + value);
            }
        }
//        consumer.close();
    }
}
