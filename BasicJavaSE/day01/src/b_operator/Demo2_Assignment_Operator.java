package b_operator;

public class Demo2_Assignment_Operator {
    public static void main(String[] args) {
        short s1 = 10;
        int i1 = s1 + 1;
        s1 = (short) i1;
        System.out.println(s1);

        short s2 = 20;
        s2 += 2;
        System.out.println(s2);
    }
}
