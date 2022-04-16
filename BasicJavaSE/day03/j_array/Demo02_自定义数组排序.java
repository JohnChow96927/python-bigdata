package cn.itcast.day03.j_array;

import java.util.Arrays;

public class Demo02_自定义数组排序 {
    public static void main(String[] args) {
        // 目标: 对数组排序, 升序输出
        int[] arr = {25, 69, 80, 57, 13};

        System.out.println("排序前:" + Arrays.toString(arr));

        for (int i = 0; i < arr.length-1; i++) {
            for (int j = i+1; j < arr.length; j++) {
                // 交换的条件: 如果后面的数比前面的大, 交换位置
                if(arr[i] > arr[j]) {
                    int temp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = temp;
                }
            }
        }

        System.out.println("排序后: " + Arrays.toString(arr));

        // 目标1: 如何交换两个变量的值
        // show1();

    }

    public static void show1() {
        int a = 10;
        int b = 20;
        // 目标1: 如何交换两个变量的值
        int temp = 0;

        temp = a;
        a = b;
        b = temp;
        System.out.println("a = " + a + ", b = " + b);
    }
}
