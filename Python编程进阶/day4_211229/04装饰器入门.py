# def outer(fn):
#     def inner():
#         fn()
#
#     return inner
#
#
# def show():
#     print("niu")
#
#
# inner = outer(show)
# inner()

import traceback
from functools import wraps

from log4py import log4p


@log4p()
def show():
    num = 10 / 0
    return num


@log4p()
def show2():
    num = 20 / 2
    return num


@log4p()
def print_list(my_list):
    for s in my_list:
        print(s)


show()
show2()
print_list([1, 2, 3, 4])
