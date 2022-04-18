package d_inner_class;

import java.util.Arrays;
import java.util.Comparator;

public class Demo1 {
    public static void main(String[] args) {
        Integer[] arr = {100, 20, 50, 45, 30};

        Arrays.sort(arr, new MyComparator());

        System.out.println(Arrays.toString(arr));
    }

    private static class MyComparator implements Comparator<Integer> {
        @Override
        public int compare(Integer o1, Integer o2) {
            return o2 - o1;
        }
    }
}
