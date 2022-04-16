package d_if_switch_for;

public class Demo8_For_2 {
    public static void main(String[] args) {
        // 需求 求1-100之间的偶数和, 并把求和结果打印到控制台
        int sum = 0;
        for (int i = 1; i <= 100; i++) {
            if (i % 2 == 0) {
                sum += i;
            }
        }
        System.out.println(sum);
    }
}
