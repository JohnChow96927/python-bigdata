package b_thread_02;

public class ThreadDemo {
    public static void main(String[] args) {
        PrimeThread t1 = new PrimeThread();
        t1.setName("刘备");
        String name = t1.getName();
        System.out.println(name);
        t1.start();

        PrimeThread t2 = new PrimeThread("关羽");
        System.out.println(t2.getName());
        t2.start();
    }
}
