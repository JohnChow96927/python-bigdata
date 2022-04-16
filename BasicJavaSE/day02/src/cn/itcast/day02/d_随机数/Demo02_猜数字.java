package cn.itcast.day02.d_随机数;

import java.util.Scanner;

public class Demo02_猜数字 {
    public static void main(String[] args) {
        /*
            需求
                1.生成一个1-100之间的随机数, 让用户来猜.
                2.如果猜的数字比生成的随机数大，提示你猜的数据大了
                3.如果猜的数字比生成的随机数小，提示你猜的数据小了
                4.如果猜的数字与生成的随机数相等，提示恭喜你猜中了

                生成的随机数字是: 85

                    用户第一次猜:  50        提示: 小了
                    用户第二次猜:  75        提示: 小了
                    用户第二次猜:  87        提示: 大了
                    用户第二次猜:  82        提示: 小了
                    用户第二次猜:  85        提示: 恭喜你猜对了, 结束
         */
        // 1 生成随机数字
        int r = (int) (Math.random() * 100 + 1);
        //System.out.println("生成的随机数: " + r);
        // 2 不确定用户几次能猜对, 使用死循环
        while(true) {
            // 3 如何获取用户输入的数字
            System.out.println("请输入您猜的数字: ");
            Scanner scanner = new Scanner(System.in);
            int cai = scanner.nextInt();

            if(cai == r) {
                System.out.println("恭喜您猜对了");
                break;
            } else if(cai > r) {
                System.out.println("猜大了");
            } else {
                System.out.println("猜小了");
            }
        }

    }
}
