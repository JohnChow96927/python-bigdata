package cn.itcast.day02.e_数组;

import java.util.Arrays;

public class Demo03_array_查看数组中的内容 {
    public static void main(String[] args) {
        // 1.创建int类型的数组, 用来存储3个元素.
        int[] arr1 = new int[3];
        int arr2[] = new int[3];


        // 2.创建int类型的数组, 存储数据11, 22, 33.
        int[] arr3 = new int[]{11, 22, 33};
        int[] arr4 = {11, 22, 33};

        // 目标: 查看数组中的内容
        System.out.println(arr1);
        System.out.println(arr2);
        System.out.println(arr3);
        System.out.println(arr4);
        // 问题: 直接打印数组, 返回的内容是 数组的地址, 不是元素的内容
        // 解决: Arrays.toString(数组对象)
        System.out.println(Arrays.toString(arr1));
        System.out.println(Arrays.toString(arr2));
        System.out.println(Arrays.toString(arr3));
        System.out.println(Arrays.toString(arr4));

    }
}
