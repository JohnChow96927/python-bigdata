package cn.itcast.day01.d;

import java.util.PrimitiveIterator;
import java.util.Scanner;

public class Demo05_switch {

    public static void main(String[] args) {
        /*
            1.一年有12个月, 分属于春夏秋冬4个季节, 键盘录入一个月份, 请用程序实现判断该月份属于哪个季节, 并输出。
            2.具体标准如下:
                1.输入： 1、2、12 输出：冬季
                2.输入： 3、4、5 输出：春季
                3.输入： 6、7、8 输出：夏季
                4.输入： 9、10、11 输出：秋季
                –输入：其它数字 输出：数字有误
         */
        // 1 获取用户输入的月份
        // 1.1 创建对象
        Scanner scanner = new Scanner(System.in);
        // 1.2 通过对象获取用户输入的值
        System.out.println("请输入对应的月份: ");
        int month = scanner.nextInt();
        // 1.3 打印测试
        //System.out.println(month);

        // 2 根据用户输入的月份 打印 对应的季节
        switch (month) {
            case 12:
                System.out.println("冬季");
                break;
            case 1:
                System.out.println("冬季");
                break;
            case 2:
                System.out.println("冬季");
                break;
            case 3:
                System.out.println("春季");
                break;
            case 4:
                System.out.println("春季");
                break;
            case 5:
                System.out.println("春季");
                break;
            case 6:
                System.out.println("夏季");
                break;
            case 7:
                System.out.println("夏季");
                break;
            case 8:
                System.out.println("夏季");
                break;
            case 9:
                System.out.println("秋季");
                break;
            case 10:
                System.out.println("秋季");
                break;
            case 11:
                System.out.println("秋季");
                break;
            default:
                System.out.println("请输入正确的月份!");
                break;
        }
    }
}
