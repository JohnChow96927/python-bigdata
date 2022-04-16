package cn.itcast.day03.a_多态_重点;

public class C_Demo03_多态的特点 {
    public static void main(String[] args) {
        C_Person p1 = new C_Student();
        p1.name = "张三";
        p1.age = 13;

        // 结论1: 成员变量: 编译看左边, 运行看左边.
        //p1.xi = "计算机应用";

        // 结论2: 成员方法: 编译看左边, 运行看右边.
        p1.eat();

    }
}
/*
Animal a1 = new Cat();
•成员变量: 编译看左边, 运行看左边.
•成员方法: 编译看左边, 运行看右边.
需求
1.定义一个人类Person. 属性为姓名和年龄, 行为是: eat()方法.
2.定义Student类, 继承自Person类, 定义age属性及重写eat()方法.
3.在PersonTest测试类的main方法中, 创建Student类的对象, 并打印其成员.
 */
// 1.定义一个人类Person. 属性为姓名和年龄, 行为是: eat()方法.
class C_Person {
    String name;
    int age;

    public void eat() {
        System.out.println("父类: " + name + " 正在吃饭!");
    }
}

// 2.定义Student类, 继承自Person类, 定义age属性及重写eat()方法.
class C_Student extends C_Person {
    String xi;

    @Override
    public void eat() {
        System.out.println("子类: " + name + " 正在吃东西.... ....");
    }

    public void run() {
        System.out.println("子类: xxx 执行run方法");
    }
}
// 3.在PersonTest测试类的main方法中, 创建Student类的对象, 并打印其成员.
