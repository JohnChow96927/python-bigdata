package c_junit;

import org.junit.Test;

// 使用junit可以让java代码有多个程序执行的入口
// 第一步: 必须先复制第三方junit.jar包(idea内置了junit, 可省略)
// 第二步: 使用第三方jar, 必须import导入
// 第三步: 书写方法(1 公共的 2 无返回值) 使用@Test注解
public class Demo3 {
    @Test
    public void add() {
        ProductDao productDao = new ProductDao();
        productDao.add();
    }

    @Test
    public void del() {
        ProductDao productDao = new ProductDao();
        productDao.del();
    }

    @Test
    public void update() {
        ProductDao productDao = new ProductDao();
        productDao.update();
    }
}
