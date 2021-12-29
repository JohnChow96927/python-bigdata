def get_num(a, b, fn):# get_cj
    print(id(a), id(b), id(fn))
    # fn 就是 get_sum  sum = get_sum(a, b)
    result = fn(a, b)
    return result


def get_sum(a, b):
    return a + b


def get_cj(a, b):
    return a * b


# 函数本身也是一个引用
# 在 python中 函数中进行传参 其实就是引用的传递
# 函数的传递就意味着 功能的传递
a = 10
b = 20
print(id(a), id(b), id(get_sum))
result = get_num(a, b, get_sum)
print(result)

print("------------")

cj = get_num(10, 20, get_cj)
print(cj)
