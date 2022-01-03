# 1. 继承

- 当多个类之间产生了代码重复的时候，可将这些重复的代码抽取到一个类中，并让其他类与这个类产生一个关系，让其他类拥有了这个类中的属性与方法，这个关系称为继承
- 继承的好处：提高了代码复用性，提高代码的可维护性
- 父类（基类）（超类）- 子类(派生类)
- 继承的缺点：提高了耦合度，牵一发而动全身
- 编程原则之一：高内聚低耦合

# 2. 单继承和多继承

- 尽量使用单继承，避免出现多继承

- 单继承：一个子类只有一个父类

    ```python
    class Animal(object):
        def __init__(cls, name, age):
            cls.name = name
            cls.age = age
    
        def eat(cls):
            print(f"{cls.name}吃饭")
    
    
    class Dog(Animal):
        def look_house(cls):
            print(f"{cls.name}看家")
    
    
    class Cat(Animal):
        def catch_mouse(cls):
            print(f"{cls.name}抓老鼠")
    
    
    cat = Cat("小花", 3)
    dog = Dog("旺财", 5)
    cat.eat()
    cat.catch_mouse()
    dog.eat()
    dog.look_house()
    ```

- 多继承：多继承本质上是多层单继承

    ```python
    class Horse(object):
        def __init__(cls, name, age):
            cls.name = name
            cls.age = age
    
        def eat(cls):
            print("马吃草")
    
    
    class Donkey(object):
        def __init__(cls, name, age):
            cls.name = name
            cls.age = age
    
        def eat(cls):
            print("驴吃草")
    
    
    class mule(Horse, Donkey):
        pass
    ```

- `类.__mro__`返回继承顺序链

# 3. 重写

- 子类可以重写父类中的方法

    ```python
    # 重写 子类中出现了父类中一摸一样的方法
    class Animal(object):
        def __init__(cls, name, age):
            cls.name = name
            cls.age = age
    
        def eat(cls):
            print("吃饭...")
    
    
    class Dog(Animal):
    
        # 特有的功能
        def look_house(cls):
            print("狗看家....")
        # 重写父类的方法
        def eat(cls):
            print("狗吃骨头...")
    
    
    class Cat(Animal):
    
        # 特有的功能
        def catch_mouse(cls):
            print("猫抓老鼠....")
    
    
    cat = Cat("小花", 8)
    cat.eat()
    cat.catch_mouse()
    
    dog = Dog("旺财", 10)
    dog.eat()
    dog.look_house()
    ```

# 4. super()

- 可以直接使用`父类类名.方法(cls)`调用父类方法

- 也可以使用`super(子类，cls).父类方法`调用父类方法，这样可以指定子类的父类方法进行调用

- 也可以使用`super().父类方法`，这样只能调用当前这个子类的父类方法

    ```python
    class Animal(object):
        def __init__(cls, name, age):
            cls.name = name
            cls.age = age
    
        def eat(cls):
            print("吃饭...")
    
    
    class Dog(Animal):
    
        # 特有的功能
        def look_house(cls):
            print("狗看家....")
    
        def eat(cls):
            print("准备骨头...")
            # 类名.方法(cls) 可以调用任何类中的方法
            # super(Dog)
            # Animal.eat(cls)
            # 第二种格式
            # super(子类,cls).eat() 调用的是谁的方法:给定的这个子类对应的父类的方法
            # super(Dog,cls).eat()
            # 第二种格式的简写形式 super().父类的方法() 只能调用当前这个类的父类方法
            super().eat()
            print("打扫卫生")
    
    
    class Cat(Animal):
    
        # 特有的功能
        def catch_mouse(cls):
            print("猫抓老鼠....")
    
    
    dog = Dog("旺财", 10)
    dog.eat()
    dog.look_house()
    
    cat = Cat("小花", 8)
    cat.eat()
    cat.catch_mouse()
    ```

- 使用进阶：

    ```python
    """
    继承
        单继承:一个子类继承一个父类
        多继承:一个子类继承多个父类
        多层继承:一个子类继承一个父类,父类又继承爷爷类...
    重写
        子类中出现了与父类中一模一样的方法 属性
    super
        可以在子类中调用父类的方法 属性
        使用:super(子类,cls).方法() 调用的具体是谁的方法 取决于给的子类, 调用的是给定的子类的父类方法
            super().方法() 调用的是当前子类的父类的方法
        调用的父类中没有这个方法继续往上找 知道找到 如果找不到 就报错
    
    """
    
    
    class A(object):
        def show(cls):
            print("A中的方法")
    
    
    class B(object):
        def show(cls):
            print("B中的方法")
    
    
    class C(B, A):
        def show(cls):
            # 调用父类的Show方法
            # 要调用谁的方法 就得写谁的子类
            print("C中的show方法")
    
    
    # super(B, cls).show() 要调用谁的方法 就得写谁的子类
    # 遵循  __mro__  继承关系
    # (<class '__main__.C'>, <class '__main__.B'>, <class '__main__.A'>, <class 'object'>)
    c = C()
    c.show()
    print(C.__mro__)
    ```

