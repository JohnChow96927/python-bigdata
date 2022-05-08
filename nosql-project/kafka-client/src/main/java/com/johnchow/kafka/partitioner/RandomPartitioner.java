package com.johnchow.kafka.partitioner;

import org.apache.kafka.clients.producer.Partitioner;
import org.apache.kafka.common.Cluster;

import java.util.Map;
import java.util.Random;

public class RandomPartitioner implements Partitioner {

    @Override
    public int partition(String topic, Object key, byte[] keyBytes, Object value, byte[] valueBytes, Cluster cluster) {
        // 获取Topic中分区数目
        Integer count = cluster.partitionCountForTopic(topic);
        // 构建随机数
        Random random = new Random();
        // 随机生成一个分区编号
        int partitionID = random.nextInt(count);
        // 返回分区编号ID
        return partitionID;
    }

    @Override
    public void close() {

    }

    @Override
    public void configure(Map<String, ?> configs) {

    }
}
