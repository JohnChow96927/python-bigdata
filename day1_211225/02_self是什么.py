# 需求
# 有一条狗 这条狗名字叫 拜登 拜登天天在那汪汪叫
class Dog(object):
    def jiao(self):
        print(self)
        print("天天汪汪叫...")

# 1.每创建一个对象都会开辟一个新的空间
# 2.self谁调用代表的就是谁的地址值

dog = Dog()
dog.jiao()
print(dog)

print("-" * 50)

dog1 = Dog()
dog1.jiao()
print(dog1)
