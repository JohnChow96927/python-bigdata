# 多任务编程&深浅拷贝

## I. 多任务编程

1. ### 多任务的基本概念

    - 多个任务同时执行
    - 充分利用CPU资源, 提高程序执行效率

2. ### 多任务实现方式:

    > **多进程**&**多线程**

3. ### 多任务执行方式:

    > **并发**&**并行**

    并发: 在同一时间内快速交替去执行多个任务, 要求任务数量大于CPU的核心数

    并行: 同一时间内同时一起执行多个任务, 要求任务数量小于等于CPU的核心数

4. ### 进程的基本概念

    - 资源分配的最小单位, 它是**操作系统进行资源分配的基本单位**, 一个正在运行的程序就是一个进程

        > **一个程序运行后至少有一个进程**

5. ### Python中多进程的基本使用

    ```python
    """
    多进程的基本使用
    学习目标：能够使用多进程同时执行两个不同的任务函数
    """
    import time
    # 1.导入多进程包
    import multiprocessing
    
    
    # 跳舞函数
    def dance():
        for i in range(5):
            print('跳舞中...')
            time.sleep(1)
    
    
    # 唱歌函数
    def sing():
        for i in range(5):
            print('唱歌中...')
            time.sleep(1)
    
    
    if __name__ == '__main__':
        # 创建一个进程, 指定执行dance函数, 注意target=函数名, 不能加括号
        dance_process = multiprocessing.Process(target=dance)
        # 再创建一个进程, 指定执行sing函数
        sing_process = multiprocessing.Process(target=sing)
        
        # 启动两个进程
        dance_process.start()
        sing_process.start()
    ```

6. ### 进程关系-主进程和子进程

    - 命令行执行:

        tasklist: 查看Windows系统中整体执行的进程

        tasklist | findstr python: 查看Windows系统中正在运行的Python进程

    - 获取进程编号函数:

        ```python
        import os
        os.getpid()		# 获取当前进程的编号
        os.getppid()	# 获取当前进程父进程的编号
        ```

7. ### 进程执行带有参数的任务

    ```python
    """
    进程执行带有参数的任务(函数)
    学习目录：能够使用多进程执行带有参数的任务
    """
    
    import multiprocessing
    import time
    
    
    # 带有参数的任务(函数)
    def task(count):
        for i in range(count):
            print('任务执行中...')
            time.sleep(0.2)
        else:
            print('任务执行完成')
    
    
    if __name__ == '__main__':
        # 创建一个进程, 指定执行task函数
        # 通过元组指定任务函数的参数: args=(5, ), 按照参数顺序指定参数的值
        # sub_process = multiprocessing.Process(target=task, args(5, ))
    
        # 通过字典指定任务函数的参数: kwargs={'count': 3}, 按照参数名称指定参数的值
        sub_process = multiprocessing.Process(target=task, kwargs={'count': 3})
    
        # 启动进程
        sub_process.start()
    ```

    

8. ### 进程使用的2个注意点

    - 进程之间不共享全局变量

    > 创建子进程时, 子进程会将主进程的内容全部复制一份

    ```python
    # 注意点1：进程之间不共享全局变量
    import multiprocessing
    import time
    
    # 定义全局变量
    g_list = []
    
    
    # 添加数据的函数
    def add_data():
        for i in range(5):
            g_list.append(i)
            print('add：', i)
            time.sleep(0.2)
    
        print('add_data：', g_list)
    
    
    # 读取数据的函数
    def read_data():
        print('read_data：', g_list)
    
    
    if __name__ == '__main__':
        # 创建添加数据的子进程
        add_data_process = multiprocessing.Process(target=add_data)
        # 创建读取数据的子进程
        read_data_process = multiprocessing.Process(target=read_data)
    
        # 启动添加数据子进程
        add_data_process.start()
        # 主进程等待 add_data_process 执行完成，再向下继续执行
        add_data_process.join()
        # 启动读取数据子进程
        read_data_process.start()
    
        print('main：', g_list)
    ```

    

    - 主进程会等待所有的子进程结束再结束

    ```python
    # 注意点2：主进程会等待所有的子进程执行结束再结束
    import multiprocessing
    import time
    
    
    # 任务函数
    def task():
        for i in range(10):
            print('任务执行中...')
            time.sleep(0.2)
    
    
    if __name__ == '__main__':
        # 创建子进程并启动
        sub_process = multiprocessing.Process(target=task)
        sub_process.start()
    
        # 主进程延时 1s
        time.sleep(1)
        print('主进程结束！')
        # 退出程序
        exit()
    ```

