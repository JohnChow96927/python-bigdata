package e_array;

public class Demo7_Array_Max {
    public static void main(String[] args) {
        Integer[] arr = {1,3,5,7,15};

        int max = Integer.MIN_VALUE;
        for (Integer element: arr){
            if (element > max) {
                max = element;
            }
        }
        System.out.println("最大值为: " + max);
    }
}
