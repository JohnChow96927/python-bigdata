

class Donkey(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def eat(self):
        print("驴吃草...")

    pass


class Horse(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def eat(self):
        print(f"{self.name}吃草...")

    pass


class Mule(Horse):
    pass

# 使用的是 马的属性与方法 还是驴的??
# 类名.__mro__ 方式可以查看继承链
mule = Mule("安倍", 55)
mule.eat()
print(Mule.__mro__)
