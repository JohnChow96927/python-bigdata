package cn.itcast.day01.d;

import java.util.Scanner;

public class Demo03_if_双分支 {
    public static void main(String[] args) {
        /*
            1.提示用户键盘录入一个数据并接收.
            2.判断该数据是奇数还是偶数, 并将结果打印到控制台上.
         */
        // 1.提示用户键盘录入一个数据并接收.
        // 1.1 创建对象 Scanner
        Scanner scanner = new Scanner(System.in);
        // 1.2 获取用户输入的值
        System.out.println("请输入一个数字: ");
        int num = scanner.nextInt();
        // 1.3 打印测试
        //System.out.println("您输入的数字: " + num);

        // 2.判断该数据是奇数还是偶数, 并将结果打印到控制台上.
        if(num % 2 == 0) {
            System.out.println(num + "是 偶数!");
        } else {
            System.out.println(num + "是 奇数!");
        }
    }
}
