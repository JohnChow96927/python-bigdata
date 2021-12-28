def makebold(fn):  # 闭包
    def wrapped():
        return "<b>" + fn() + "</b>"

    return wrapped


def makeitalic(fn):  # 闭包
    def wrapped():
        return "<i>" + fn() + "</i>"

    return wrapped


@makebold  # 后执行
@makeitalic  # 装饰器由近及远顺序执行
def hello():
    return "hello world"


print(hello())  # <b><i>hello world</i></b>


class Animal:
    def __init__(self, animal):
        self.animal = animal

    def sound(self, voice):
        print(self.animal, ":", voice, "....")


dog = Animal("dog")
dog.sound("wangwang")
dog.sound("wofwof")


def voice(animal):
    def sound(v):
        print(animal, ":", v, "...")

    return sound


cat = voice('cat')
cat("miao")
cat("miaomiao")
