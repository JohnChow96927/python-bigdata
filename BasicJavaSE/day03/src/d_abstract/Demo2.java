package d_abstract;

public class Demo2 {
    public static void main(String[] args) {
        Teacher t1 = new BasicTeacher();
        t1.name = "张三";
        t1.age = 13;
        t1.teach();
    }
}

abstract class Teacher {
    String name;
    int age;

    public abstract void teach();
}
// 2.定义 BasicTeacher (基础班老师), 继承Teacher, 重写所有的抽象方法.
class BasicTeacher extends Teacher {
    @Override
    public void teach() {
        System.out.println("老师讲JavaSE");
    }
}

// 3.定义WorkTeacher(就业班老师), 继承Teacher, 重写所有的抽象方法.
class WorkTeacher extends Teacher {
    @Override
    public void teach() {
        System.out.println("老师讲解JavaEE.");
    }
}
