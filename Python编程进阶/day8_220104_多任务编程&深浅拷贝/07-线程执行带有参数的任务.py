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
