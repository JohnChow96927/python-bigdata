package d_random_number;

import java.util.Scanner;

public class Demo1_Random {
    public static void main(String[] args) {
        // 需求: 做一个点名器
        Scanner scanner = new Scanner(System.in);
        System.out.print("请输入学生人数(>0): ");
        int stu_count = scanner.nextInt();
        int num = (int) (Math.random() * stu_count + 1);
        System.out.println("被点到名的学生学号为: " + num);

        // 作业: 请生成10个 50-100间的随机整数
        int n = 1;
        while (n <= 10) {
            System.out.printf("生成的第" + n + "个50-100间的随机整数为: " + (int) (Math.random() * 51 + 50) + "\n");
            n++;
        }
    }
}
