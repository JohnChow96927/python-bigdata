package h_die_lock;

public class DieLockDemo {
    private static final Object lock1 = new Object();
    private static final Object lock2 = new Object();

    public static void main(String[] args) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                synchronized (lock1) {
                    System.out.println("持有锁对象一, 等待锁对象二");
                    synchronized (lock2) {
                        System.out.println("线程一: 只有同时持有两个锁对象才能到达这里");
                    }
                }
            }
        }).start();
        new Thread(new Runnable() {
            @Override
            public void run() {
                synchronized (lock2) {
                    System.out.println("持有锁对象二, 等待锁对象一");
                    synchronized (lock1) {
                        System.out.println("线程二: 只有同时持有两个锁对象才能到达这里");
                    }
                }
            }
        }).start();
    }
}
