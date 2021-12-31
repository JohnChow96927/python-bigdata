class Student(object):
    # 魔法方法
    def __init__(self, name="张三", age=18):
        # 将局部的变量 变成属性
        # 对象.属性名 = 值
        # print(name, age)
        self.name = name
        self.age = age
        # print("__init__执行了....")

    def study(self):
        print("学生爱学习...")

    # 实例对象被删除(del)时或程序结束被释放时执行
    def __del__(self):
        # 释放资源
        print("对象被释放了...")


stu = Student()
del stu
print("-" * 50)


