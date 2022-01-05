"""
进程关系-主进程和子进程
学习目标：知道主进程和子进程的关系
"""
import time
# 导入进程包
import multiprocessing
import os


# 跳舞函数
def dance():
    # TODO：获取 dance 进程的编号和其父进程的编号
    print(f'子进程编号: {os.getpid()}, 父进程编号: {os.getppid()}')
    for i in range(5):
        print('跳舞中...')
        time.sleep(1)


# 唱歌函数
def sing():
    for i in range(5):
        print('唱歌中...')
        time.sleep(1)


if __name__ == '__main__':
    # TODO：获取主进程的编号和其父进程的编号
    print(f'主进程编号: {os.getpid()}, 父进程编号: {os.getppid()}')
    # 创建一个进程，执行 dance 函数
    dance_process = multiprocessing.Process(target=dance) # 注意：target指定的是函数名或方法名，不要再函数名或方法名后加()

    # 再创建一个进程，执行 sing 函数
    sing_process = multiprocessing.Process(target=sing)

    # 启动这两个进程
    dance_process.start()
    sing_process.start()


# 思考题：上面的代码运行时，一共有几个进程？？？


