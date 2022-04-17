package j_wrapper;

public class Demo1 {
    public static void main(String[] args) {
        int num = 10;
        // 问题1: 如何知道整数的最大值 (4个字节, 1个字节是8位, 32位, 2的31次方)
        // 问题2: 有一个整数变量, 不确定整数内容, 是否设置为null
        // 问题3: 有一个字符串, 是否可以把字符串转成整数
        // 目标: 获取包装类型
        Integer i1 = new Integer("200"); // 将字符串转成整数
        Integer i2 = new Integer(100);
        System.out.println(i1 + i2);

        // 将整数转成包装的整数(没必要)
        Integer i3 = new Integer(num);
        System.out.println(i3);

        // 将字符串转换成整数
        String str = "20";
        Integer i4 = new Integer(str);
        System.out.println(i4);
        int i5 = Integer.parseInt(str);
        System.out.println(i5);

        // 将整数转成字符串
        int i6 = 100;
        String str6 = i6 + "jj";
        System.out.println(str6);
        String str7 = Integer.toString(i6);
        System.out.println(str7);
    }
}
