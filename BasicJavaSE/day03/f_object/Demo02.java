package cn.itcast.day03.f_object;

public class Demo02 {
    public static void main(String[] args) {
        // 目标: 为什么要去覆写 类的equals方法
        // 第一种情况: == 如果是基本类型, 直接对比的值
        int n = 10;
        int m = 10;
        //System.out.println(n == m);

        // 第二种情况: == 如果是引用类型, 对比的堆里开辟的地址
        Student s1 = new Student("张三", 13);
        Student s2 = new Student("李四", 14);
        Student s3 = new Student("张三", 13);

        // 没有覆写 student类的 equalse方法
        // System.out.println(s1 == s2); // false
        // System.out.println(s1 == s3); // false

        // 问题: 对比两个对象是否一样? 不要对比地址, 对比内容 怎么办?
        // 解决: 覆写 equals方法

        // 覆写 student类的 equalse方法 之后的结果
        System.out.println(s1.equals(s2)); // false
        System.out.println(s1.equals(s3)); // true
    }
}
