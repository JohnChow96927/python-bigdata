"""
堆排序
Created by JohnChow on 220121
"""


def buildMaxHeap(arr):
    import math
    for i in range(math.floor(len(arr) / 2), -1, -1):
        heapify(arr, i)


def heapify(arr, i):
    left_index = 2 * i + 1  # 左子节点性质
    right_index = 2 * i + 2  # 右子节点性质
    largest_index = i
    if left_index < arrLen and arr[left_index] > arr[largest_index]:  # 若左子节点大于当前记录最大节点值
        largest_index = left_index  # 标记位置
    if right_index < arrLen and arr[right_index] > arr[largest_index]:  # 若右子节点大于当前记录最大节点值
        largest_index = right_index  # 标记

    if largest_index != i:  # 若最大值发生变化
        arr[i], arr[largest_index] = arr[largest_index], arr[i]  # 将最大值与当前位置节点交换位置
        heapify(arr, largest_index)  # 递归


def heapSort(arr):
    global arrLen
    arrLen = len(arr)  # 取堆中元素总数
    buildMaxHeap(arr)  # 建大顶堆
    for i in range(len(arr) - 1, 0, -1):
        arr[0], arr[i] = arr[i], arr[0]  # 将堆尾与堆首元素(最大值)交换
        arrLen -= 1  # 将当前最大值排除(更新arr)
        heapify(arr, 0)  # 将剩下的元素重新建大顶堆
    return arr


if __name__ == '__main__':
    print(heapSort([5, 1, 3, 5, 2, 4, 6]))
