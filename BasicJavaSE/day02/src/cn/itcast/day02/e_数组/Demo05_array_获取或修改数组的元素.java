package cn.itcast.day02.e_数组;

import java.util.Arrays;

public class Demo05_array_获取或修改数组的元素 {
    public static void main(String[] args) {
        // 数组的本质: 容器
        int[] arr = {11, 33, 55, 77, 99};

        // 1 取
        // 数组的下标从0开始的
        System.out.println(arr[1]); // 33
        System.out.println(arr[3]); // 77

        // 2 放
        arr[2] = 666;
        System.out.println(Arrays.toString(arr));

        // 3 问题: ArrayIndexOutOfBoundsException 因为数组的下标最大值是4, 你想取下标为100的元素内容, 肯定没有, 所以报错
        // 先判断 再获取
        // 获取最大下标
        System.out.println(arr.length - 1);
        if(2 <= (arr.length - 1)) {
            System.out.println(arr[2]);
        }

        // 获取数组长度的应用场景2: 遍历数组
    }
}
