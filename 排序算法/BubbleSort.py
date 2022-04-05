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


if __name__ == '__main__':
    nums = [2, 3, 1, 5, 6, 4, 3, 7, 5, 9, 10, 7]
    print(bubbleSort(nums))
