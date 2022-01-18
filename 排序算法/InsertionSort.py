"""
插入排序
Created by JohnChow on 220117
"""


def insertionSort(arr):
    # 从头遍历arr
    for i in range(len(arr)):
        # 取当前遍历到的位置前一个位置作为向前遍历的起点
        pre_index = i - 1
        # 取当前位置的数字
        cur_num = arr[i]
        # 当之前位置可取且当前位置数小于之前位置数时
        while pre_index >= 0 and cur_num < arr[pre_index]:
            # 将当前位置用之前位置数填上
            arr[pre_index + 1] = arr[pre_index]
            # 向左遍历一位
            pre_index -= 1
        # 当pre_index已经遍历到头或是当前数字大于pre_index位置的数时
        arr[pre_index + 1] = cur_num
    return arr


if __name__ == '__main__':
    print(insertionSort([1, 3, 5, 2, 4, 6]))

