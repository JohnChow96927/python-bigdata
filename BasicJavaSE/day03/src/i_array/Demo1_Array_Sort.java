package i_array;

import java.util.Arrays;

public class Demo1_Array_Sort {
    public static void main(String[] args) {
        int[] arr = {1, 4, 3, 2, 7, 9, 2};

        System.out.println("排序前: " + Arrays.toString(arr));

        // Arrays.sort(arr);

        for (int i = 0; i < arr.length - 1; i++) {
            for (int j = i + 1; j < arr.length; j++) {
                if (arr[i] > arr[j]) {
                    int temp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = temp;
                }
            }
        }
        System.out.println("排序后: " + Arrays.toString(arr));
    }
}
