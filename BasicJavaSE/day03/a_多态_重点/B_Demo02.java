package cn.itcast.day03.a_多态_重点;

// 目标: 证明多态可以让我们的代码扩展性更强
public class B_Demo02 {
    public static void main(String[] args) {
        B_Actress p1 = new B_Actress();
        p1.name = "如花";
        //p1.doSomthing();
        cut(p1);

        B_Barber p2 = new B_Barber();
        p2.name = "华仔";
        //p2.doSomthing();
        cut(p2);

        B_Doctor p3 = new B_Doctor();
        p3.name = "华佗";
        //p3.doSomthing();
        cut(p3);
    }

    public static void cut(B_Person p) {
        p.doSomthing();
    }

    //public static void cut(B_Barber p) {
    //    p.doSomthing();
    //}
}

// 多态的套路: 1 有继承关系 2 方法覆写 3 让父类对象指向子类对象
// 1 有继承关系
// 1.1 父类 Person
class B_Person {
    String name;

    public void doSomthing() {
        System.out.println("父类 某人正在做某事 .... ...");
    }
}

// 1.2 子类1 女演员 actress
class B_Actress extends B_Person {
    //2 方法覆写
    @Override
    public void doSomthing() {
        System.out.println("子类女演员 " + name + " 立刻停止表演... ...");
    }
}

// 1.3 子类2 理发师 barber
class B_Barber extends B_Person {

    //2 方法覆写
    @Override
    public void doSomthing() {
        System.out.println("子类理发师 " + name + " 立刻开始理发... ...");
    }
}

// 1.4 子类3 医生 doctor
class B_Doctor extends B_Person {
    //2 方法覆写
    @Override
    public void doSomthing() {
        System.out.println("子类医生 " + name + " 立刻开始给患者做手术... ...");
    }
}
