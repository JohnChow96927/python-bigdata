# 需求
# 有一条狗 这条狗汪汪叫
# 创建Dog类
class Dog(object):
    # 叫方法, self为实例对象的引用地址
    def jiao(self):
        print(self)
        print("天天汪汪叫...")


# 1.每创建一个对象都会开辟一个新的空间
# 2.self谁调用代表的就是谁的地址值
# 创建实例对象
dog = Dog()
# 调用实例方法
dog.jiao()
print(dog)

print("-" * 50)

dog1 = Dog()
dog1.jiao()
print(dog1)