9. ### 守护进程和终止子进程

    1. 将子进程设置为守护进程

    ```python
    import multiprocessing
    import time
    
    
    # 方式1：将子进程设置为守护进程
    
    # 任务函数
    def task():
        for i in range(10):
            print('任务执行中...')
            time.sleep(0.2)
    
    
    if __name__ == '__main__':
        # 创建子进程并启动
        sub_process = multiprocessing.Process(target=task)
        # TODO：设置子进程为守护进程
        sub_process.daemon = True
        sub_process.start()
    
        # 主进程延时 1s
        time.sleep(1)
        print('主进程结束！')
        # 退出程序
        exit()
    ```

    2. 主进程结束时终止子进程

    ```python
    import multiprocessing
    import time
    
    
    # 任务函数
    def task():
        for i in range(10):
            print('任务执行中...')
            time.sleep(0.2)
    
    
    if __name__ == '__main__':
        # 创建子进程并启动
        sub_process = multiprocessing.Process(target=task)
        sub_process.start()
    
        # 主进程延时 1s
        time.sleep(1)
        print('主进程结束！')
        # TODO: 终止子进程
        sub_process.terminate()
        # 退出程序
        exit()
    ```

10. ### 线程的基本概念

    - CPU调度的基本单位

    > 进程理解为公司, 线程理解为公司中的员工. 公司负责提供资源, 员工负责实际干活

11. Python中多线程的基本使用

    ```python
    """
    多线程的基本使用
    学习目标：能够使用多线程同时执行两个不同的函数
    """
    
    import time
    # 导入线程模块
    import threading
    
    
    # 跳舞任务函数
    def dance():
        for i in range(5):
            print('正在跳舞...%d' % i)
            time.sleep(1)
    
    
    # 唱歌任务函数
    def sing():
        for i in range(5):
            print('正在唱歌...%d' % i)
            time.sleep(1)
    
    
    if __name__ == '__main__':
        # 创建一个线程, 执行dance任务函数
        dance_thread = threading.Thread(target=dance)
    
        # 再创建一个线程, 执行sing任务函数
        sing_thread = threading.Thread(target=sing)
    
        # 启动这两个线程
        dance_thread.start()
        sing_thread.start()
    ```

12. 线程执行带有参数的任务

    ```python
    """
    线程执行带有参数的任务(函数)
    学习目录：能够使用多线程执行带有参数的任务
    """
    # 导入线程模块
    import threading
    import time
    
    
    # 带有参数的任务(函数)
    def task(count):
        for i in range(count):
            print('任务执行中...')
            time.sleep(0.2)
        else:
            print('任务执行完成')
    
    
    if __name__ == '__main__':
        # 创建一个线程，执行 task 任务函数
        # sub_thread = threading.Thread(target=task, args=(3, ))
        sub_thread = threading.Thread(target=task, kwargs={'count': 5})
        # 启动线程
        sub_thread.start()
    ```

13. 线程使用的3个注意点

    1. 线程之间的执行是无序的

    ```python
    # 注意点1：线程之间执行是无序的
    import threading
    import time
    
    
    def task():
        time.sleep(1)
        print(f'当前线程：{threading.current_thread().name}')
    
    
    if __name__ == '__main__':
        for i in range(5):
            sub_thread = threading.Thread(target=task)
            sub_thread.start()
    ```

    2. 主线程会等待所有的子线程执行结束再结束

    ```python
    # 注意点2：主线程会等待所有的子线程执行结束再结束
    import threading
    import time
    
    
    def task():
        for i in range(5):
            print('任务执行中...')
            time.sleep(0.5)
    
    
    if __name__ == '__main__':
        # 创建子线程
        sub_thread = threading.Thread(target=task)
        sub_thread.start()
    
        # 主进程延时 1s
        time.sleep(1)
        print('主线程结束！')
    ```

    3. 线程之间共享全局变量

    ```python
    # 注意点3：线程之间共享全局变量
    import threading
    import time
    
    # 定义全局变量
    g_list = []
    
    
    # 添加数据的函数
    def add_data():
        for i in range(5):
            g_list.append(i)
            print('add：', i)
            time.sleep(0.2)
    
        print('add_data：', g_list)
    
    
    # 读取数据的函数
    def read_data():
        print('read_data：', g_list)
    
    
    if __name__ == '__main__':
        # 创建添加数据的子线程
        add_data_thread = threading.Thread(target=add_data)
        # 创建读取数据的子线程
        read_data_thread = threading.Thread(target=read_data)
    
        # 启动添加数据子线程
        add_data_thread.start()
        # 主线程等待 add_data_thread 执行完成，再向下继续执行
        add_data_thread.join()
        # 启动读取数据子线程
        read_data_thread.start()
    
        print('main：', g_list)
    ```

14. ### 守护线程设置

15. ### 线程的资源共享问题

16. ### 线程资源共享问题解决: 线程等待vs互斥锁

17. ### 进程和线程对比

## II. 深拷贝和浅拷贝

1. ### 浅拷贝



2. ### 深拷贝

