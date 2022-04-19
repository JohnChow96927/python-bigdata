package a_reflect;

import java.lang.reflect.Method;

/*
使用反射操作成员方法的方法
    Method[] getMethods()   返回所有公共成员方法对象的数组, 包括继承的
    Method[] getDeclaredMethods()   返回所有成员方法对象的数组, 不包括继承的
    Method getMethod(String name, Class<?>... parameterTypes)   返回单个公共成员方法对象
    Method getDeclaredMethod(String name, Class<?>... parameterTypes)   返回单个成员方法对象

反射的使用步骤:
    1. 获取该类的字节码对象
    2. 获取想要操作的成员对象(构造器, 成员变量, 成员方法)
    3. 创建一个该类的实例
    4. 操作该指定的实例完成需求
 */
public class Demo4 {
    public static void main(String[] args) throws Exception {
        Class<?> class1 = Class.forName("a_reflect.Student");
        Method eat = class1.getMethod("eat");
        Method study = class1.getDeclaredMethod("study");
        Student s = (Student) class1.newInstance();
        eat.invoke(s);
        // 如果获取的是私有的内容就要暴力反射
        study.setAccessible(true);
        study.invoke(s);
    }
}
