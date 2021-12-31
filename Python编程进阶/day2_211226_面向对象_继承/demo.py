class demo9():
    pass

class demo1(demo9):
    pass

class demo3(demo1):
    pass

class demo6(demo3):
    pass

class demo4(demo6):
    pass

class demo5(demo4):
    pass

class demo7(demo5):
    pass

class demo2(object):
    pass

class demo8(demo7):
    pass

class demo10(demo8):
    pass


print(demo10.__mro__)
