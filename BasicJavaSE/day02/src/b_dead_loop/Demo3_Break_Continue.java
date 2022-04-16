package b_dead_loop;

public class Demo3_Break_Continue {
    public static void main(String[] args) {
        // 需求: 输出1 ~ 100, 逢7的倍数跳过, 到90的时候停止循环
        for (int i = 1; i <= 100; i++) {
            if (i % 7 == 0) {
                continue;
            }
            if (i == 90) {
                break;
            }
            System.out.println(i);
        }
    }
}
