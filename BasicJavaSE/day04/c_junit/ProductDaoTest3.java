package cn.itcast.day04.c_junit;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class ProductDaoTest3 {

    ProductDao productDao = new ProductDao();

    @Before
    public void init() {
        // 执行初始化动作: 主要是注解 @Before, 方法名是任意的
        System.out.println("1 连接数据库");
    }

    @After
    public void destory() {
        // 执行销毁动作: 主要是注解 @After, 方法名是任意的
        System.out.println("2 释放数据库连接");
    }


    @Test
    public void add() {
        productDao.add();
    }

    @Test
    public void del() {
        productDao.del();
    }

    @Test
    public void update() {
        productDao.update();
    }

    @Test
    public void query() {
        productDao.query();
    }
}