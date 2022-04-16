package cn.itcast.day03.e_interface_重点;

public class Demo01 {

}

// 定义了一个接口
interface A_Animal {
    void eat();

    void shout();

    void run();
}

// 类和接口之间是实现关系: 使用关键字 implements
class Dog implements A_Animal {
    @Override
    public void eat() {

    }

    @Override
    public void shout() {

    }

    @Override
    public void run() {

    }
}

