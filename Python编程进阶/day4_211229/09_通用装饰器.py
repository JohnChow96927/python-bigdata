# 一开始存在已经写好的很多功能

# 使用装饰器 增强功能
import traceback


# log for python
# *args 位置参数 缺省参数 关键字参数
def log4p(fn):
    def inner(*args, **kwargs):
        # 增强功能 将传递进来的函数产生的异常 写入到 error.log中
        try:  # (10, 20)
            fn(*args, **kwargs)
        except Exception as e:
            print(traceback.format_exc())
            with open("error.log", "a", encoding="utf-8") as f:
                f.write(traceback.format_exc())

    # 千万别加小括号
    return inner


@log4p
# 功能2
def read_file():
    open("abc.txt", "r", encoding="utf-8")


# 功能4
@log4p  # 相当于 print_list = log4p(print_list)
# a,b = (10,20)
def print_list(a, b, c):
    print(a + b + c)


read_file()
print_list(30, 20, c=20)
# 将产生的异常 写入到error.log中
