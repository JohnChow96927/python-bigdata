package cn.itcast.day03.g_string;

public class Demo01 {
    public static void main(String[] args) {
        // 定义字符数组chs, 初始化值为: 'a, 'b', 'c', 这三个字符 .
        char[] charArr = {'a', 'b', 'c'};
        // 将其分别封装成s1, s2这两个字符串对象.
        String s1 = new String(charArr); // 只要new 就会在堆中开辟空间
        String s2 = new String(charArr);

        // 直接通过""的方式创建两个字符串对象s3和s4.
        String s3 = "abc"; // 先去字符串常量池遍历查找, 找到了直接返回地址, 如果没有找到, 开辟新地址, 放内容, 返回地址
        String s4 = "abc";

        // 通过==分别判断s1和s2, s1和s3, s3和s4是否相同.
        System.out.println(s1 == s2); // false
        System.out.println(s3 == s4); // true

        // 通过equals()分别判断s1和s2, s1和s3, s3和s4是否相同.
        System.out.println(s1.equals(s2)); // true
        System.out.println(s1.equals(s3)); // true
        System.out.println(s4.equals(s3)); // true

        // 通过equalsIgnoreCase()判断字符串abc和ABC是否相同.
        System.out.println("abc".equals("ABC")); // false 区分大小写
        System.out.println("abc".equalsIgnoreCase("ABC")); // true 不区分大小写

    }
}
