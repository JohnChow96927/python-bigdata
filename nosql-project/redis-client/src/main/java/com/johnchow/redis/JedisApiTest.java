package com.johnchow.redis;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import redis.clients.jedis.Jedis;

import java.util.Map;

public class JedisApiTest {
    private Jedis jedis = null;

    @Before
    public void open() {
        jedis = new Jedis("node1", 6379);
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

    @Test
    public void testHash() {
        jedis.hset("user:1", "name", "豪哥");
        jedis.hset("user:1", "age", "25");
        jedis.hset("user:1", "gender", "male");

        Map<String, String> map = jedis.hgetAll("user:1");
        System.out.println(map);
    }

    @After
    public void close() {
        if (null != jedis) jedis.close();
    }
}
