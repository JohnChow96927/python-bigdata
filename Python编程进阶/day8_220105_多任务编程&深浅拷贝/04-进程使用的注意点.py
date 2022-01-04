"""
进程使用的注意点：
学习目标：知道进程使用的 2 个注意点
"""

"""
进程使用的注意点介绍：
1）进程之间不共享全局变量
2）主进程会等待所有的子进程执行结束再结束
"""

# # 注意点1：进程之间不共享全局变量
# import multiprocessing
# import time
#
# # 定义全局变量
# g_list = []
#
#
# # 添加数据的函数
# def add_data():
#     for i in range(5):
#         g_list.append(i)
#         print('add：', i)
#         time.sleep(0.2)
#
#     print('add_data：', g_list)
#
#
# # 读取数据的函数
# def read_data():
#     print('read_data：', g_list)
#
#
# if __name__ == '__main__':
#     # 创建添加数据的子进程
#     add_data_process = multiprocessing.Process(target=add_data)
#     # 创建读取数据的子进程
#     read_data_process = multiprocessing.Process(target=read_data)
#
#     # 启动添加数据子进程
#     add_data_process.start()
#     # 主进程等待 add_data_process 执行完成，再向下继续执行
#     add_data_process.join()
#     # 启动读取数据子进程
#     read_data_process.start()
#
#     print('main：', g_list)

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
