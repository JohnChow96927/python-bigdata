class Student(object):
    # 魔法方法
    def __init__(self, name, age):
        # 将局部的变量 变成属性
        # 对象.属性名 = 值
        # print(name, age)
        self.name = name
        self.age = age
        # print("__init__执行了....")

    def study(self):
        print("学生爱学习...")


# __init__ 当创建对象的时候执行__init__函数
# 作用用来初始化: 应该有什么我就给你创建出来 应该有什么值 我就给你赋什么值 最终产生一个对象
# 利用执行时机 帮咱们初始化一些属性
stu = Student("张三", 28)

print(stu.name, stu.age)

stu2 = Student("欣欣", 18)
print(stu2.name, stu2.age)
