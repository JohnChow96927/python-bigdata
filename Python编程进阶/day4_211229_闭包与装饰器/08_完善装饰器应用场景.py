# 一开始存在已经写好的很多功能

# 使用装饰器 增强功能
import traceback
# log for python
def log4p(fn):
    def inner():
        # 增强功能 将传递进来的函数产生的异常 写入到 error.log中
        try:
            fn()
        except Exception as e:
            print(traceback.format_exc())
            with open("error.log", "a", encoding="utf-8") as f:
                f.write(traceback.format_exc())

    # 千万别加小括号
    return inner

@log4p
# 功能1
def show():
    print(10 / 0)

@log4p
# 功能2
def read_file():
    open("abc.txt", "r", encoding="utf-8")

@log4p
# 功能3
def print_name():
    print(name)


# 功能4
@log4p  # 相当于 print_list = log4p(print_list)
def print_list():
    my_list = [21, 2, 2, 1, 213, 12]
    for s in my_list:
        print(s)

show()
read_file()
print_name()
print_list()
# 将产生的异常 写入到error.log中
