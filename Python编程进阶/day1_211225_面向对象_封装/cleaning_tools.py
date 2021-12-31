__all__ = ["Washer", "Clothes"]


# 定义洗衣机类
class Washer(object):
    def __init__(self, name):
        self.name = name

    # 洗衣方法
    def wash(self, clothes):
        print("添加水...")
        print("添加洗衣液...")
        print(f"正在使用{self.name}牌洗衣机清洗{clothes.get_name()}牌子{clothes.get_dirty()}")
        print("衣服清洗干净...")
        clothes.set_dirty("干净衣服")
        print("甩干衣服...")
        return clothes


# 定义衣服类
class Clothes(object):
    def __init__(self, name, dirty):
        self.__name = name
        self.__dirty = dirty

    def set_dirty(self, dirty):
        self.__dirty = dirty

    def get_dirty(self):
        return self.__dirty

    def set_name(self, name):
        self.__name = name

    def get_name(self):
        return self.__name

    def __str__(self):
        return f"这是一件{self.__name}牌子的{self.__dirty}"
