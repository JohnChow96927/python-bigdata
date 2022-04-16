package a_keyword;

public class Demo7_Variable_5 {
    public static void main(String[] args) {
        // 注意1: 变量必须给值, 才可以使用
        int a;
        a = 10;
        System.out.println(a);

        // 注意2: 变量是有作用域, 默认有效范围是 从大括号开始, 到大括号结束
        {
            int b = 20;
            System.out.println("b = " + b);
        }
        //System.out.println("b = " + b);

        // 简化的方式: 同时在一行声明同类型的多个变量
        int x = 30;
        int y = 40;
        int z = 50;

        int x1 = 60, y1 = 70, z1 = 80;
    }
}
