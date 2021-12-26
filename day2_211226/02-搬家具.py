class House(object):
    def __init__(self, location, area, furniture_list=[]):
        self.location = location
        self.area = area
        self.area_remained = area
        self.furniture_list = furniture_list

        pass

    def __str__(self):
        return f"我在{self.location}的房子，总面积为{self.area}平方米，里面放下了{'、'.join([fur.name for fur in self.furniture_list])}这些家具"

    def move_furniture(self, furniture):
        if self.area_remained >= furniture.area:
            self.area_remained -= furniture.area
            self.furniture_list.append(furniture)
            print(f"{furniture.name}放入了房子中，房子还剩{self.area_remained}平方米")
        else:
            print(f"家具放不下了，房子剩余面积为{self.area_remained}，家具占地面积为{furniture.area}")


class Furniture(object):
    def __init__(self, name, area):
        self.name = name
        self.area = area


house = House("陆家嘴", 1000)
f1 = Furniture("巨型床", 200)
house.move_furniture(f1)
f2 = Furniture("鞋柜", 900)
house.move_furniture(f2)
print(house)
