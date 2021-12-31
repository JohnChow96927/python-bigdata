# 子类如何初始化父类中的属性
# 私有的属性 私有方法 都不能被子类直接继承
class Animal(object):
    def __init__(self, name, age):
        self.__name = name
        self.__age = age

    def __show(self):
        print("私有方法 show")

    def set_age(self, age):
        self.__age = age

    def get_age(self):
        return self.__age

    def set_name(self, name):
        self.__name = name

    def get_name(self):
        return self.__name

    def eat(self):
        print("吃饭.....")


class Dog(Animal):
    def __init__(self, address, name, age):
        super(Dog, self).__init__(name, age)
        self.__address = address

    def set_address(self, address):
        self.__address = address

    def get_address(self):
        return self.__address
        pass


# 私有的不能够直接被继承 可以通过父类中公共方法访问私有的属性
dog = Dog("上海", "狗子", 18)

dog.set_address("北京")
dog.set_name("狗子儿")
dog.set_age(25)

print(dog.get_name(), dog.get_age(), dog.get_address())
