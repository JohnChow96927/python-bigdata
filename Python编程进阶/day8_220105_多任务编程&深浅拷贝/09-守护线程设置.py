"""
守护线程
学习目标：能够设置守护线程
"""

"""
如何让主线程执行结束时，子线程就结束执行？
答：将子线程设置为守护线程
"""

import threading
import time


# 任务函数
def task():
    for i in range(10):
        print('任务执行中...')
        time.sleep(0.2)


if __name__ == '__main__':
    # 创建子线程并启动
    sub_thread = threading.Thread(target=task)
    # TODO：设置子线程为守护线程

    sub_thread.start()

    # 主线程延时 1s
    time.sleep(1)
    print('主线程结束！')
