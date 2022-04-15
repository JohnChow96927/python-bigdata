package cn.itcast.day01.d;

public class Demo08_for_2 {
    public static void main(String[] args) {
        //需求 求1-100之间的偶数和，并把求和结果打印到控制台上.
        // 3.1 声明 累加求和的变量
        int sum = 0;
        // 1 得到 1 ~ 100, 快捷键 fori
        for (int i = 1; i <= 100; i++) {
            // 2 通过判断 得到偶数
            if(i % 2 == 0) {
                // 3 累加求和
                // 3.2 求和
                sum += i;
            }
        }

        System.out.println("偶数求和的结果: " + sum);

    }
}
