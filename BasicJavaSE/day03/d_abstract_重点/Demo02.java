package cn.itcast.day03.d_abstract_重点;

public class Demo02 {
    public static void main(String[] args) {
        Teacher t1 = new BasicTeacher();
        t1.name = "张三";
        t1.age = 13;
        t1.teach();

    }
}
/*
3.8.5.1 需求
1.传智播客公司有基础班老师(BasicTeacher)和就业班老师(WorkTeacher), 他们都有姓名和年龄, 都要讲课.
2.不同的是, 基础班老师讲JavaSE, 就业班老师讲解JavaEE.
3.请用所学, 模拟该知识点.

3.8.5.2 分析
1.定义父类Teacher, 属性: 姓名和年龄, 行为: 讲课(因为不同老师讲课内容不同, 所以该方法是抽象的).
2.定义BasicTeacher(基础班老师), 继承Teacher, 重写所有的抽象方法.
3.定义 WorkTeacher (就业班老师), 继承Teacher, 重写所有的抽象方法.
4.定义TeacherTest测试类, 分别测试基础班老师和就业班老师的成员.
 */
// 1.定义父类Teacher, 属性: 姓名和年龄, 行为: 讲课(因为不同老师讲课内容不同, 所以该方法是抽象的).
abstract class Teacher {
    String name;
    int age;

    public abstract void teach();
}
// 2.定义 BasicTeacher (基础班老师), 继承Teacher, 重写所有的抽象方法.
class BasicTeacher extends Teacher {
    @Override
    public void teach() {
        System.out.println("基础班老师讲JavaSE");
    }
}

// 3.定义WorkTeacher(就业班老师), 继承Teacher, 重写所有的抽象方法.
class WorkTeacher extends Teacher {
    @Override
    public void teach() {
        System.out.println("就业班老师讲解JavaEE.");
    }
}

// 4.定义TeacherTest测试类, 分别测试基础班老师和就业班老师的成员.
