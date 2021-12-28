# 学生管理系统
class Student(object):
    # 设置类属性school
    school = "黑马程序员"

    def __init__(self, name, age, school):
        self.name = name
        self.age = age
        self.school = school

    def eat(self):
        print("吃....")


# 属性产生重复, 抽取属性
stu1 = Student("小王", 18, "黑马程序员")
stu2 = Student("大王", 19, "黑马程序员")
stu3 = Student("小郭", 20, "黑马程序员")
