import copy

a = [[1, 2, 3], [4, 5, 6]]
b = a
c = copy.copy(a)
d = copy.deepcopy(a)

a.append(7)
a[1][2] = 0

'''
a : [[1, 2, 3], [4, 5, 0], 7]
b : [[1, 2, 3], [4, 5, 0], 7]
c : [[1, 2, 3], [4, 5, 0]]
d : [[1, 2, 3], [4, 5, 6]]
'''
print('原列表: ', a)
print('引用赋值: ', b)
print('浅拷贝: ', c)
print('深拷贝: ', d)
