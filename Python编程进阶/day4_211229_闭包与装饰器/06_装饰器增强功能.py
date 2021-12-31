def outer(fn):
    def inner():
        print("调用前...")
        fn()
        print("调用后...")

    return inner

# 函数可以作为参数传递
def show():
    print("今天中午吃鸡腿!")

# 返回闭包的实例
inner = outer(show)
inner()


