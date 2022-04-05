"""
选择排序
Created by JohnChow on 220120
"""


def selectionSort(arr):
    # 从头遍历待排序序列
    for i in range(len(arr) - 1):
        # 设当前i为最小值索引
        min_index = i
        # 从i后一位开始遍历
        for j in range(i + 1, len(arr)):
            # 若遍历到的数比最小值索引位置值小则设遍历到的索引为最小值索引
            if arr[j] < arr[min_index]:
                min_index = j
        # 循环结束若最小值索引发生改变
        if min_index != i:
            # 交换arr[min_index]和arr[i]
            arr[min_index], arr[i] = arr[i], arr[min_index]
    # 返回排序后序列
    return arr


if __name__ == '__main__':
    print(selectionSort([1, 3, 5, 2, 4, 6]))
