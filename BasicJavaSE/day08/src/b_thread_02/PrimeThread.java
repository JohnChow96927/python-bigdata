package b_thread_02;

public class PrimeThread extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 10; i++) {
            System.out.println(getName() + "子线程" + i);
        }
    }

    public PrimeThread() {
    }

    public PrimeThread(String name) {
        super(name);
    }
}
