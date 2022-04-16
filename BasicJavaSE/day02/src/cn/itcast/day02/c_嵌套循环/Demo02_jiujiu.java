package cn.itcast.day02.c_嵌套循环;

public class Demo02_jiujiu {
    public static void main(String[] args) {
        //System.out.println(10);
        //System.out.println(20);
        //System.out.println(30);
        //System.out.println("====================");
        //System.out.print(40 + "\t");
        //System.out.print(50 + "\t");
        //System.out.print(60 + "\t");
        //System.out.println("====================");

        // 目标: 九九乘法表
        // 1 获取行数
        for (int i = 1; i <= 9; i++) {
            // System.out.println(i);
            // 2 获取列数
            for (int j = 1; j <= i; j++) {
                // System.out.println("列: " + j);
                // 3 获取结果
                System.out.print(j + " * " + i + " = " + (j * i) + "\t");
            }
            System.out.println();
        }
    }
}
