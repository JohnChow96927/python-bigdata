package a_thread_01;

public class PrimeThread extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            System.out.println("子线程: " + i);
        }
    }
}
