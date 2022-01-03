"""
线程使用的注意点
学习目标：知道线程使用的 3 个注意点
"""

"""
线程使用的注意点介绍：
1）线程之间执行是无序的
2）主线程会等待所有的子线程执行结束再结束
3）线程之间共享全局变量
"""


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

# 注意点2：主线程会等待所有的子线程执行结束再结束
# import threading
# import time
#
#
# def task():
#     for i in range(5):
#         print('任务执行中...')
#         time.sleep(0.5)
#
#
# if __name__ == '__main__':
#     # 创建子线程
#     sub_thread = threading.Thread(target=task)
#     sub_thread.start()
#
#     # 主进程延时 1s
#     time.sleep(1)
#     print('主线程结束！')


# 注意点3：线程之间共享全局变量
# import threading
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
#     # 创建添加数据的子线程
#     add_data_thread = threading.Thread(target=add_data)
#     # 创建读取数据的子线程
#     read_data_thread = threading.Thread(target=read_data)
#
#     # 启动添加数据子线程
#     add_data_thread.start()
#     # 主线程等待 add_data_thread 执行完成，再向下继续执行
#     add_data_thread.join()
#     # 启动读取数据子线程
#     read_data_thread.start()
#
#     print('main：', g_list)
