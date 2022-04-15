package cn.itcast.day01.a;

public class Demo06_变量4 {
    public static void main(String[] args) {
        // 目标1: 整数和小数的 默认类型
        int i1 = 20;
        double d = 3.14;

        // 目标2: 定义其他的整数类型
        // 注意: 给值的时候, 不要超过范围
        byte b1 = 10;
        // byte b2 = 130; // 报错原因: byte的范围 -128 ~ 127, 超过了这个范围

        short s1 = 1000;
        //short s2 = 300000;

        // 目标3: 将小类型的值 放到 大类型中, 直接放就可以
        long l1 = 10000;
        long l2 = 20000L;
        long l3 = 20000l;

        // 目标4: 将大类型中的值 放到 小类型中, 需要强制类型转换
        int i2 = (int) l1;

        // 报错原因: 3.14是double类型, 给float类型
        //float f1 = 3.14;

        // 解决1:
        float f2 = (float) 3.14;

        // 解决2:
        float f3 = 3.14F;
    }
}
