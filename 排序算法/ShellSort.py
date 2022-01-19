"""
希尔排序
Created by JohnChow on 220119
"""


def shellSort(arr):
    # 待排序数组长度n
    n = len(arr)
    # 设置初始步长, //为除法向下取整
    gap = n // 2
    while gap >= 1:
        for i in range(gap, n):
            # 对每个步长的一组数进行插入排序
            temp = arr[i]
            j = i
            # 插入排序, 当j和j-gap可取且前面的数大于后面的数时
            while j >= 0 and j - gap >= 0 and arr[j - gap] > temp:
                # 将前面的数与j位置的数交换
                arr[j] = arr[j - gap]
                # j向前移gap位
                j -= gap
            # 当前面的数(arr[j-gap])大于等于后面的数(temp)时, 将arr[j]置为temp
            arr[j] = temp
        # 更新步长
        gap = gap // 2
    return arr



print(shellSort([1, 3, 5, 2, 4, 6]))
