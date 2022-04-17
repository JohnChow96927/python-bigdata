package j_wrapper;

import java.util.Arrays;

public class Demo2 {
    public static void main(String[] args) {
        // 数据源: 已知字符串String s = "91 27 45 38 50";
        // 目标结果: 请通过代码实现最终输出结果是: "27, 38, 45, 50, 91"

        String s = "91 27 45 38 50";

        // Step1. 切割
        String[] strArr = s.split("\\W");
        System.out.println(Arrays.toString(strArr));

        // 将字符串数组转成整数数组
        Integer[] intArr = new Integer[strArr.length];
        for (int i = 0; i < strArr.length; i++) {
            intArr[i] = Integer.parseInt(strArr[i]);
        }

        // 排序
        Arrays.sort(intArr);
        System.out.println(Arrays.toString(intArr));
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < intArr.length; i++) {
            if (i < intArr.length - 1) {
                sb.append(intArr[i]).append(", ");
            }else {
                sb.append(intArr[i]);
            }
        }
        System.out.println(sb.toString());
    }
}
