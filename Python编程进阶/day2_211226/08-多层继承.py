class Person(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def eat(self):
        print("吃饭...")

    def speak(self):
        print("讲国语...")


class Player(Person):

    def study(self):
        print("学习...")


class Coach(Person):

    def teach(self):
        print("教练教学...")


class PingPangPlayer(Player):

    def study(self):
        print("学习打乒乓球...")

    def speak(self):
        # 找父类 父类中没有 再找父类的父类... 直到找到就调用, 找不到就报错...
        super().speak()
        print("讲英语...")


class PingPangCoach(Coach):

    def teach(self):
        print("教运动员打乒乓球...")

    def speak(self):
        super().speak()
        print("将英语...")


class BasketballPlayer(Player):

    def study(self):
        print("学习打篮球...")

    def speak(self):
        super().speak()
        print("将德语...")


class BasketballCoach(Coach):

    def teach(self):
        print("教运动员打篮球...")

    def speak(self):
        super().speak()
        print("将德语...")


class FootballPlayer(Player):

    def study(self):
        print("学习踢足球...")


class FootballCoach(Coach):

    def teach(self):
        print("教运动员踢足球...")


ppp = PingPangPlayer("马龙", 30)
ppp.eat()
ppp.study()
ppp.speak()
