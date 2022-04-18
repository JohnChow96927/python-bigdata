package cn.itcast.day04.c_junit;

import org.junit.Test;

// 为什么? 使用junit可以让java代码有多个程序执行的入口
// how 使用套路1
// 第一步: 必须先复制第三方 junit.jar包 (因为 idea 内置了junit, 所以可以省略不写 )
// 第二步: 使用第三方的jar, 必须import导入
// 第三步: 书写方法(1 公共的 2 无返回值) 使用注解
public class Demo03 {
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
