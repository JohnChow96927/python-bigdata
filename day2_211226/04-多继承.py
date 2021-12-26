class Horse(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def eat(self):
        print("马吃草")


class Donkey(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def eat(self):
        print("驴吃草")


class mule(Horse, Donkey):
    pass
