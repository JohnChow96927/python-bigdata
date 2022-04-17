package f_object;

public class Demo2 {
    public static void main(String[] args) {
        // 第一种情况: == 如果是基本类型, 直接对比值是否相等
        int n = 10;
        int m = 10;
        System.out.println(n == m);

        //第二种情况: == 如果是引用类型, 对比的是堆里开辟的地址
        Student s1 = new Student("张三", 13);
        Student s2 = new Student("李四", 14);
        Student s3 = new Student("张三", 13);

        System.out.println(s1.equals(s2));
        System.out.println(s1.equals(s3));
    }
}
