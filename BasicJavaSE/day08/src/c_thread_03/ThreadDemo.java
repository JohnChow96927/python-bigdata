package c_thread_03;

public class ThreadDemo {
    public static void main(String[] args) {
        PrimeThread t1 = new PrimeThread("海王");
        t1.start();
        Thread mainThread = Thread.currentThread();

        mainThread.setName("超人");
        String name = mainThread.getName();
        System.out.println("name = " + name);
    }
}
