package g_string;

public class Demo5_Reverse_String {
    public static void main(String[] args) {
        String str = "abcdefg";
        for (int i = str.length() - 1; i >= 0; i--) {
            char c = str.charAt(i);
            System.out.println(c);
        }
    }
}
