# 十大排序算法修炼

## I. 插入排序

> ##### 插入排序是一种最简单直观的排序算法, 它的工作原理是通过构建有序序列, 对于未排序数据, 在已排序序列中从后向前扫描, 找到相应位置并插入.

1. ### 算法步骤:

    将待排序序列第一个元素看做是一个有序序列, 把第二个元素到最后一个元素当成是未排序序列. 从头到尾依次扫描未排序序列, 将扫描到的每个元素插入有序序列的适当位置. 

    如果待插入的元素与有序序列中的某个元素相等, 则将插入元素插入到相等元素的后面.

    形象地理解就是打牌理牌的过程.

    ![img](imgs/insertionSort.gif)

2. ### 代码实现:

    ```python
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
    ```


## II. 希尔排序

> ##### 希尔排序也称为递减增量排序算法, 是插入排序的一种更高效的改进版本.
>
> ##### 先将整个待排序的记录序列分割成为若干子序列分别进行直接插入排序, 待整个序列中的记录基本有序时, 再对全体记录进行依次直接插入排序.

1. ### 算法步骤:

    ![1024555-20161128110416068-1421707828](imgs/1024555-20161128110416068-1421707828-2581271.png)

    ![shellsort](imgs/shellsort.gif)

2. ### 代码实现:

    ```python
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
    ```


# III. 简单选择排序

> ##### 简单选择排序是一种简单直接的排序算法, 无论什么数据进去都是O(n^2)的时间复杂度. 使用它的时候数据规模越小越好, 唯一的好处是不占用额外的内存空间

1. 算法步骤

    首先在未排序的序列中找到最小(大)元素, 存放到排序序列的起始位置.

    再从剩余未排序元素中继续寻找最小(大)元素, 然后放到已排序序列的末尾.

    重复第二步, 直到所有元素均排序完毕

    ![img](imgs/selectionSort.gif)

2. 代码实现

    ```python
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
    ```

    