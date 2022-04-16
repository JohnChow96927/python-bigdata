package cn.itcast.day03.g_string;

public class Demo04 {
    public static void main(String[] args) {
        // 需求: 统计字符串中 小写字母 大写字母 数字出现的次数
        String str = "ABCabcde123456789";

        // 声明计数的变量
        int maxCount = 0;
        int minCount = 0;
        int numCount = 0;

        char[] charArr = str.toCharArray();

        for (char c : charArr) {

            if(c>='a' && c<='z') {
                minCount++;
            } else if(c>='A' && c<='Z') {
                maxCount++;
            } else if(c>='0' && c<='9') {
                numCount++;
            }
        }

        System.out.println("大写字母: " + maxCount);
        System.out.println("小写字母: " + minCount);
        System.out.println("数字: " + numCount);

        int i = 'a' + 1;
    }
}
