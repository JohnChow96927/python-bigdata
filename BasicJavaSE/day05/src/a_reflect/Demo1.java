package a_reflect;
/*
反射指的是在程序运行期间, 通过类的字节码对象, 来操作类中的成员(成员变量, 成员方法, 构造方法)的过程
获取类的字节码的方法:
1. 通过类名的class属性进行获取, 一般用于充当锁对象
2. 通过类的getClass()方法实现, 一般用于判断两个对象是否为同一个类的对象
3. 通过反射的方法实现, 一般用于强制加载某一个类的字节码文件进入内存(例如配置文件)
 */
public class Demo1 {
    public static void main(String[] args) throws ClassNotFoundException {
        // todo: 获取某个类的字节码对象
        // 方式一: 通过class属性
        Class<Student> class1 = Student.class;

        // 方式二: 通过getClass()方式实现
        Student student = new Student();
        Class<? extends Student> class2 = student.getClass();

        // 方式三: 通过反射的方式实现
        // 可以通过全类名, 或者说字符串加载类的字节码
        Class<?> class3 = Class.forName("a_reflect.Student");

        // 通过 上述三种方式获得的字节码完全相同
        System.out.println(class1);
        System.out.println(class1 == class2);
        System.out.println(class1 == class3);
    }
}
