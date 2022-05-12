package com.johnchow.flink.test;

public class JavaThreadTest {
    // 方式一: 创建类, 实现接口(属于内部类 -> 定义在类中的类)
    static class MyThread implements Runnable {

        @Override
        public void run() {
            long counter = 1;
            while (true) {
                System.out.println(counter + ".....................");
                counter++;
            }
        }
    }

    public static void main(String[] args) {
        Thread thread = new Thread(new MyThread());
        thread.start();
        Thread thread2 = new Thread(
                () -> {
                    long counter = 1;
                    while (true) {
                        System.out.println(counter +
                                "...............");
                        counter++;
                    }
                }
        );
        thread2.start();
    }
}
