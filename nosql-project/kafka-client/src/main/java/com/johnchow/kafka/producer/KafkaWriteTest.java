package com.johnchow.kafka.producer;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.util.Properties;

public class KafkaWriteTest {
    public static void main(String[] args) {
        // TODO: 1. 构建KafkaProducer连接对象
        // 1-1. 设置Producer属性
        Properties props = new Properties();
        // Kafka Broker地址信息
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "node1.itcast.cn:9092,node2.itcast.cn:9092,node3.itcast.cn:9092");
        // 吸入数据时序列化和反序列化方式
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer");
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer");
        // 1-2. 传递配置, 创建Producer实例
        KafkaProducer<String, String> producer = new KafkaProducer<>(props);

        // TODO: 2. 构建ProducerRecord记录实例
        ProducerRecord<String, String> record = new ProducerRecord<String, String>("test-topic","hello world");

        // TODO: 3. 调用send方法, 发送数据至Topic
        producer.send(record);

        // TODO: 4. 关闭资源
        producer.close();
    }
}
