package cn.itcast.day03.g_string;

public class Demo05 {
    public static void main(String[] args) {
        // 需求: 字符串反转 例子: abcd -> dcba
        // 输出 5 4 3 2 1 0
        // for (int i=5; i>=0; i--) {
        //     System.out.println(i);
        // }

        String str = "abcdefg";

        for (int i=str.length()-1; i>=0; i--) {
            char c = str.charAt(i);
            System.out.println(c);
        }
    }
}
