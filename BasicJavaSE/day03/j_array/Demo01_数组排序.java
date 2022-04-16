package cn.itcast.day03.j_array;

import java.util.Arrays;

public class Demo01_数组排序 {
    public static void main(String[] args) {
        // 目标: 对数组排序, 升序输出
        int[] arr = {25, 69, 80, 57, 13};

        System.out.println("排序前:" + Arrays.toString(arr));

        Arrays.sort(arr);

        System.out.println("排序后: " + Arrays.toString(arr));
    }
}
