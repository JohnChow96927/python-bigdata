package d_thread;
/*
多线程的介绍
    概述: 指的是进程有多个执行的路径, 统称为多线程
        进程: 资源分配的最小单位, 有独立的堆栈空间
        线程: CPU调度的最小单位, 也是最小的执行单位, 资源共享
    多线程并发和并行的区别: (Python中同一个进程的多个线程之间不可并行, Java可以)
        并行: 两个或者以上的线程同时执行, 前提: 必须有多核CPU
        并发: 多个线程同时请求执行, 由CPU分配时间片, 在不同线程间快速切换, 但是同一瞬时, 只能有一条线程被执行

    注意: 一般情况下, 并发和并行是同时存在的, 由CPU调度
多线程的实现方式(Java):
    方式一: 继承Thread类
        1. 创建一个类继承Thread类
        2. 重写Thread中的run()方法
        3. 把要执行的代码写入run()方法中
        4. 在测试类中创建线程对象
        5. 开启线程
            开启线程使用的是start方法, 但是调用run方法不会报错, 只是没有多线程效果
            同一个线程不能重复开启, 否则会报错
    方式二: 实现Runnable接口
        1. 创建一个类, 实现Runnable接口
        2. 实现Runnable中的run()方法
        3. 把要执行的代码放入run()中
        4. 在测试类中创建Thread对象, 并将该类作为参数传入该类对象
 */
public class Demo_Intro {
    public static void main(String[] args) {
        for (int i = 0; i < 100; i++) {
            System.out.println("run..." + i);
        }
        for (int i = 0; i < 100; i++) {
            System.out.println("main..." + i);
        }
    }
}
