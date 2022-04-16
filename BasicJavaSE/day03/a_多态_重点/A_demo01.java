package cn.itcast.day03.a_多态_重点;

public class A_demo01 {
    public static void main(String[] args) {
        // 目标: 多态的入门 本质
        A_Dog dog = new A_Dog();
        dog.shout(); // 子类 汪汪汪 ... ...

        A_Animal a1 = new A_Dog();
        a1.shout(); // 子类 汪汪汪 ... ...
    }
}

// 多态的套路: 1 有继承关系 2 方法覆写 3 让父类对象指向子类对象
class A_Animal {
    public void shout() {
        System.out.println("父类 动物在叫 ......");
    }
}

// 1 有继承关系
class A_Dog extends A_Animal {
    //2 方法覆写
    @Override
    public void shout() {
        System.out.println("子类 汪汪汪 ... ...");
    }
}
