# quick sort demo
from QuickSort import partition


def quickSortHelper(alist, first, last):
    if first < last:

        splitpoint = partition(alist, first, last)

        quickSortHelper(alist, first, splitpoint - 1)
        quickSortHelper(alist, splitpoint + 1, last)


def quickSort(alist):
    quickSortHelper(alist, 0, len(alist) - 1)

