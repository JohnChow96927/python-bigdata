package g_string;

import java.util.Scanner;

public class Demo2_Login_Simulate {
    public static void main(String[] args) {
        // 模拟用户登录, 只给3次机会, 登录成功则提示"欢迎您, ***".
        // 登录失败则判断是否还有登录机会, 有则提示剩余登录次数, 没有则提示"您的账号已被锁定".
        // 假设初始化账号和密码分别为: "传智播客", "黑马程序员".

        // 1 确定正确的用户名和密码
        String username = "John";
        String password = "Chow";

        // 2 给用户3次机会 使用for循环
        for (int i = 0; i < 3; i++) { // i : 0 1 2
            // 2.1 获取用户输入的用户名
            System.out.println("请输入用户名: ");
            Scanner scanner = new Scanner(System.in);
            String uname = scanner.nextLine(); // 获取一行内容
            // 2.2 获取用户输入的密码
            System.out.println("请输入密码: ");
            Scanner scanner2 = new Scanner(System.in);
            String upwd = scanner2.nextLine(); // 获取一行内容

            // System.out.println(uname + ", " + upwd);
            // 2.3 判断
            if ("John".equals(uname) && upwd.equals("Chow")) {
                // 2.3.1 如果用户名和密码都正确, 提示 登录成功, 欢迎访问
                System.out.println("登录成功, 欢迎 " + uname + " 访问");
                break;
            } else {
                // 2.3.2 如果用户名或密码错误
                // 2.3.2.1 提示 用户名或密码错误
                if ((2 - i) != 0) {
                    System.err.println("用户名或密码错误! 你还有" + (2 - i) + "次机会!");
                } else {
                    System.err.println("用户名或密码错误! 您的用户名或密码已经被锁定, 请1个小时后再试!");
                }
            }
        }
    }
}
