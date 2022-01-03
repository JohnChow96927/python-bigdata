# 1. 复习

- ##### 继承

- ##### 优缺点

- ##### 单继承

- ##### 多继承(了解)

- ##### 多层继承

- ##### super(): 在子类中访问父类方法, 属性

- ##### 重写: 增强, 改变父类某个方法的功能

- ##### 私有权限: __name增加属性安全性

# 2. 面向对象三大特性

- ##### 封装: 将属性和方法书写到类里称为封装, 可以为属性和方法添加私有权限

- ##### 继承: 子类默认继承父类的所有属性和方法, 可以重写

- ##### 多态: 传参传入不同对象, 产生不同效果

# 3. 多态

- ##### 调用灵活, 使代码更通用, 适应需求的不断变化

    ```python
    class ChinaPay(object):
        def pay(self):
            print("检测....")
            print("支付....")
    
    class AliPay(ChinaPay):
        def pay(self):
            print("扫二维码...")
            super(AliPay, self).pay()
            print("支付成功...")
    
    
    class WXPay(ChinaPay):
        def pay(self):
            print("微信支付功能....")
            super().pay()
            print("微信支付成功....")
    
    
    class JXPay(ChinaPay):
        def jxlPay(self):
            print("使用我的进行支付")
    
    
    # 商家提供二维码
    def shop_pay(pay):
        pay.pay()
    
    alipay = AliPay()
    shop_pay(alipay)
    
    wxpay = WXPay()
    shop_pay(wxpay)
    #
    jxpay = JXPay()
    shop_pay(jxpay)
    ```

# 4. 类属性和实例属性

- ##### 类属性: 被该类所有实例对象所共有

    - 记录的某项数据始终保持一致时可以定义类属性
    - 节省内存空间
    - 既可以使用 类名.类属性 调用, 也可以使用 对象.类属性 调用
    - **但是, 使用对象.类属性只能是调用, 不能是=, =是新建和类属性同名的对象属性**
    - 类属性只能通过`类.属性名 = 属性值`进行修改
    - 访问顺序: 优先找自己空间中, 之后再往更大的空间找

- ##### 使用实例属性设置默认值,每创建一个对象,开辟一次空间,使用类属性只开辟一次空间, 节省内存

    ```python
    # 学生管理系统
    class Student(object):
        school = "传智专修学院"
    
        def __init__(self, name, age):
            self.name = name
            self.age = age
    
        def eat(self):
            print("吃...")
    
        def __str__(self):
            return f"name:{self.name},age:{self.age},school:{self.school}"
    
    
    stu1 = Student("小王", 18)
    stu2 = Student("大王", 19)
    stu3 = Student("小郭", 20)
    # stu1.school = "黑马程序员"
    # 类属性 即可以使用 类名.类属性 也可以使用对象.类属性
    print(stu1.name, stu1.age, stu1.school, Student.school)
    print(stu2.name, stu2.age, stu2.school, Student.school)
    print(stu3.name, stu3.age, stu3.school, Student.school)
    # 这种方式定义实例属性
    # stu1.school = "黑马程序员"
    Student.school = "黑马程序员"
    print(stu1)
    print(stu2)
    print(stu3)
    ```

# 5. 类方法

- ##### 使用装饰器@classmethod修饰方法

- ##### 访问类中属性

    ```python
    class Student(object):
        # 私有化的类属性 特点:只能在本类中进行访问
        __school = "传智专修学院"
    
        @classmethod
        def set_school(cls,school):
            cls.__school = school
    
        @classmethod
        def get_school(cls):
            return cls.__school
    
    # 直接对属性进行修改 不安全
    # 修改属性 最好是通过方法进行修改
    # Student.school = "黑马程序员"
    # print(Student.school)
    # 操作类属性 类方法 最好的方式  使用类名进行操作
    # stu = Student()
    # stu.set_school("黑马程序员")
    # print(stu.get_school())
    Student.set_school("黑马程序员")
    print(Student.get_school())
    ```

    

# 6. 静态方法

- ##### 使用装饰器@staticmethod修饰

- ##### 既不需要传递类对象也不要传递实例对象(无self/ cls)

- 可以新建utils.py工具模块写各种工具类, 其中使用静态方法创建类方法

    ```python
    class ListUtils(object):
    
        @staticmethod
        def get_max(my_list):
            _max = my_list[0]
            for i in range(1, len(my_list)):
                if _max < my_list[i]:
                    _max = my_list[i]
            return _max
    
        @staticmethod
        def get_min(my_list):
            _min = my_list[0]
            for i in range(1, len(my_list)):
                if _min > my_list[i]:
                    _min = my_list[i]
            return _min
    
    
    class DictUtils(object):
        @staticmethod
        def get_max(my_list):
            _max = my_list[0]
            for i in range(1, len(my_list)):
                if _max < my_list[i]:
                    _max = my_list[i]
            return _max
    
        pass
    
    class StrUtils(object):
        pass
    ```

    ```python
    from utils import ListUtils
    
    
    my_list = [12, 50, 55, 34, 48]
    print(ListUtils.get_max(my_list))
    print(ListUtils.get_min(my_list))
    ```