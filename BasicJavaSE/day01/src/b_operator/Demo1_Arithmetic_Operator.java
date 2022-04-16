package b_operator;

public class Demo1_Arithmetic_Operator {
    public static void main(String[] args) {
        //int num = 10;
        //int num2 = 10;

        //num++;
        //System.out.println(num);

        //++num;
        //System.out.println(num);


        int num = 10;
        //num++ ==> 先使用num的值, 再让num的值+1
        int a = num++;
        System.out.println("a = " + a); // 10

        int num2 = 10;
        //++num2 ==> 先使用num2的值+1, 再使用num2的值
        int b = ++num2;
        System.out.println("b = " + b); // 11
    }
}
