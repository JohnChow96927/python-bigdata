package com.johnchow.kafka.producer;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.util.Properties;

public class KafkaWriteAckTest {
    public static void main(String[] args) {
        // TODO: 1. 构建KafkaProducer对象
        Properties props = new Properties();
        // Kafka Brokers地址
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "node1.itcast.cn:9092,node2.itcast.cn:9092,node3.itcast.cn:9092");
        // 写入数据时Key和Value类型
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer");
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer");
        // TODO: 设置数据发送确认机制ack
        props.put(ProducerConfig.ACKS_CONFIG, "-1");
        // 传递属性, 创建对象
        KafkaProducer<String, String> kafkaProducer = new KafkaProducer<String, String>(props);
        // TODO: 2. 构建ProducerRecord实例, 封装数据
        ProducerRecord<String, String> producerRecord = new ProducerRecord<>("test-topic", "hello Shuang!");
        // TODO: 3. 调用send方法, 发送数据至Topic
        kafkaProducer.send(producerRecord);
        // TODO: 4. 关闭资源
        kafkaProducer.close();
    }
}
