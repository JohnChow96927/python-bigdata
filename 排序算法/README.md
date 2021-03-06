# 十大排序算法修炼

**排序算法可以分为内部排序和外部排序，内部排序是数据记录在内存中进行排序，而外部排序是因排序的数据很大，一次不能容纳全部阿德排序记录，在排序过程中需要访问外存。**

**常见的内部排序算法有：插入排序、希尔排序、选择排序、堆排序、冒泡排序、快速排序、归并排序、基数排序、计数排序、桶排序。**

![img](assets/sort.png)

In-place：占用常数内存，不占用额外内存

Out-place：占用额外内存

n：数据规模

k：“桶”的个数

![img](assets/0B319B38-B70E-4118-B897-74EFA7E368F9.png)

> **稳定性**：排序后2个相等键值的顺序和排序之前它们的顺序相同则为稳定的排序算法

稳定排序算法：冒泡排序、插入排序、归并排序和基数排序

不稳定排序算法：选择排序、快速排序、希尔排序和堆排序

## I. 插入排序

> ##### 插入排序是一种最简单直观的排序算法, 它的工作原理是通过构建有序序列, 对于未排序数据, 在已排序序列中从后向前扫描, 找到相应位置并插入.

### 算法步骤

将待排序序列第一个元素看做是一个有序序列, 把第二个元素到最后一个元素当成是未排序序列. 从头到尾依次扫描未排序序列, 将扫描到的每个元素插入有序序列的适当位置. 

如果待插入的元素与有序序列中的某个元素相等, 则将插入元素插入到相等元素的后面.

形象地理解就是打牌理牌的过程.

![img](imgs/insertionSort.gif)

### 代码实现

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

### 算法步骤

![1024555-20161128110416068-1421707828](imgs/1024555-20161128110416068-1421707828-2581271.png)

![shellsort](imgs/shellsort.gif)

### 代码实现

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


## III. 简单选择排序

> ##### 简单选择排序是一种简单直接的排序算法, 无论什么数据进去都是O(n^2)的时间复杂度. 使用它的时候数据规模越小越好, 唯一的好处是不占用额外的内存空间

### 算法步骤

首先在未排序的序列中找到最小(大)元素, 存放到排序序列的起始位置.

再从剩余未排序元素中继续寻找最小(大)元素, 然后放到已排序序列的末尾.

重复第二步, 直到所有元素均排序完毕

![img](imgs/selectionSort.gif)

### 代码实现

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

## IV. 堆排序

> ##### 堆排序是指利用堆这种数据结构所设计的一种排序算法. 堆积是一个近似完全二叉树的结构, 并同时满足堆积的性质: 即子节点的键值或索引总是小于(或者大于)它的父节点. 堆排序可以说是一种利用堆的概念来排序的选择排序.
>
> 大顶堆: 每个节点的值都大于或等于其子节点的值, 在堆排序算法中用于升序排列
>
> 小顶堆: 每个节点的值都小于或等于其子节点的值, 在堆排序算法中用于降序排列

### 算法步骤

1. 创建一个堆H[0, 1, 2, …, n - 1];
2. 把堆首(最大值)和堆位互换;
3. 把堆的尺寸缩小1, 并调用shift_down(0), 目的是把新的数组顶端数据调整到相应位置;
4. 重复步骤2, 直到堆的尺寸为1.

![img](imgs/Sorting_heapsort_anim.gif)

### 代码实现

```python

```

## V. 冒泡排序

> **冒泡排序也是一种简单直观的排序算法, 它重复地走访过要排序的数列, 一次比较两个元素, 如果它们的顺序错误就把它们交换过来. 这个算法的名字由来是因为越小的元素会经由交换慢慢"浮"到数列的顶端.**

### 算法步骤

1. 比较相邻的两个元素, 如果第一个比第二个大, 就交换它们两个
2. 对每一对相邻元素作同样的工作, 从开始第一对到结尾的最后一对. 这步做完后, 最后的元素会是最大的数
3. 针对所有的元素重复以上的步骤, 除了最后一个
4. 持续每次对越来越少的元素重复上面的步骤, 直到没有任何一对数字需要比较

![img](assets/bubbleSort.gif)

### 代码实现

```python
def bubbleSort(nums):
    for i in range(1, len(nums)):
        for j in range(0, len(nums) - i):
            if nums[j] > nums[j + 1]:
                nums[j + 1], nums[j] = nums[j], nums[j + 1]
    return nums
```

## VI. 归并排序

> **归并排序是建立在归并操作上的一种有效的排序算法. 该算法是采用分治法的一个非常典型的应用, 作为一种典型的分而治之思想的算法应用, 归并排序的实现有两种方法:**
>
> 1. 自上而下的递归(所有递归的方法都可以用迭代重写, 所以就有了第二种方法)
> 2. 自下而上的迭代
>
> **和选择排序一样, 归并排序的性能不受输入数据的影响, 但表现比选择排序好得多, 因为始终都是O(n log(n))的时间复杂度. 代价是需要额外的内存空间**

### 算法步骤

1. 申请空间, 使其大小为两个已经排序序列之和, 该空间用来存放合并后的序列
2. 设定两个指针, 最初位置分别为两个已经排序序列的起始位置
3. 比较两个指针所指向的元素, 选择相对小的元素放入到合并空间, 并移动指针到下一位置
4. 重复步骤3直到某一指针到达序列尾
5. 将另一序列剩下的所有元素直接复制到合并序列尾

![img](assets/mergeSort.gif)

### 代码实现

```python
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
```

## VII. 快速排序

> 快速排序使用分治法策略来把一个串行(list)分为两个子串行
>
> 本质上来看, 快速排序应该算是在冒泡排序基础上的递归分治法

### 算法步骤

1. 从数列中挑出一个元素, 称为“基准”(pivot)
2. 重新排列数列, 所有元素比基准值小的摆放在基准前面, 所有元素比基准值大的摆在基准的后面(相同的数可以放到任一边). 在这个分区退出之后, 该基准就处于数列的中间位置, 这个称为分区(partition)操作
3. 递归地(recursive)把小于基准值元素的子数列和大于基准值元素的子数列排序

![img](assets/quickSort.gif)

### 代码实现

```python
def partition(arr, left, right):
    pivot = left
    index = pivot + 1
    i = index
    while i <= right:
        if arr[i] < arr[pivot]:
            arr[i], arr[index] = arr[index], arr[i]
            index += 1
        i += 1
    arr[pivot], arr[index - 1] = arr[index - 1], arr[pivot]
    return index - 1


def quickSort(arr, left=None, right=None):
    left = 0 if not isinstance(left, (int, float)) else left
    right = len(arr) - 1 if not isinstance(right, (int, float)) else right
    if left < right:
        partitionIndex = partition(arr, left, right)
        quickSort(arr, left, partitionIndex - 1)
        quickSort(arr, partitionIndex + 1, right)
    return arr
```

