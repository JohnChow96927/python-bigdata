package a_keyword;

public class Demo10_Variable_Transform {
    public static void main(String[] args) {
        char c1 = 'a';
        int num = c1 + 1;
        System.out.println(num);

        char c2 = (char) num;
        System.out.println(c2);
    }
}
