package cn.itcast.day01.c_scanner;

import java.util.Scanner;

public class Demo01 {
    public static void main(String[] args) {
        // 1 获取Scanner对象
        Scanner scanner = new Scanner(System.in);
        // 2 调用方法 获取用户输入的值
        System.out.println("请输入您的年龄: ");
        String age = scanner.next();

        System.out.println("您的年龄是: " + age);
    }
}
