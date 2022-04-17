package c_static;

public class Demo2_Static_Variable {
    public static void main(String[] args) {
        // 静态成员变量随着类的加载而存在, 优先于对象(类的实例化)存在
        // 静态的方法或是变量, 不需要类的实例化, 和类的对象无关
        Student.age = 18;
        Student student = new Student();
        student.name = "John";
        student.show();
        Student.age = 19;
        student.show();
    }
}

class Student {
    String name;
    static int age;
    public void show() {
        System.out.println("name = " + name + ", age = " + age);
    }
}
