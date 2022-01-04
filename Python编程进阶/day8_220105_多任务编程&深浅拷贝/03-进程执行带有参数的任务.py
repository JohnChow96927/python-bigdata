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
