# class Student(object):
#     def __init__(self, name, age):
#         self.name = name
#         self.age = age
#
#     def print_info(self):
#         print(self.name)
#         print(self.age)
#
#
# stu = Student()
# stu.print_info()
class SweetPotato(object):
    # 定义属性
    def __init__(self, timed=0, condition='生的', flavours=[]):
        self.timed = timed
        self.condition = condition
        self.flavours = flavours

    def __str__(self):
        return f"当前地瓜烤了{self.timed}分钟，当前状态为{self.condition}，添加的调料为{self.flavours}"

    # 行为
    def bake_sweet_potato(self, timed):
        """
        烤地瓜行为函数
        """
        if timed < 0:
            print("您给定的时间有误！")
            return
        # 将烤地瓜的时间进行累加
        self.timed += timed
        if 3 > self.timed >= 0:
            self.condition = "生的"
        elif 3 <= self.timed < 5:
            self.condition = "半生不熟的"
        elif 5 <= self.timed < 8:
            self.condition = "熟了"
        elif self.timed >= 8:
            self.condition = "糊了"

    def add_flavour(self, flavour):
        """
        添加调料行为函数
        :param flavour: 调料， str
        """
        self.flavours.append(flavour)


sp = SweetPotato()
sp.add_flavour("油")
sp.bake_sweet_potato(2)
print(sp)
sp.add_flavour("盐")
sp.bake_sweet_potato(3)
print(sp)
sp.add_flavour("孜然")
sp.bake_sweet_potato(1)
print(sp)
sp.add_flavour("辣椒")
sp.bake_sweet_potato(1)
print(sp)
