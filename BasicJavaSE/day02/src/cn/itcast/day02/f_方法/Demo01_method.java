package cn.itcast.day02.f_方法;

public class Demo01_method {
    public static void main(String[] args) {
        // 需求: 将遍历数组的工作抽取到数组中
        int[] arr = {11, 33, 55, 77, 99};
        arrPrint(arr);

        int[] arr2 = {22, 44, 66};
        arrPrint(arr2);

        int[] arr3 = {111, 333, 666};
        arrPrint(arr3);

    }

    /*
        方法的格式:
            修饰符 返回值类型 方法名(参数类型 参数名, 参数类型 参数名, 参数类型 参数名 ... ...) {
                方法体
            }
     */
    private static void arrPrint(int[] arr) {
        for (int i = 0; i < arr.length; i++) {
            int element = arr[i];
            System.out.println(element);
        }
    }
}
