package cn.itcast.day02.b_sixunhuan;

public class Demo03_break_continue {
    public static void main(String[] args) {
        // 需求:输出 1 ~ 100, 碰到7的倍数跳过, 到90的时候停止循环
        // 回顾 continue 跳过本次循环
        // 回顾 break     结束循环
        for (int i = 1; i <= 100; i++) {
            // 碰到7的倍数跳过
            if(i % 7 == 0) { continue; }
            // 到90的时候停止循环
            if(i == 90) {break;}

            System.out.println(i);
        }
    }
}
