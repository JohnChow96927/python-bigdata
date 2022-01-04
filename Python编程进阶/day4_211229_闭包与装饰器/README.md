# 1. 函数作为参数传递

```python
def get_num(a, b, fn):# get_cj
    print(id(a), id(b), id(fn))
    # fn 就是 get_sum  sum = get_sum(a, b)
    result = fn(a, b)
    return result


def get_sum(a, b):
    return a + b


def get_cj(a, b):
    return a * b


# 函数本身也是一个引用
# 在 python中 函数中进行传参 其实就是引用的传递
# 函数的传递就意味着 功能的传递
a = 10
b = 20
print(id(a), id(b), id(get_sum))
result = get_num(a, b, get_sum)
print(result)

print("------------")

cj = get_num(10, 20, get_cj)
print(cj)

def show(fn):
    fn()


def demo():
    print("hello world!")


show(demo)

```

# 2. 闭包

- ##### 在**Python**中, **万物皆对象**

- ##### 定义函数的时候就开辟空间加载函数

- ##### 函数的传递就意味着功能的传递

- ##### 闭包的定义: 在函数嵌套的前提下,内部函数使用了外部函数的变量, 并且外部函数返回了内部函数, 这个使用外部函数变量的内部函数称为闭包

- ### **构成闭包的条件:** 

    - ### **在函数嵌套的前提下**

    - ### **内部函数使用外部函数的变量(包括参数)**

    - ### **外部函数返回内部函数**

    ```python
    def outer():
        # 整个outer函数内
        a = 10
    
        def inner():
            # a += 10 a = a + 10 不要这么定义 否则无法确认使用的到底是外部还是内部函数的变量
            return a
    
        return inner
    
    # 1.函数嵌套
    # 2.内部函数使用外部函数变量
    # 3.外部函数返回内部函数
    
    inner = outer()
    a = inner()
    print(id(inner))
    print(a + 10)
    ```

- ##### 闭包的作用: 可以用来保存函数中的变量,不会随着函数调用而销毁

- ##### 函数不加()可当做变量进行传递,加()就是调用了

# 3. 装饰器

- ##### 抓取异常, 将异常写入到文件中(完整异常traceback.format_exc())

- ##### 装饰器符合开发中的**封闭开放**原则(开闭原则), 对修改是封闭的, 对于拓展是开放的

- ##### 装饰器的基础写法:

    ```python
    def 装饰器名(装饰器修饰的函数):
        def 装饰函数(*args, **kwargs):
            装饰功能代码块
            ...装饰器修饰的函数(*args, **kwargs)...
        return 装饰函数
    
    
    @装饰器名
    def 功能函数(参数):
        功能代码块
    ```

- 运行逻辑: 

    - 调用功能函数时, 将功能函数作为参数传入装饰器中
    - 使用装饰器中的闭包增强功能函数的功能后, 装饰器返回闭包

- 带参数的装饰器: 在函数中嵌入装饰器, 增强装饰器的功能

    ```python
    def 带参数的装饰器名(可选参数):
        def 装饰器名(装饰器修饰的函数):
            def 装饰函数(*args, **kwargs):
                装饰功能代码块
                ...装饰器修饰的函数(*args, **kwargs)...
            return 装饰函数
        return 装饰器名
    
    
    @带参数的装饰器名(可选参数)
    def 功能函数(参数):
        功能代码块
    ```

- 使用functools.wraps()保留原功能函数的名称及说明不被装饰函数覆盖

    ```python
    from functools import wraps
    
    
    def 带参数的装饰器名(可选参数):
        def 装饰器名(功能函数):
            @wraps(功能函数)
            def 装饰函数(*args, **kwargs):
                装饰功能代码块
                ...装饰器修饰的函数(*args, **kwargs)...
            return 装饰函数
        return 装饰器名
    
    
    @带参数的装饰器名(可选参数)
    def 功能函数(参数):
        功能代码块
    ```

# 4. log4p日志记录模块

```python
import traceback
from functools import wraps


def log4p(log_file="log_file.log"):
    def log_error(fn):
        @wraps(fn)	# 复制fn的函数名和函数注释文档, 不让其被装饰函数wrapped覆盖
        def wrapped(*args, **kwargs):
            try:
                result = fn(*args, **kwargs)
                return result
            except Exception:
                with open(log_file, "a", encoding="utf-8") as f:
                    f.write(traceback.format_exc())
                    return

        return wrapped

    return log_error

```

