package cn.itcast.day03.g_string;

public class Demo03 {
    public static void main(String[] args) {
        // 目标: 遍历字符串中的字符
        String str = "abcdefg";

        // System.out.println(str.length()); // 获取长度
        // System.out.println(str.charAt(1)); // b
        // 方式一
        for (int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);
            System.out.println(c);
        }

        System.out.println("=================");

        char[] charArr = str.toCharArray(); // 将字符串转成字节数组
        for (char c : charArr) {
            System.out.println(c);
        }
        System.out.println("=================");
        String str1 = "a";
        char c2 = 'a';
    }
}
