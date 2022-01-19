"""
希尔排序
Created by JohnChow on 220119
"""


def shellSort(arr):
    # 待排序数组长度n
    n = len(arr)
    # 设置初始步长
    gap = n // 2
    # 插入排序
    pre_index = arr[i]

    return arr


def shell_sort(arr):
    n = len(arr)
    # 初始步长
    gap = n // 2
    while gap > 0:
        for i in range(gap, n):
            # 每个步長進行插入排序
            temp = arr[i]
            j = i
            # 插入排序
            while j >= 0 and j - gap >= 0 and arr[j - gap] > temp:
                arr[j] = arr[j - gap]
                j -= gap
            arr[j] = temp
        # 得到新的步長
        gap = gap // 2
    return arr
