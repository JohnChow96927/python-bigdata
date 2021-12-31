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

    # 直接print实例对象时调用, 打印返回值
    def __str__(self):
        return f"name:{self.name}\nage:{self.age}"


# 注意__str__函数作用.当我们直接打印输出对象的时候 默认打印的是地址值
# __str__函数中 return 什么 就打印什么
stu = Student("张三", 28)
print(stu)
