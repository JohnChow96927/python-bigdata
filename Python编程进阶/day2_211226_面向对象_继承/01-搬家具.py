class House(object):
    def __init__(self, area):
        """
        初始化函数，初始化房屋面积
        :param area: 房屋面积
        """
        self.area = area

    def move_furniture(self, furniture):
        """
        搬家具方法函数
        :param furniture: 家具类参数
        :return: None
        """
        if self.area >= furniture.area:
            # 对房子面积进行累减
            self.area -= furniture.area
            print("放下了")
        else:
            print("放不下")


class Furniture(object):
    def __init__(self, area):
        """
        初始化家具类
        :param area: 家具面积属性
        :return: None
        """
        self.area = area


house = House(10000)  # 创建一个area为100的房子对象house
f1 = Furniture(5000)  # 创建一个area为20的家居对象f1
house.move_furniture(f1)    # 使用move_furniture(f1)将f1搬入house
