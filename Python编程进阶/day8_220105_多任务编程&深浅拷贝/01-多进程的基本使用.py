"""
多进程的基本使用
学习目标：能够使用多进程同时执行两个不同的任务函数
"""
import os
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
    print(f"父进程编号: {os.getppid()}")
    # 创建一个进程, 指定执行dance函数
    dance_process = multiprocessing.Process(target=dance)
    # 再创建一个进程, 指定执行sing函数
    sing_process = multiprocessing.Process(target=sing)

    # 启动两个进程
    dance_process.start()
    sing_process.start()
