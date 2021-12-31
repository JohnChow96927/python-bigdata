from cleaning_tools import *


# 面向过程
def add_water():
    print("添加水...")


def add_detergent():
    print("添加洗衣液...")


def wash_clothes():
    print("用手洗衣服....")


def wash_clean_clothes():
    print("衣服洗干净....")


def spin_dry_clothes():
    print("拧干衣服...")


add_water()
add_detergent()
wash_clothes()
wash_clean_clothes()
spin_dry_clothes()
spin_dry_clothes()
print("=" * 30)

# 面向对象
# 创建洗衣机对象
washer = Washer("海尔")
# 创建衣服对象
clothes = Clothes("鸿星尔克", "脏衣服")
# 使用洗衣机洗衣服
washer.wash(clothes)
