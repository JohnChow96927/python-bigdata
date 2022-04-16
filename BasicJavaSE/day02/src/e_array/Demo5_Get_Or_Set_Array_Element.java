package e_array;

import java.util.Arrays;
import java.util.Scanner;

public class Demo5_Get_Or_Set_Array_Element {
    public static void main(String[] args) {
        int[] arr = {11, 33, 55, 77, 99};
        System.out.println(Arrays.toString(arr));
        System.out.println(arr[0]);

        arr[0] = 0;
        System.out.println(Arrays.toString(arr));

        Scanner scanner = new Scanner(System.in);
        System.out.printf("请输入想要取的数的下标: ");
        int num = scanner.nextInt();
        if (0<= num && num <= (arr.length - 1)) {
            System.out.println("您要取的数为: " + arr[num]);
        } else {
            System.out.println("您输入的下标有误!");
        }
    }
}
