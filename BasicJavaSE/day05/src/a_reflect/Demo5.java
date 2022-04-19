package a_reflect;

import java.io.FileInputStream;
import java.lang.reflect.Method;
import java.util.Objects;
import java.util.Properties;

/*
需求: 通过反射运行配置文件中指定类的指定方法

Properties 配置文件, Java中有Properties类可以直接读取该文件
Properties 是一个集合类:
    它表示双列集合, 是Hashable的子类, 键值都是字符串类型
    它可以直接读取配置文件中的信息, 也可以直接向配置文件中写入信息(*.properties)
 */
public class Demo5 {
    public static void main(String[] args) throws Exception {
        Properties prop = new Properties();

        prop.load(new FileInputStream("day05/config/myConfig.properties"));
        // 2. 把读取到的配置文件信息, 赋值给变量
        String className = prop.getProperty("className");
        String methodName = prop.getProperty("methodName");

        // 3. 使用反射运行该类的指定方法
        // 3.1. 获取该类的字节码对象
        Class<?> class1 = Class.forName(className);
        Method eat = class1.getMethod(methodName);
        Object s = class1.newInstance();
        eat.invoke(s);
    }
}
