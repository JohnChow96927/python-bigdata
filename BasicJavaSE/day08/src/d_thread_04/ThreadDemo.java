package d_thread_04;


public class ThreadDemo {
    public static void main(String[] args) {
        PrimeRunnable pr = new PrimeRunnable();
        Thread t1 = new Thread(pr, "张飞");
        t1.start();

        Thread t2 = new Thread(pr, "刘备");
        t2.start();
    }
}
