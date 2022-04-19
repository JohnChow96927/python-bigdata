package a_reflect;

import java.lang.reflect.Constructor;

/*
获取构造方法的方法:
    Constructor<?>[] getConstructors()      返回所有公共构造方法对象的数组
    Constructor<?>[] getDeclaredConstructors()      返回所有构造方法对象的数组
    Constructor getConstructors(Class<?>... parameterTypes)      返回单个公共构造方法对象
    Constructor getDeclaredConstructors(Class<?>... parameterTypes)      返回单个构造方法对象

使用反射可以操作的内容有(成员方法, 成员变量, 构造方法)

使用反射的步骤:
    1. 获取该类的字节码对象
    2. 获取要操作的成员对象(构造器, 成员变量, 成员方法)
    3. 创建一个该类的实例
    4. 操作该指定的实例完成需求
 */
public class Demo2 {
    public static void main(String[] args) throws Exception {
        // 需求: 获取Student中的构造方法, 创建该类的对象
//        Student s1 = new Student("小明", 18);
        // 通过反射获取全参构造
        // 1. 获取该类的字节码对象
        Class<?> class1 = Class.forName("a_reflect.Student");
        // 2. 获取要操作的成员对象(构造器, 成员变量, 成员方法)
        Constructor<?> con = class1.getConstructor(String.class, int.class);
        Constructor<?> decon = class1.getDeclaredConstructor(String.class);
        Constructor<?>[] decons = class1.getDeclaredConstructors();
        // 遍历decons打印
        for (Constructor<?> d : decons) {
            System.out.println(d);
        }
        decon.setAccessible(true);
        // 3. 创建一个该类的实例 使用字节码对象创建创建实例的方法newInstance()
        Object s = con.newInstance("小芳", 19);
        Student s1 = (Student) decon.newInstance("小红");

        // 4. 操作该指定的实例完成需求
        System.out.println(s.getClass().toString());
        System.out.println(s1.getName());
        // 如果我们想要使用对象中的方法还需要对其进行向下转型
        Student s2 = (Student) s;
        s2.eat();
    }
}
