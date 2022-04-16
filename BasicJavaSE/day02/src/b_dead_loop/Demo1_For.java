package b_dead_loop;

public class Demo1_For {
    public static void main(String[] args) {
        for (; true; ) {
            System.out.println("This is a DEAD loop! Stop it through keyboard!");
        }
    }
}
