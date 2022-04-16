package cn.itcast.day03.h_stringbuilder;

public class Demo05 {
    public static void main(String[] args) {
        // 目标: 使用StringBuilder实现字符串反转
        String str = "abcd";

        StringBuilder sb = new StringBuilder(str);
        // 实现反转
        StringBuilder sb2 = sb.reverse();
        String resultStr = sb2.toString();

        System.out.println(resultStr);
    }
}
