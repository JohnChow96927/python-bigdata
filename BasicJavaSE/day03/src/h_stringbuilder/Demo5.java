package h_stringbuilder;

public class Demo5 {
    public static void main(String[] args) {
        // 目标: 使用StringBuilder实现字符串反转
        String str = "abcd";

        StringBuilder sb = new StringBuilder(str);
        StringBuilder sb2 = sb.reverse();
        String resultStr = sb2.toString();

        System.out.println(resultStr);
    }
}
