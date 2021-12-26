class Student(object):
    def __init__(self, name, age):
        self.__name = name
        self.__age = age

    def set_age(self, age):
        if age < 0:
            print("您给定的年龄不合法!")
            return
        self.__age = age

    def get_age(self):
        return self.__age

    def set_name(self, name):
        self.__name = name

    def get_name(self):
        return self.__name

    def __str__(self):
        return f"name:{self.__name},age:{self.__age}"


# 私有:只能在本类中进行访问
# 语法 在属性,方法 加上 两个 _
# __name  __age __show()
stu = Student("张三", 20)
# 私有的属性与方法不能够被子类直接继承
# print(Student.__age)
# print(stu.__age)
# 属性也是变量
# 如何修改 __age的值??
stu.set_age(21)
# 如何获取属性值
age = stu.get_age()
print(age)

print(stu)
