package d_random_number;

import java.util.Scanner;

public class Demo2_Guess_Number {
    public static void main(String[] args) {
        int answer = (int) (Math.random() * 100 + 1);
        Scanner scanner = new Scanner(System.in);
        while (true) {
            System.out.printf("请输入您要猜的数: ");
            int guess = scanner.nextInt();
            if (guess > answer) {
                System.out.println("大了, 请继续!");
            } else if (guess < answer) {
                System.out.println("小了, 请继续!");
            } else {
                System.out.println("恭喜您猜对了, 答案就是" + answer + "!");
                break;
            }

        }
    }
}
