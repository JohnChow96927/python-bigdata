package a_thread_01;

public class ThreadDemo {
    public static void main(String[] args) {
        PrimeThread t1 = new PrimeThread();
        t1.start();

        PrimeThread t2 = new PrimeThread();
        t2.start();

        for (int i = 0; i < 100; i++) {
            System.out.println("主线程: " + i);
        }
    }
}
