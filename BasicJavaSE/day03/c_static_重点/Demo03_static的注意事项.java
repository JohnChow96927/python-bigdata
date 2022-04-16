package cn.itcast.day03.c_static_重点;

/*
•访问特点
 静态方法只能访问静态的成员变量和静态的成员方法.
 简单记忆: 静态只能访问静态.
•注意事项
3.在静态方法中, 是没有this, super关键字的.
4.因为静态的内容是随着类的加载而加载, 而this和super是随着对象的创建而存在.
 即: 先进内存的, 不能访问后进内存的.
需求
1.定义学生类, 属性为姓名和年龄(静态修饰), 非静态方法show1(),show2(), 静态方法show3(), show4().
2.尝试在show1()方法中, 调用: 姓名, 年龄, show2(), show4().
 结论: 非静态方法可以访问所有成员(非静态变量和方法, 静态变量和方法)
3.尝试在show3()方法中, 调用: 姓名, 年龄, show2(), show4().
 结论: 静态方法只能访问静态成员.
 */
public class Demo03_static的注意事项 {
}

//1.定义学生类, 属性为姓名和年龄(静态修饰), 非静态方法show1(),show2(), 静态方法show3(), show4().
class C_Student {
    String name;
    static int age;

    public void show1() {
        System.out.println("调用show1方法: name = " + name + ", age = " + age);
        show2();
        // 结论2: 在非静态方法中, 既可以静态的方法, 也可以调用非静态的方法
        show3();
        show4();

    }

    public void show2() {
        System.out.println("调用show2方法: name = " + name + ", age = " + age);
    }

    public static void show3() {
        // name 报错: 结论1 静态方法中只能使用静态的成员变量和成员方法
        // System.out.println("调用show3方法: name = " + name + ", age = " + age);

        // 解决方案
        System.out.println("调用show3方法: age = " + age);
    }

    public static void show4() {
        System.out.println("调用show4方法: age = " + age);
        // 结论3: 在静态方法中, 可以调用静态的方法, 但是不能调用非静态的方法
        // show1();
        // show2();

        show3();
    }


}
