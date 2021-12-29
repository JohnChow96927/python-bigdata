def outer(fn):
    def inner():
        print("调用前...")
        fn()
        print("调用后...")

    return inner

# 函数可以作为参数传递
@outer # 相当于 show = outer(show)  调用show其实调用的就是 inner
# 1.将装饰器下面的函数作为参数调用了装饰器的外部函数
# 2.装饰器返回内部函数 赋值给 与被装饰的函数名同名的变量
def show():
    print("今天中午吃鸡腿!")

# 返回闭包的实例
# show = outer(show)
show()
# 一旦使用装饰器装饰了 函数,再拿函数名调用函数的时候 其实调用的是 装饰器的内部函数

