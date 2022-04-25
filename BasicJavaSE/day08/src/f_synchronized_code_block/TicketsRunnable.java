package f_synchronized_code_block;

public class TicketsRunnable implements Runnable {
    private int tickets = 100;
    private Object lock = new Object();

    @Override
    public void run() {
        while (true) {
            synchronized (lock) {   // 使用同步代码块解决线程安全问题
                if (tickets > 0) {
                    try {
                        Thread.sleep(10);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    System.out.println(Thread.currentThread().getName() + "正在出售第" + (101 - tickets) + "张票");
                    tickets--;
                } else {
                    break;
                }
            }
        }
    }
}
