package com.johnchow.redis;

import redis.clients.jedis.Jedis;

public class JedisConnTest {
    public static void main(String[] args) {
        Jedis jedis = new Jedis("node1", 6379);
        jedis.select(0);
        String pingValue = jedis.ping();
        System.out.println(pingValue);
        jedis.close();
    }
}
