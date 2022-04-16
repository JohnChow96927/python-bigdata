package cn.itcast.day03.h_stringbuilder;

public class Demo04 {
    public static void main(String[] args) {
        // String[] strArr = {"aaa", "bbb", "ccc", "ddd"};
        // todo 自定义实现 [aaa, bbb, ccc, ddd] Arrays.toString(strArr)
        // System.out.println(Arrays.toString(strArr));

        String[] strArr = {"aaa", "bbb", "ccc", "ddd"};

        String result = Demo04.toString(strArr);

        System.out.println(result);
    }

    public static String toString(String[] strArr) {
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
        return result;
    }
}
