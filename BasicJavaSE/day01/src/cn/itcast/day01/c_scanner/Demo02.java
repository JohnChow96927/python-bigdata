package cn.itcast.day01.c_scanner;

import java.util.Scanner;

public class Demo02 {
    public static void main(String[] args) {
        // 目标: 获取三个和尚的身高, 求最低的身高
        // 1 创建scanner对象
        Scanner scanner = new Scanner(System.in);
        // 2 获取三个和尚的身高
        System.out.println("请输入第一个和尚的身高:");
        int height1 = scanner.nextInt();

        System.out.println("请输入第二个和尚的身高:");
        int height2 = scanner.nextInt();

        System.out.println("请输入第三个和尚的身高:");
        int height3 = scanner.nextInt();

        //System.out.println("h1 = " + height1 + ", h2 = " + height2 + ", h3 = " + height3);

        // 3 求最低的身高
        // 方式一
        // int min = height1 < height2 ? height1 : height2;
        // int min2 = min < height3 ? min : height3;

        // 方式二
        // int min = height1 < height2 ? height1 : height2;
        // min = min < height3 ? min : height3;

        // 方式三
        int min = (height1 < height2 ? height1 : height2) < height3 ? (height1 < height2 ? height1 : height2) : height3;

        // 4 打印
        System.out.println("最矮身高: " + min);
    }
}
