package cn.itcast.day01.d;

public class Demo09_for_3 {
    public static void main(String[] args) {
        // 细节1: 整数 除以 整数 除不尽的结果 是小数, 还是整数? 在java中是整数
        //int num = 10 / 3;
        //System.out.println(num);

        // 获取十位上的数字: 分解式
        //int num = 345;
        //int result = num / 10;
        //System.out.println(result);
        //
        //int result2 = result % 10;
        //System.out.println(result2);

        /*
        int num = 12345;
        // 获取个位上的数字: 合并式
        int result1 = num / 1 % 10;
        System.out.println(result1);

        // 获取十位上的数字: 合并式
        int result2 = num / 10 % 10;
        System.out.println(result2);

        // 获取百位上的数字: 合并式
        int result3 = num / 100 % 10;
        System.out.println(result3);
        */
        /*
        需求: 获取到所有的水仙花数, 并将结果打印到控制台上.
        解释:
            1.水仙花数是一个3位数的整数. [100, 999]
            2.该数字的各个位数立方和相加等于它本身. 获取这个整数的个位 十位 百位
            3.例如: 153就是水仙花数, 153 = 1 * 1 * 1 + 5 * 5 * 5 + 3 * 3 * 3 = 153
         */
        // 1 获取三位数
        for (int i = 100; i <= 999; i++) {
            // 2 获取这个三位数的个位 十位 百位
            // 获取个位上的数字: 合并式
            int result1 = i / 1 % 10;

            // 获取十位上的数字: 合并式
            int result2 = i / 10 % 10;

            // 获取百位上的数字: 合并式
            int result3 = i / 100 % 10;

            // 3 通过判断得到水仙花数字 且 打印
            if((result1 * result1 * result1 + result2 * result2 * result2 + result3 * result3 * result3) == i) {
                System.out.println(i);
            }
        }
    }
}
