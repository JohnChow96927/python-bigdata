package g_string;

public class Demo4 {
    public static void main(String[] args) {
        // 需求: 统计字符串中小写字母和大写字母及数字出现的次数
        String str = "ABCabcd12345";

        int lowercount = 0;
        int uppercount = 0;
        int numbercount = 0;

        char[] charArray = str.toCharArray();

        for (char c : charArray) {
            if (c >= 'a' && c <= 'z')
                lowercount++;
            else if (c >= 'A' && c <= 'Z')
                uppercount++;
            else if (c >= '0' && c <= '9')
                numbercount++;
        }
        System.out.println("大写字母: " + uppercount);
        System.out.println("小写字母: " + lowercount);
        System.out.println("数字: " + numbercount);

        int i = 'a' + 1;
        System.out.println(i);  // ascii: 97 + 1 = 98
    }
}
