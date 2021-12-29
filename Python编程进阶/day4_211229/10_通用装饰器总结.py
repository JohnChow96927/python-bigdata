def outer(fn):
    def inner(*args, **kwargs):
        # 增强函数功能
        print("增强....")
        result = fn(*args, **kwargs)
        # 增强函数功能
        return result

    return inner


@outer
def get_sum(a, b):
    return a + b

@outer # 没有返回值的函数 返回 none
def print_num(num):
    print(num)

sum = get_sum(10, b = 20)
print(sum)

print_num(20)
