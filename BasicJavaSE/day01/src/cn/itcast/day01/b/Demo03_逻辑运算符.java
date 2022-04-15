package cn.itcast.day01.b;

public class Demo03_逻辑运算符 {
    public static void main(String[] args) {
        // 逻辑运算符
        // 注意: 逻辑运算符两边必须是boolean类型的值
        System.out.println(true && true);
        System.out.println(true && (3 > 2));
        System.out.println(false || (3 < 2));

        // 判断 如果(!(xxx)), 执行1; 否则 执行2;
        System.out.println(!true);
        System.out.println(!(5>6));
    }
}
