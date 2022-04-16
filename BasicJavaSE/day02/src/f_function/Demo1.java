package f_function;

public class Demo1 {
    public static void main(String[] args) {
        // 需求: 将遍历打印数组的工作抽取到方法中
        Integer[] arr = {11, 33, 55, 77, 99};
        arrPrint(arr);
    }

    private static void arrPrint(Integer[] arr) {
        for (Integer element : arr) {
            System.out.println(element);
        }
    }
}
