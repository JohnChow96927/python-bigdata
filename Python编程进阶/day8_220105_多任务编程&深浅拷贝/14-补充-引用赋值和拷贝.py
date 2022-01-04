# 核心内容: =号赋值的本质是引用赋值

a = 1
print('id(a): ', id(a), 'id(1): ', id(1))
b = a
print('id(b): ', id(b))
a = 2
print('id(a): ', id(a))

