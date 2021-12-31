# 需求:
# 有一个学生 名字叫:茂茂 年龄28 爱好:喝酒 跳伞 抡大锤
# 方法其实就是咱们前面学习的函数 只是叫法不一样
class Student(object):
    def drink(self):
        print("李十瓶...")

    def jump(self):
        print("裸身跳伞...")


# 创建对象
stu = Student()

stu.drink()
stu.jump()

# 添加属性
stu.name = "茂茂"
stu.age = 28

# 获取属性
print(stu.name, stu.age)
