package cn.itcast.day03.d_abstract_重点;

public class Demo01 {

}
// 抽象类 本质: 类中的某些方法可以提前写好, 还有一些方法 我不确定未来怎么实现
// 子类
class A_Cat extends A_Animal {
    @Override
    public void shout() {
        System.out.println("子类: 喵喵喵.... ");
    }
}

// 子类
class A_Dog extends A_Animal {
    @Override
    public void shout() {
        System.out.println("子类: 汪汪汪.... ");
    }
}

// 父类
abstract class A_Animal {
    public void eat() {
        System.out.println("动物正在吃饭 ... ...");
    }

    public abstract void shout();
}
