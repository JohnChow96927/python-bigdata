package a_while;

public class Demo3 {
    public static void main(String[] args) {
        int count = 0;
        int paper_init = 1;
        int mount = 88480000;
        while (paper_init <= mount) {
            paper_init *= 2;
            System.out.println(paper_init);
            count += 1;
        }
        System.out.println(count);
    }
}
