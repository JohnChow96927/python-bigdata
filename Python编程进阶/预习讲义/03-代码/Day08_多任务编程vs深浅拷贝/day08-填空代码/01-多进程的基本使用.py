"""
多进程的基本使用
学习目标：能够使用多进程同时执行两个不同的任务函数
"""
import time


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




