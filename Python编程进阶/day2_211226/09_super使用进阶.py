"""
继承
    单继承:一个子类继承一个父类
    多继承:一个子类继承多个父类
    多层继承:一个子类继承一个父类,父类又继承爷爷类...
重写
    子类中出现了与父类中一模一样的方法 属性
super
    可以在子类中调用父类的方法 属性
    使用:super(子类,self).方法() 调用的具体是谁的方法 取决于给的子类, 调用的是给定的子类的父类方法
        super().方法() 调用的是当前子类的父类的方法
    调用的父类中没有这个方法继续往上找 知道找到 如果找不到 就报错

"""


class A(object):
    def show(self):
        print("A中的方法")


class B(object):
    def show(self):
        print("B中的方法")


class C(B, A):
    def show(self):
        # 调用父类的Show方法
        # 要调用谁的方法 就得写谁的子类
        print("C中的show方法")


# super(B, self).show() 要调用谁的方法 就得写谁的子类
# 遵循  __mro__  继承关系
# (<class '__main__.C'>, <class '__main__.B'>, <class '__main__.A'>, <class 'object'>)
c = C()
c.show()
print(C.__mro__)
