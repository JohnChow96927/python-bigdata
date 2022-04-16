package cn.itcast.day01.a;

public class Demo07 {
    public static void main(String[] args) {
        // 1.定义两个int类型的变量a和b, 分别赋值为10, 20.
        int a = 10;
        int b = 20;
        // 2.通过输出语句打印变量a和b的和.
        System.out.println(a + b);

        // 3.定义int类型的变量c, 接收变量a和b的和.
        int c = a + b;
        // 4.打印变量c的值.
        System.out.println(c);

        // 5.定义两个变量aa和bb, 一个是int类型的数据, 另一个是byte类型的数据.
        int aa = 30;
        byte bb = 50;

        // 6.定义变量cc接收 变量aa和bb的和.
        int cc = aa + bb;

        // 7.分别设置变量cc的数据类型为byte类型和int类型, 观察结果并打印.
        System.out.println(cc);
    }
}
