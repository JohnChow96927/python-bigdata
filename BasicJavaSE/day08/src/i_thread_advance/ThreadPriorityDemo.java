package i_thread_advance;

public class ThreadPriorityDemo {
    public static void main(String[] args) {
        ThreadPriority threadPriority1 = new ThreadPriority();
        ThreadPriority threadPriority2 = new ThreadPriority();
        ThreadPriority threadPriority3 = new ThreadPriority();

        threadPriority1.setName("高铁");
        threadPriority2.setName("飞机");
        threadPriority3.setName("汽车");

        System.out.println(threadPriority1.getPriority());
        System.out.println(threadPriority2.getPriority());
        System.out.println(threadPriority3.getPriority());

        System.out.println(Thread.MAX_PRIORITY);
        System.out.println(Thread.MIN_PRIORITY);
        System.out.println(Thread.NORM_PRIORITY);

        threadPriority1.setPriority(Thread.NORM_PRIORITY);
        threadPriority2.setPriority(Thread.MAX_PRIORITY);
        threadPriority3.setPriority(Thread.MIN_PRIORITY);

        threadPriority1.start();
        threadPriority2.start();
        threadPriority3.start();
    }
}
