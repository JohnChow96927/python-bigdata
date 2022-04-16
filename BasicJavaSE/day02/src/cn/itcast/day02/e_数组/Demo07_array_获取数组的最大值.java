package cn.itcast.day02.e_数组;

public class Demo07_array_获取数组的最大值 {
    public static void main(String[] args) {
        // 已知各位美女的颜值如下图, 请求出下图中, 颜值最高的数字, 并打印到控制台上.
        //         即:求数组int[] arr = {5, 15, 2000, 10000, 100, 4000};的最大值.

        int[] arr = {5, 15, 2000, 10000, 100, 4000};

        // 声明保存最大值的变量
        int max = 0;

        // 1 遍历
        for (int element : arr) {
            // 1.1 判断
            if(element > max) {
                // 1.2 找出最大值
                max = element;
            }
        }

        System.out.println("最大值: " + max);
    }
}
