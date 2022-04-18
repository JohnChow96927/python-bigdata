package c_junit;

import org.junit.Test;

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
