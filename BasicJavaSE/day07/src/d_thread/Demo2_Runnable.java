package d_thread;

/*
    方式二: 实现Runnable接口
        1. 创建一个类, 实现Runnable接口
        2. 实现Runnable中的run()方法
        3. 把要执行的代码放入run()中
        4. 在测试类中创建Thread对象, 并将该类作为参数传入该类对象
 */
public class Demo2_Runnable {
    public static void main(String[] args) {
//        MyRunnable myRunnable = new MyRunnable();
//        Thread thread = new Thread(myRunnable);
//
//        thread.start();
        // 合并执行
        Thread thread = new Thread(new MyRunnable());
        thread.start();
        for (int i = 0; i < 100; i++) {
            System.out.println("main..." + i);
        }
    }
}
