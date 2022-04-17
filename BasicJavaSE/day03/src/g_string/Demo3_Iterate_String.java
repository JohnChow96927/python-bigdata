package g_string;

public class Demo3_Iterate_String {
    public static void main(String[] args) {
        String str = "abcdefg";
        // 方式一
        for (int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);
            System.out.println(c);
        }
        System.out.println("====================");
        // 方式二: 将字符串转成字节数组
        char[] charArray = str.toCharArray();
        for (char c : charArray) {
            System.out.println(c);
        }
    }
}
