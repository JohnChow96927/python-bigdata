class Animal(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def eat(self):
        print(f"{self.name}吃饭")


class Dog(Animal):
    def look_house(self):
        print(f"{self.name}看家")


class Cat(Animal):
    def catch_mouse(self):
        print(f"{self.name}抓老鼠")


cat = Cat("小花", 3)
dog = Dog("旺财", 5)
cat.eat()
cat.catch_mouse()
dog.eat()
dog.look_house()
