# 需求:
# 有一个学生 名字叫:茂茂 年龄28 爱好:喝酒 跳伞 抡大锤
# 方法其实就是咱们前面学习的函数 只是叫法不一样
# 需求: 使用类中的方法打印对象中的属性
class Student(object):

    def print_field(self):
        print(self.name, self.age)


# 创建对象
stu = Student()
stu.name = "茂茂"
stu.age = 28

stu.print_field()

stu1 = Student()
stu1.name = "欣欣"
stu1.age = 18
stu1.print_field()
# 打印对象中的方法地址的时候 记得加小括号 否则是定义了一个属性
print(id(stu.print_field()), id(stu1.print_field()))
