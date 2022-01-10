1. 以下程序输出为:

    ```python
    info = {'name':'班长', 'id':100, 'sex':'f', 'address':'北京'}
    age = info.get('age')
    print(age)
    age=info.get('age',18)
    print(age)
    ```

    正确答案: None 18

    错误解析: 

    ```python
    # get方法语法:
    dict.get(key, default = None)
    # 如果指定的键不存在则返回default指定的默认值, 第4行get中传入第二个参数指定默认值为18, 则返回18
    ```

2. 执行以下程序, 输出结果为:

    ```python
    a = [['1','2'] for i in range(2)]
    
    b = [['1','2']] * 2
    
    a[0][1] = '3'
    
    b[0][0] = '4'
    
    print(a,b) 
    ```

    正确答案: [['1', '3'], ['1', '2']] [['4', '2'], ['4', '2']]

    错误解析:

    ```python
    a = [['1','2'] for i in range(2)]	# 深复制
    
    b = [['1','2']] * 2	# id(b[0]) == id(b[1]), 嵌套列表乘法得到的每个项都是引用
    ```

3. 对于以下代码, 描述正确的是:

    ```python
    list = ['1', '2', '3', '4', '5']
    print list[10:]
    ```

    正确答案: 输出[]

    错误解析:

    切片不受内建类型的限制

4. 执行以下程序, 输出结果为

    ```python
    def outer(fn):
        print('outer')
        def inner():
            print('inner')
            return fn
        return inner
    
    
    @outer
    def fun():
        print('fun')
    ```

    正确答案: outer

    错误解析: 装饰器会在被装饰的函数定义之后立即执行

5. Mysql中表student_table(id,name,birth,sex)，插入如下记录：

    ```mysql
    ('1003' , '' , '2000-01-01' , '男');
    ('1004' , '张三' , '2000-08-06' , '男');
    ('1005' , NULL , '2001-12-01' , '女');
    ('1006' , '张三' , '2000-08-06' , '女');
    ('1007' , ‘王五’ , '2001-12-01' , '男');
    ('1008' , '李四' , NULL, '女');
    ('1009' , '李四' , NULL, '男');
    ('1010' , '李四' , '2001-12-01', '女');
    ```

    执行

    ```mysql
    select t1.*,t2.*
    from (
    select * from student_table where sex = '男' ) t1 
    inner  join 
    (select * from student_table where sex = '女')t2 
    on t1.birth = t2.birth and t1.name = t2.name ; 
    ```

    的结果行数是:

    正确答案: 1

    错误解析: 在SQL中, NULL与任何值比较永不为真

6. ![image-20220110202553228](image-20220110202553228.png)

    解析: fromkeys(seq=a, value=b)方法以a中元素做字典的键, b做所有键对应的初始值

7. ![image-20220110202850342](image-20220110202850342.png)

    错误解析: upper()方法先将strs中所有字符转为大写'ABCD12EFG', 然后title()方法再将strs中每个单词首字母转为大写, 其余字母转为小写, 得'Abcd12Efg'

8. ![image-20220110203101902](image-20220110203101902.png)

    错误解析: python中主要存在4中命名方式

     1. object: 公用方法

     2. _object: 半保护

        被看作是“protect”，只有类对象和子类对象自己能访问到这些变量, 在模块或类外不可以使用，不能用’from module import *’导入。

        \#_\_object 是为了避免与子类的方法名称冲突， 对于该标识符描述的方法，父类的方法不能轻易地被子类的方法覆盖，他们的名字实际上是\_classname\_\_methodname。

     3. __object: 全私有, 全保护, 只有类对象自己能访问, 子类对象也不能访问, 需要用类方法获取和修改

     4. `__object__`: 内建方法, 用户不要这样定义