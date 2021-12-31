# 每创建一个对象 统计出来
# 统计个数 通过变量记录
# 局部变量 全局变量 实例变量 类变量
# 类变量:共享
# 如何证明当前的类创建了一个对象??
# init魔法方法每执行一次 就证明创建了一个对象


class Student(object):
    __count = 0

    def __init__(self):
        Student.__count += 1

    @classmethod
    def get_count(cls):
        return cls.__count


stu = Student()

stu1 = Student()

stu2 = Student()

print(Student.get_count())
