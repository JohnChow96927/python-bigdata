package g_synchronized_method;

public class TicketsDemo {
    public static void main(String[] args) {
        TicketsRunnable ticketsRunnable = new TicketsRunnable();
        new Thread(ticketsRunnable, "张三").start();
        new Thread(ticketsRunnable, "李四").start();
        new Thread(ticketsRunnable, "王五").start();
        new Thread(ticketsRunnable, "赵六").start();
    }
}
