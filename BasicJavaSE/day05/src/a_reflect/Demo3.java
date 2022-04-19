package a_reflect;

import java.lang.reflect.Field;

public class Demo3 {
    public static void main(String[] args) throws Exception {
        // 需求: 使用反射获取指定的成员变量并赋值

        // 1. 获取该类的字节码对象
        Class<?> class1 = Class.forName("a_reflect.Student");
        // 2. 获取要操作的成员对象(构造器, 成员变量, 成员方法)
        Field name = class1.getDeclaredField("name");
        // 3. 创建一个该类的实例
        Student s = (Student) class1.newInstance();
        // 私有的成员变量, 不能直接使用, 要进行暴力反射后才可以
        name.setAccessible(true);
        // 4. 操作该指定的实例完成需求
        name.set(s, "霜霜");
        // 打印对象中的内容
        System.out.println(s.getName());
    }
}
