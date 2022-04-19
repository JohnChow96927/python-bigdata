package b_lambda;
/*
    面试题: 匿名内部类和lambda表达式的区别
    1.范围不同
        匿名内部类:适用于实体类,抽象类,接口
        Lambda表达式:只针对于接口生效
    2.限定不同
        匿名内部类: 有多少个抽象方法都可以
        lambda表达式:只能由一个抽象方法
    3.底层原理不同(字节码文件不同)
        匿名内部类:底层会生成一个字节码对象
        lambda表达式,动态编译,即不会显示生成的字节码文件,而程序运行时,由系统生成.
            也就是在编译过程中,不会出现单独的字节码文件,使用到了才创建

    注意: 只要满足接口且有一个抽象方法的时候,就用lambda, 其他情况用匿名内部类
 */
public class Demo4 {
    public static void main(String[] args) {
        Animal an = new Animal() {
            @Override
            public void eat() {
                System.out.println("321");
            }
        };
        an.eat();

    }
}
