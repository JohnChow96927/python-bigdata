package cn.itcast.day02.d_随机数;

public class Demo01_random入门 {
    public static void main(String[] args) {
        // 需求: 做一个点名器, 学号就是随机的 [1, 45]
        // 补充知识1: 生成一个 [0, 1)之间的数字
        // while(true) {
        //     double random = Math.random(); // 生成一个 [0, 1)之间的数字
        //     System.out.println(random);
        // }

        // 生成 [0, 45)之间的数字: [0, 1) * 45
        double r = Math.random() * 45;
        System.out.println(r);

        // 问题1: 学号0没有意义, 学号45没有
        // 解决: [0, 1) * 45 + 1 = [0, 45) + 1 = [0, 46)
        double r2 = Math.random() * 45 + 1;
        System.out.println(r2);

        // 问题2: 生成的结果是有小数
        int studentNum = (int) (Math.random() * 45 + 1);
        System.out.println(studentNum);

        // 作业: 请生成 10个 50~100之间的 随机整数
    }
}
