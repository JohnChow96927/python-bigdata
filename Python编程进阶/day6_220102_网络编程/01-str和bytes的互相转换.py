"""
str和bytes的互相转换
学习目标：知道str和bytes数据之间的互相转换
"""
# str -> bytes：str.encode('编码方式：默认utf8')
# bytes -> str：bytes.decode('解码方式：默认utf8')

my_str = '你好！中国！'  # str
print(type(my_str), my_str)

# bytes: 字节流
res1 = my_str.encode()  # 等价于 res1 = my_str.encode('utf8')
print(type(res1), res1)

print(res1.decode())
# 编解码方式必须一致, 否则可能会出现乱码或报错
