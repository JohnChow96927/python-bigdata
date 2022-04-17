package h_stringbuilder;

import java.util.Arrays;

public class Demo3 {
    public static void main(String[] args) {
         String[] strArr1 = {"aaa", "bbb", "ccc", "ddd"};
         // todo 自定义实现 [aaa, bbb, ccc, ddd] Arrays.toString(strArr)
         System.out.println(Arrays.toString(strArr1));

        String[] strArr = {"aaa", "bbb", "ccc", "ddd"};
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < strArr.length; i++) {
            if(i != (strArr.length-1)) {
                sb.append(strArr[i]).append(", ");
            } else {
                sb.append(strArr[i]);
            }
        }
        sb.append("]");
        String result = sb.toString();
        System.out.println(result);
    }
}
