package a_polymorphism;

public class Demo1 {
    public static void main(String[] args) {
        // 目标: 多态的入门 本质
        A_Dog dog = new A_Dog();
        dog.shout();

        A_Animal a1 = new A_Dog();
        a1.shout();

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
        System.out.println("汪汪汪");
    }
}

