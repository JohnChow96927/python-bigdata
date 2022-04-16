package cn.itcast.day02.a_while;

public class Demo02_while_02 {
    public static void main(String[] args) {
        // 需求: 获取1~100之间所有偶数和, 并将结果打印到控制台上.
        // 1 获取 1 ~ 100
        // 2 获取 偶数
        // 3 求和 打印
        int sum = 0;

        int i = 1;
        while(i<=100) {
            if(i % 2 == 0) {
                // System.out.println(i);
                sum += i;
            }
            i++;
        }

        System.out.println("求和: " + sum);
    }
}
