package cn.itcast.day03.c_static_重点;

public class Demo02_使用static修饰成员变量 {
    public static void main(String[] args) {
        // 讲台成员变量随着类的加载而存在, 优先于对象存在的
        Student.age = 18;

        Student student = new Student();
        student.name = "张三";
        student.show();

        Student student2 = new Student();
        student2.name = "李四";
        student2.show();

    }
}

class Student {
    String name;
    static int age;

    public void show() {
        System.out.println("name = " + name + ", 年龄 = " + age);
    }
}
