package cn.itcast.day03.a_多态_重点;

public class D_demo04_解决多态的弊端 {
    public static void main(String[] args) {
        D_Actress p1 = new D_Actress();
        p1.name = "如花";
        //p1.doSomthing();
        cut(p1);

        D_Barber p2 = new D_Barber();
        p2.name = "华仔";
        //p2.doSomthing();
        cut(p2);

        D_Doctor p3 = new D_Doctor();
        p3.name = "华佗";
        //p3.doSomthing();
         cut(p3);
    }

    public static void cut(D_Person p) {
        p.doSomthing();

        // 事实(多态的弊端): 父类对象 没有办法调用子类特有的方法
        // 解决: 向下转型 (类似于 int 转 byte)
        if(p instanceof D_Actress) {
            ((D_Actress)p).fanju();
        } else if(p instanceof D_Barber) {
            ((D_Barber)p).paoniu();
        } else if(p instanceof D_Doctor) {
            ((D_Doctor)p).zhifuyouhuo();
        }
    }
}

// 多态的套路: 1 有继承关系 2 方法覆写 3 让父类对象指向子类对象
// 1 有继承关系
// 1.1 父类 Person
class D_Person {
    String name;

    public void doSomthing() {
        System.out.println("父类 某人正在做某事 .... ...");
    }
}

// 1.2 子类1 女演员 actress
class D_Actress extends D_Person {
    //2 方法覆写
    @Override
    public void doSomthing() {
        System.out.println("子类女演员 " + name + " 立刻停止表演... ...");
    }

    // 自己特有的方法
    public void fanju() {
        System.out.println("子类女演员 " + name + " 参加有金主的饭局 ... ...");
    }
}

// 1.3 子类2 理发师 barber
class D_Barber extends D_Person {
    //2 方法覆写
    @Override
    public void doSomthing() {
        System.out.println("子类理发师 " + name + " 立刻开始理发... ...");
    }

    // 自己特有的方法
    public void paoniu() {
        System.out.println("子类理发师 " + name + " 正在专心致志的泡妞 ... ...");
    }
}

// 1.4 子类3 医生 doctor
class D_Doctor extends D_Person {
    //2 方法覆写
    @Override
    public void doSomthing() {
        System.out.println("子类医生 " + name + " 立刻开始给患者做手术... ...");
    }

    public void zhifuyouhuo() {
        System.out.println("子类医生 " + name + " 正在施展制服诱惑 .... ...");
    }
}