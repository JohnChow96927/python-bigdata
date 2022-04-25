package c_thread_03;

public class PrimeThread extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 10; i++) {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(getName() + "子线程..." + i);
        }
    }

    public PrimeThread() {
    }

    public PrimeThread(String name) {
        super(name);
    }
}
