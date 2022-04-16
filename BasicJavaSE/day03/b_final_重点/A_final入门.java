package cn.itcast.day03.b_final_重点;

public class A_final入门 {
    public static void main(String[] args) {
        A_Animal a1 = new A_Fox();
        a1.declare();
    }
}

// 父类: 动物的联合声明
class A_Animal {
    public final void declare() {
        System.out.println("动物联合声明: 动物永远是人类的好朋友!");
    }
}

// 子类: 动物的联合声明
class A_Fox extends A_Animal {
    //@Override
    //public void declare() {
    //    System.out.println("动物联合声明: 动物永远是人类的天敌!");
    //}
}
