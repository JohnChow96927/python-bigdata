package cn.itcast.day03.e_interface_重点;

public class Demo02 {
    public static void main(String[] args) {
        Car car = new Car();
        run(car);

        Swimable swimable = new Car();
        run(swimable);
    }

    public static void run(Swimable swimable) {
        swimable.swim();
    }
}

interface Swimable {
    void swim();
}

interface Flyable {
    void fly();
}

// 事实3: 类与接口之间是实现关系 implements
// 事实2: 类与类之间是继承关系, 接口与接口之间也是继承关系 使用 extends 关键字
interface SwimAndFlyable extends Swimable, Flyable {

}

// 事实: 一个类可以实现多个接口
//class Car implements Swimable, Flyable {
class Car implements SwimAndFlyable {
    @Override
    public void swim() {
        System.out.println("咱们使用XX技术可以在水下行驶!");
    }

    @Override
    public void fly() {
        System.out.println("咱们使用XX技术可以在一万米高空行驶!");
    }
}
