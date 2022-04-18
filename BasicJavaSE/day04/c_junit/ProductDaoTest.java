package cn.itcast.day04.c_junit;

import org.junit.Test;

import static org.junit.Assert.*;

public class ProductDaoTest {

    ProductDao productDao = new ProductDao();

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