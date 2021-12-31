# 学生管理系统
class Student(object):
    school = "传智专修学院"

    def __init__(self, name, age):
        self.name = name
        self.age = age

    def eat(self):
        print("吃...")

    def __str__(self):
        return f"name:{self.name},age:{self.age},school:{self.school}"


stu1 = Student("小王", 18)
stu2 = Student("大王", 19)
stu3 = Student("小郭", 20)
# stu1.school = "黑马程序员"
# 类属性 即可以使用 类名.类属性 也可以使用对象.类属性
print(stu1.name, stu1.age, stu1.school, Student.school)
print(stu2.name, stu2.age, stu2.school, Student.school)
print(stu3.name, stu3.age, stu3.school, Student.school)
# 这种方式定义实例属性
# stu1.school = "黑马程序员"
Student.school = "黑马程序员"
print(stu1)
print(stu2)
print(stu3)
