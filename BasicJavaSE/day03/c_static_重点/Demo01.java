package cn.itcast.day03.c_static_重点;

public class Demo01 {
    public static void main(String[] args) {
        double r = Math.random();
        // 碰到静态的方法 类名.方法名() 就可以调用了
        A_animal.show2();

        // 碰到非静态的方法, 必须new对象才可以调用
        A_animal a1 = new A_animal();
        a1.show1();
        // 事实: 对象既可以调用静态方法, 也可以调用非静态方法
        a1.show2();
    }
}

class A_animal {
    // 碰到非静态的方法, 必须new对象才可以调用
    public void show1() {
        System.out.println("1 调用非static的方法 show1() ... ...");
    }

    // 碰到静态的方法 类名.方法名() 就可以调用了
    public static void show2() {
        System.out.println("2 调用static的方法 show2() ... ...");
    }
}
