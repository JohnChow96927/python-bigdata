package c_junit;

import org.junit.Test;

public class ProductDaoTest2 {
    ProductDao productDao = new ProductDao();

    @Test
    public void add() {
        System.out.println("1 连接数据库");
        productDao.add();
        System.out.println("2 释放数据库连接");
    }

    @Test
    public void del() {
        System.out.println("1 连接数据库");
        productDao.del();
        System.out.println("2 释放数据库连接");
    }

    @Test
    public void update() {
        System.out.println("1 连接数据库");
        productDao.update();
        System.out.println("2 释放数据库连接");
    }

    @Test
    public void query() {
        System.out.println("1 连接数据库");
        productDao.query();
        System.out.println("2 释放数据库连接");
    }
}
