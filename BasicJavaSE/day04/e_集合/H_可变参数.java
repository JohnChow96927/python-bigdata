package cn.itcast.day04.e_集合;

public class H_可变参数 {
    public static void main(String[] args) {
        int a = 10;
        int b = 20;
        int c = 30;
        int d = 40;
        int e = 50;

        int result2 = add(a, b);
        int result3 = add(a, b, c);
        int result4 = add(a, b, c, d);
        int resultX = add(a, b, c, d, e, a, a, a);

        System.out.println(result2);
        System.out.println(result3);
        System.out.println(result4);
        System.out.println(resultX);

    }

    public static int add(Integer... elements) {
        int sum = 0;
        for (Integer element : elements) {
            sum += element;
        }
        return sum;
    }

    //public static int add(int num1, int num2, int num3, int num4) {
    //    return num1 + num2 + num3 + num4;
    //}
    //
    //public static int add(int num1, int num2, int num3) {
    //    return num1 + num2 + num3;
    //}
    //
    //public static int add(int num1, int num2) {
    //    return num1 + num2;
    //}
}
