def outer():
    # 整个outer函数内
    a = 10

    def inner():
        # a += 10 a = a + 10 不要这么定义 否则无法确认使用的到底是外部还是内部函数的变量
        return a

    return inner

# 1.函数嵌套
# 2.内部函数使用外部函数变量
# 3.外部函数返回内部函数

inner = outer()
a = inner()
print(id(inner))
print(a + 10)