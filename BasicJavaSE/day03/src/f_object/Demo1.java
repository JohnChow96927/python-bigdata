package f_object;

public class Demo1 {
    public static void main(String[] args) {
        // 目标: 为什么要覆写Java对象的toString方法
        Student s1 = new Student("张三", 13);
        System.out.println(s1);
        System.out.println(s1.toString());
    }
}
