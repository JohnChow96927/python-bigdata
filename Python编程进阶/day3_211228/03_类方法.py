class Student(object):
    # 私有化的类属性 特点:只能在本类中进行访问
    __school = "传智专修学院"

    @classmethod
    def set_school(cls,school):
        cls.__school = school

    @classmethod
    def get_school(cls):
        return cls.__school

# 直接对属性进行修改 不安全
# 修改属性 最好是通过方法进行修改
# Student.school = "黑马程序员"
# print(Student.school)
# 操作类属性 类方法 最好的方式  使用类名进行操作
# stu = Student()
# stu.set_school("黑马程序员")
# print(stu.get_school())
Student.set_school("黑马程序员")
print(Student.get_school())