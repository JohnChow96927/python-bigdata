def foo(msg="hello"):
    def outer(fn):
        def inner(*args, **kwargs):
            print(msg)
            # 增强函数功能
            print("增强....")
            result = fn(*args, **kwargs)
            # 增强函数功能
            return result

        return inner

    return outer


@foo("world")
# outer = foo("hello world")
# get_sum = outer(get_sum)
def get_sum(a, b):
    return a + b


print(get_sum(10, 20))
