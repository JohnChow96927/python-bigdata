package cn.itcast.day02.a_while;

public class Demo01_while_01 {
    public static void main(String[] args) {
        // while循环的入门案例
        // 回顾: 使用 for 输出 1 ~10
        for (int i = 1; i <= 10; i++) {
            System.out.println(i);
        }

        System.out.println("=================");
        // 使用 while 输出 1 ~10
        // while(boolean条件) {
        //     // 语句体
        // }

        int i = 1;
        while(i <= 10) {
            System.out.println(i);
            i++;
        }

    }
}
