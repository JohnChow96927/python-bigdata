class Student(object):
    __school = "黑马"

    @classmethod
    def set_school(cls, school):
        cls.__school = school

    @classmethod
    def get_school(cls):
        return cls.__school


# 修改属性最好是通过类方法进行修改, 需要使用类方法
Student.set_school("黑马程序员")
print(Student.get_school())
