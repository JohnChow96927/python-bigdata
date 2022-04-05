"""
冒泡排序
220405
"""


def bubbleSort(nums):
    for i in range(1, len(nums)):
        for j in range(0, len(nums) - i):
            if nums[j] > nums[j + 1]:
                nums[j + 1], nums[j] = nums[j], nums[j + 1]
    return nums


def bubbleSort_back(nums):
    for i in range(len(nums) - 1, 1, -1):
        for j in range(i - 1, -1, -1):
            if nums[j + 1] < nums[j]:
                nums[j + 1], nums[j] = nums[j], nums[j + 1]
    return nums


if __name__ == '__main__':
    nums = [9, 8, 7, 6, 5, 4, 3, 2, 1]
    print(bubbleSort(nums))
    print(bubbleSort_back(nums))