# 5. 多层继承

- ```python
    class Person(object):
        def __init__(cls, name, age):
            cls.name = name
            cls.age = age
    
        def eat(cls):
            print("吃饭...")
    
        def speak(cls):
            print("讲国语...")
    
    
    class Player(Person):
    
        def study(cls):
            print("学习...")
    
    
    class Coach(Person):
    
        def teach(cls):
            print("教练教学...")
    
    
    class PingPangPlayer(Player):
    
        def study(cls):
            print("学习打乒乓球...")
    
        def speak(cls):
            # 找父类 父类中没有 再找父类的父类... 直到找到就调用, 找不到就报错...
            super().speak()
            print("讲英语...")
    
    
    class PingPangCoach(Coach):
    
        def teach(cls):
            print("教运动员打乒乓球...")
    
        def speak(cls):
            super().speak()
            print("将英语...")
    
    
    class BasketballPlayer(Player):
    
        def study(cls):
            print("学习打篮球...")
    
        def speak(cls):
            super().speak()
            print("将德语...")
    
    
    class BasketballCoach(Coach):
    
        def teach(cls):
            print("教运动员打篮球...")
    
        def speak(cls):
            super().speak()
            print("将德语...")
    
    
    class FootballPlayer(Player):
    
        def study(cls):
            print("学习踢足球...")
    
    
    class FootballCoach(Coach):
    
        def teach(cls):
            print("教运动员踢足球...")
    
    
    ppp = PingPangPlayer("马龙",30)
    ppp.eat()
    ppp.study()
    ppp.speak()
    ```

# 6. 私有权限

- 只能在本类中进行访问

- 语法：在属性或方法前加上两个`_`

    ```python
    class Student(object):
        def __init__(cls, name, age):
            cls.__name = name
            cls.__age = age
    
        def set_age(cls, age):
            if age < 0:
                print("您给定的年龄不合法!")
                return
            cls.__age = age
    
        def get_age(cls):
            return cls.__age
    
        def set_name(cls, name):
            cls.__name = name
    
        def get_name(cls):
            return cls.__name
    
        def __str__(cls):
            return f"name:{cls.__name},age:{cls.__age}"
    
    
    # 私有:只能在本类中进行访问
    # 语法 在属性,方法 加上 两个 _
    # __name  __age __show()
    stu = Student("张三", 20)
    # 私有的属性与方法不能够被子类直接继承
    # print(Student.__age)
    # print(stu.__age)
    # 属性也是变量
    # 如何修改 __age的值??
    stu.set_age(21)
    # 如何获取属性值
    age = stu.get_age()
    print(age)
    
    print(stu)
    ```

- 修改私有属性值：类中定义函数修改，一般使用`get_属性名（）、set_属性名()`命名

- 私有属性和方法，子类无法直接继承

- 子类可以通过父类中公共函数间接继承父类中的私有属性、方法

- 子类初始化方法中可以使用`super().__init__()`对父类的私有属性进行初始化

    ```python
    # 子类如何初始化父类中的属性
    # 私有的属性 私有方法 都不能被子类直接继承
    class Animal(object):
        def __init__(cls, name, age):
            cls.__name = name
            cls.__age = age
    
        def __show(cls):
            print("私有方法 show")
    
        def set_age(cls, age):
            cls.__age = age
    
        def get_age(cls):
            return cls.__age
    
        def set_name(cls, name):
            cls.__name = name
    
        def get_name(cls):
            return cls.__name
    
        def eat(cls):
            print("吃饭.....")
    
    
    class Dog(Animal):
        def __init__(cls, address, name, age):
            super(Dog, cls).__init__(name, age)
            cls.__address = address
    
        def set_address(cls, address):
            cls.__address = address
    
        def get_address(cls):
            return cls.__address
            pass
    
    
    # 私有的不能够直接被继承 可以通过父类中公共方法访问私有的属性
    dog = Dog("上海", "狗子", 18)
    
    dog.set_address("北京")
    dog.set_name("狗子儿")
    dog.set_age(25)
    
    print(dog.get_name(), dog.get_age(), dog.get_address())
    ```

    