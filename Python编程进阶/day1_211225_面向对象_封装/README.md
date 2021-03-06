# 0. 课程大纲

##### Day1-day3：面向对象

##### Day4：闭包，装饰器

##### Day5：前端基础

##### Day6：网络编程

##### Day7：http协议、web服务器

##### Day8：线程，进程

##### Day9：正则表达式

##### Day10：爬虫

##### 后续(内容+天数)：MySQL6、pandas7、linux2、==hadoop==10、离线项目7、pyspark6、项目7、JavaSE10、nosql（redis、kafka……）8、flink6、项目7

# 1. 面向对象初体验

- ##### 洗衣服：面向过程与面向对象

- ##### 根据职责在一个对象中封装多个方法

- ##### 如何实现：

  1. 首先确定职责
  2. 根据职责确定不同对象，在对象内部封装不同方法
  3. 不同对象调用不同方法

- ##### 更加适合应对复杂的需求变化，固定套路：创建对象，调用函数

- #### 封装、继承、多态

- ##### 类（抽象） ：

  - 类名
  - 属性：变量
  - 行为：函数

- ##### 类与对象的关系：类是对事物共同特点的抽象；对象是根据类创建对象，对象才是最终要使用的具体的存在；类与对象是一对多的关系

  ```python
  class Washer(object):
      def wash(cls):
          pass
  washer = Washer()
  washer.wash()
  ```

- ##### cls：每创建一个对象都会开辟一个新的空间，哪个对象调用就是哪个对象的地址值

    - 作用：区分不同对象的空间。类中函数只有一个，self带的不同对象的地址，可以作为参数进行传递到类的函数中

# 2. 添加与获取对象的属性

- 添加对象属性：

    - 对象.属性名 = 属性值(不存在属性则新增)

- 获取对象属性：

    - 对象.属性名

    ```python
    # 需求:
    # 有一个学生 名字叫:茂茂 年龄28 爱好:喝酒 跳伞 抡大锤
    # 方法其实就是咱们前面学习的函数 只是叫法不一样
    class Student(object):
        def drink(cls):
            print("李十瓶...")
    
        def jump(cls):
            print("裸身跳伞...")
    
    
    # 创建对象
    stu = Student()
    
    stu.drink()
    stu.jump()
    
    # 添加属性
    stu.name = "茂茂"
    stu.age = 28
    
    # 获取属性
    print(stu.name, stu.age)
    ```

# 3. 魔法方法之init

- `__xx__()`函数叫做魔法方法，指的是具有特殊功能的函数

- init()方法：初始化对象方法，创建对象时就会执行，可以利用执行实际来初始化一些属性

    ```python
    class Student(object):
        # 魔法方法
        def __init__(cls, name, age):
            # 将局部的变量 变成属性
            # 对象.属性名 = 值
            # print(name, age)
            cls.name = name
            cls.age = age
            # print("__init__执行了....")
    
        def study(cls):
            print("学生爱学习...")
    
    
    # __init__ 当创建对象的时候执行__init__函数
    # 作用用来初始化: 应该有什么我就给你创建出来 应该有什么值 我就给你赋什么值 最终产生一个对象
    # 利用执行时机 帮咱们初始化一些属性
    stu = Student("张三", 28)
    
    print(stu.name, stu.age)
    
    stu2 = Student("欣欣", 18)
    print(stu2.name, stu2.age)
    ```

# 4. 魔法方法之str

- `__str__()`：直接输出对象时，此函数return什么就打印什么

    ```python
    class Student(object):
        # 魔法方法
        def __init__(cls, name, age):
            # 将局部的变量 变成属性
            # 对象.属性名 = 值
            # print(name, age)
            cls.name = name
            cls.age = age
            # print("__init__执行了....")
    
        def study(cls):
            print("学生爱学习...")
    
        def __str__(cls):
            return f"name:{cls.name}\nage:{cls.age}"
    
    
    # 注意__str__函数作用.当我们直接打印输出对象的时候 默认打印的是地址值
    # __str__函数中 return 什么 就打印什么
    stu = Student("张三", 28)
    print(stu)
    ```

# 5. 魔法方法之del

- `__del__()`：当对象被删除时执行，不使用del方法则在程序结束时执行，否则在使用del删除对象时执行

- GC（垃圾回收器）：Python中引用计数器为主，标记清除与隔代回收为辅

    ```python
    class Student(object):
        # 魔法方法
        def __init__(cls, name="张三", age=18):
            # 将局部的变量 变成属性
            # 对象.属性名 = 值
            # print(name, age)
            cls.name = name
            cls.age = age
            # print("__init__执行了....")
    
        def study(cls):
            print("学生爱学习...")
    
        def __del__(cls):
            # 释放资源
            print("对象被释放了...")
    
    
    stu = Student()
    del stu
    print("-" * 50)
    
    ```

# 6. 综合案例烤地瓜加调料

```python
class SweetPotato(object):
    # 定义属性
    def __init__(cls, timed=0, condition='生的', flavours=[]):
        cls.timed = timed
        cls.condition = condition
        cls.flavours = flavours

    def __str__(cls):
        return f"当前地瓜烤了{cls.timed}分钟，当前状态为{cls.condition}，添加的调料为{cls.flavours}"

    # 行为
    def bake_sweet_potato(cls, timed):
        """
        烤地瓜行为函数
        """
        if timed < 0:
            print("您给定的时间有误！")
            return
        # 将烤地瓜的时间进行累加
        cls.timed += timed
        if 3 > cls.timed >= 0:
            cls.condition = "生的"
        elif 3 <= cls.timed < 5:
            cls.condition = "半生不熟的"
        elif 5 <= cls.timed < 8:
            cls.condition = "熟了"
        elif cls.timed >= 8:
            cls.condition = "糊了"

    def add_flavour(cls, flavour):
        """
        添加调料行为函数
        :param flavour: 调料， str
        """
        cls.flavours.append(flavour)


sp = SweetPotato()
sp.add_flavour("油")
sp.bake_sweet_potato(2)
print(sp)
sp.add_flavour("盐")
sp.bake_sweet_potato(3)
print(sp)
sp.add_flavour("孜然")
sp.bake_sweet_potato(1)
print(sp)
sp.add_flavour("辣椒")
sp.bake_sweet_potato(1)
print(sp)
```