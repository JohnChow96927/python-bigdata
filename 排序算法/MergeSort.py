"""
归并排序
220405
"""


def merge(left_part, right_part):
    result = []
    while left_part and right_part:
        if left_part[0] <= right_part[0]:
            result.append(left_part.pop(0))
        else:
            result.append(right_part.pop(0))
    while left_part:
        result.append(left_part.pop(0))
    while right_part:
        result.append(right_part.pop(0))
    return result


def mergeSort(arr):
    import math
    if len(arr) < 2:
        return arr
    middle = math.floor(len(arr) / 2)
    left_part, right_part = arr[0:middle], arr[middle:]
    return merge(mergeSort(left_part), mergeSort(right_part))


if __name__ == '__main__':
    arr = [98, 7, 6, 5, 4, 3, 2, 1, 9]
    print(mergeSort(arr))
