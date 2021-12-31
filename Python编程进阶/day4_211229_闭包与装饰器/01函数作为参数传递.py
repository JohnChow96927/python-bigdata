def get_num(a, b, fn):
    print(id(a), id(b), id(fn))


def get_sum(a, b):
    return a + b


a = 10
b = 20
get_num(a, b, get_sum)

# 函数本身也是一个引用
# 在Python中,函数中进行传参,其实就是引用的传递
