# 烤地瓜
# 被烤的时间和对应的地瓜状态：
# 	0-3分钟：生的
# 	3-5分钟：半生不熟
# 	5-8分钟：熟的
# 	超过8分钟：烤糊了
# 添加的调料：
# 	用户可以按自己的意愿添加调料
# 需求涉及一个事物： 地瓜，故案例涉及一个类：地瓜类。
# 定义类
# 1. 地瓜的属性
# 被烤的时间
# 地瓜的状态
# 2. 地瓜的方法
# 被烤
# 用户根据意愿设定每次烤地瓜的时间
# 判断地瓜被烤的总时间是在哪个区间，修改地瓜状态

class SweetPotato(object):
    # 定义属性 当地瓜被创建出来的时候 time 与 status 有初始化值
    # time = 0
    # status = "生的"
    def __init__(self, time=0, status="生的"):
        self.time = time
        self.status = status
        pass

    # 烤地瓜方法
    def baked_sweet_potato(self, time):
        # 给定的time 是负数
        # 将烤地瓜的时间进行累加
        if time < 0:
            print("您给定的时间有误")
            return
        self.time += time
        if 0 <= self.time < 3:
            self.status = "生的"
        elif 3 <= self.time < 5:
            self.status = "半生不熟的"
        elif 5 <= self.time < 8:
            self.status = "熟的"
        elif self.time >= 8:
            self.status = "糊了"
        pass

    def __str__(self):
        return f"当前地瓜烤了{self.time}分钟,当前的状态为{self.status}"


sp = SweetPotato()
sp.baked_sweet_potato(3)
print(sp)

sp.baked_sweet_potato(3)
print(sp)

sp.baked_sweet_potato(3)
print(sp)

sp.baked_sweet_potato(-3)
print(sp)
