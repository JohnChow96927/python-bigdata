"""
多线程的基本使用
学习目标：能够使用多线程同时执行两个不同的函数
"""

import time


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

