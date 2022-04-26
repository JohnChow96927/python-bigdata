package chow.pkage.dao;


import org.junit.Test;

public class ProductDaoTest {

    @Test
    public void add() throws Exception {
        ProductDao productDao = new ProductDao();
        productDao.add();
    }

    @Test
    public void del() throws Exception {
        ProductDao productDao = new ProductDao();
        productDao.del();
    }

    @Test
    public void edit() throws Exception {
        ProductDao productDao = new ProductDao();
        productDao.edit();
    }

    @Test
    public void query() throws Exception {
        ProductDao productDao = new ProductDao();
        productDao.query();
    }
}