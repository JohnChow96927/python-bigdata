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
