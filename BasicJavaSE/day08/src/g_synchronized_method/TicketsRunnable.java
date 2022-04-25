package g_synchronized_method;

public class TicketsRunnable implements Runnable {
    private int tickets = 100;
    @Override
    public void run() {
        while (true) {
            sellTickets();
            if (tickets <= 0) {
                break;
            }
        }
    }
    public synchronized void sellTickets() {
        if (tickets > 0) {
            try {
                Thread.sleep(10);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getName() + "正在出售第" + (101 - tickets) + "张票");
            tickets--;
        }
    }
}
