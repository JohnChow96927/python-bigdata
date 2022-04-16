package b_operator;

public class Demo4_Ternary_Operator {
    public static void main(String[] args) {
        // 1. 定义两个int类型的变量a, b, 初始化值分别为10, 20
        int a = 10, b = 20;
        // 2. 通过三元运算符, 获取变量a和b的最大值
        int max = (a > b) ? a : b;

        //3. 将结果(最大值)打印到控制台上
        System.out.println(max);
    }
}
