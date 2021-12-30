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

    def eat(self):
        print("准备骨头...")
        # 类名.方法(self) 可以调用任何类中的方法
        # super(Dog)
        # Animal.eat(self)
        # 第二种格式
        # super(子类,self).eat() 调用的是谁的方法:给定的这个子类对应的父类的方法
        super(Dog, self).eat()
        # 第二种格式的简写形式 super().父类的方法() 只能调用当前这个类的父类方法
        super().eat()
        print("打扫卫生")


class Cat(Animal):

    # 特有的功能
    def catch_mouse(self):
        print("猫抓老鼠....")


dog = Dog("旺财", 10)
dog.eat()
dog.look_house()

cat = Cat("小花", 8)
cat.eat()
cat.catch_mouse()
