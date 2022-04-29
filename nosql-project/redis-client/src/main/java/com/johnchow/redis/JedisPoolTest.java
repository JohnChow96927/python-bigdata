package com.johnchow.redis;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

import java.util.Map;

public class JedisPoolTest {
    private Jedis jedis = null;

    @Before
    public void open() {
        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxTotal(8);
        config.setMinIdle(3);
        config.setMaxIdle(8);
        JedisPool jedisPool = new JedisPool(config,"node1", 6379);
        jedis = jedisPool.getResource();
    }

    @Test
    public void testString() {
        jedis.set("name", "Jack");
        System.out.println(jedis.get("name"));

        System.out.println("name exists: " + jedis.exists("name"));
        System.out.println("age exists: " + jedis.exists("age"));

        jedis.expire("name", 10);
        System.out.println(jedis.ttl("name"));
    }

    @After
    public void close() {
        if (null != jedis) jedis.close();
    }
}
