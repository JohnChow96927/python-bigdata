class Horse(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

    @staticmethod
    def eat():
        print("马吃草")


class Donkey(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

    @staticmethod
    def eat():
        print("驴吃草")


class Mule(Horse, Donkey):
    pass

