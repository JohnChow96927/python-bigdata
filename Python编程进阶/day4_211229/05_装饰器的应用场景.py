import traceback

# 1.已经是完成的功能  内部的代码不能修改(代码不能修改)
# 2.想让当前的函数具有将异常信息写入到文件中的能力(对原有的功能进行增强)

# 使用装饰器:
# 装饰器应用场景: 在不改变原有函数的源代码的情况下,给函数增加新的功能

def show():
    num = 10 / 0


def show2():
    num = 10 / 0


try:
    show()
except Exception as e:
    with open("error.log", "a", encoding="utf-8") as f:
        f.write(traceback.format_exc())


try:
    show2()
except Exception as e:
    with open("error.log", "a", encoding="utf-8") as f:
        f.write(traceback.format_exc())
