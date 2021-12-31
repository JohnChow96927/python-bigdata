class Animal(object):
    def __init__(self, name, age):
        """
        动物类对象初始化
        :param name: 动物名
        :param age: 年龄
        """
        self.name = name
        self.age = age

    def eat(self):
        """
        吃方法
        :return: None
        """
        print(f"{self.name}吃饭")


class Dog(Animal):
    def look_house(self):
        """
        看家方法
        :return: None
        """
        print(f"{self.name}看家")


class Cat(Animal):
    def catch_mouse(self):
        """
        捉老鼠方法
        :return: None
        """
        print(f"{self.name}抓老鼠")


cat = Cat("小花", 3)
dog = Dog("旺财", 5)
cat.eat()
cat.catch_mouse()
dog.eat()
dog.look_house()
