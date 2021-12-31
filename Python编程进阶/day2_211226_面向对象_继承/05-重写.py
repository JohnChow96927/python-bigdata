# 重写 子类中出现了父类中一模一样的方法
class Animal(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def eat(self):
        print("吃饭...")


class Dog(Animal):

    # 特有的功能
    def look_house(self):
        print("狗看家....")

    # 重写父类的方法
    def eat(self):
        print("狗吃骨头...")


class Cat(Animal):

    # 特有的功能
    def catch_mouse(self):
        print("猫抓老鼠....")


cat = Cat("小花", 8)
cat.eat()
cat.catch_mouse()

dog = Dog("旺财", 10)
dog.eat()
dog.look_house()
