package com.johnchow.redis;

import redis.clients.jedis.*;

import java.util.HashSet;

/**
 * Jedis连接Redis Cluster集群，进行操作数据
 */
public class JedisClusterTest {
    public static void main(String[] args) {
        // TODO: 1. 获取连接
        // 1-1. 连接池设置
        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxTotal(8); // 连接池中总的连接数
        config.setMaxIdle(5); // 连接池中最大连接空闲数，连接未被使用数目
        config.setMinIdle(2); // 连接池中最小连接空闲数
        config.setMaxWaitMillis(5000); // 最大等待时间
        // 1-2. 集群地址和端口号
        HashSet<HostAndPort> set = new HashSet<>();
        set.add(new HostAndPort("node1.itcast.cn", 7001));
        set.add(new HostAndPort("node1.itcast.cn", 7002));
        set.add(new HostAndPort("node2.itcast.cn", 7001));
        set.add(new HostAndPort("node2.itcast.cn", 7002));
        set.add(new HostAndPort("node3.itcast.cn", 7001));
        set.add(new HostAndPort("node3.itcast.cn", 7002));

        // 1-3. 获取连接
        JedisCluster jedisCluster = new JedisCluster(set, 2000, 2000, 5, config);

        // TODO: 2. 使用连接，操作数据
        jedisCluster.set("name", "shuang");
        System.out.println(jedisCluster.get("name"));

        // TODO: 3. 关闭连接
        jedisCluster.close();
    }

}