package f_synchronized_code_block;

// 出现线程安全问题
public class TicketsDemo {
    public static void main(String[] args) {
        TicketsRunnable ticketsRunnable = new TicketsRunnable();

        new Thread(ticketsRunnable, "张三").start();
        new Thread(ticketsRunnable, "李四").start();
        new Thread(ticketsRunnable, "王五").start();
        new Thread(ticketsRunnable, "赵六").start();
    }
}
