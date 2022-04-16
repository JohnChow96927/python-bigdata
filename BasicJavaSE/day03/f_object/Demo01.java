package cn.itcast.day03.f_object;

public class Demo01 {
    public static void main(String[] args) {
        // 目标: 为什么要取覆写 java对象的 toString方法
        Student s1 = new Student("张三", 13);
        System.out.println(s1);
        System.out.println(s1.toString());

    }
}
