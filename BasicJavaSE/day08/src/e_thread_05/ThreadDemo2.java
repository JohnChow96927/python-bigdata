package e_thread_05;

public class ThreadDemo2 {
    public static void main(String[] args) {
        new Thread(() -> {
            System.out.println("实现的方式...");
        }) {
            @Override
            public void run() {
                System.out.println("继承Thread的线程...");
            }
        }.start();
    }
}
