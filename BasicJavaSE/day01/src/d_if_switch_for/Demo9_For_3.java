package d_if_switch_for;

public class Demo9_For_3 {
    public static void main(String[] args) {
        int num = 10 / 3;
        System.out.println(num);

        /*
        水仙花数
            1.水仙花数是一个3位数的整数. [100, 999]
            2.该数字的各个位数立方和相加等于它本身. 获取这个整数的个位 十位 百位
            3.例如: 153就是水仙花数, 153 = 1 * 1 * 1 + 5 * 5 * 5 + 3 * 3 * 3 = 153
         */
        for (int i = 100; i <= 999; i++) {
            int index_3 = i / 1 % 10;
            int index_2 = i / 10 % 10;
            int index_1 = i / 100 % 10;
            if ((index_1 * index_1 * index_1 + index_2 * index_2 * index_2 + index_3 * index_3 * index_3) == i) {
                System.out.println(i);
            }
        }
    }
}
