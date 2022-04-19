package b_lambda;

/*
Lambdab表达式,处理有参有返回值形式的方法

需求:
    定义一个接口(Addable)，里面定义一个抽象方法：int add(int x,int y);
    定义一个测试类(AddableDemo)，在测试类中提供两个方法
    一个方法是：useAddable(Addable a)
    一个方法是主方法，在主方法中调用useAddable方法
 */
public class Demo3 {
    public static void main(String[] args) {
        // 方式1: 匿名内部类, 体现面向对象的思想, 自己创建对象重写
        useAddable(new Addable() {
            @Override
            public int add(int x, int y) {
                return x + y;
            }
        });

        useAddable(new Addable() {
            @Override
            public int add(int x, int y) {
                return x + y;
            }
        }, 10, 30);

        // 方式2: lambda表达式, 体现面向函数式思想
        useAddable((int x, int y) -> {
            return x + y;
        });

        useAddable((int x, int y) -> {
            return x + y;
        }, 10, 30);

        // 方式3: lambda的省略写法
        useAddable((x, y) -> x + y);
        useAddable(((x, y) -> x + y), 10, 30);
    }

    public static void useAddable(Addable addable) {
        int sum = addable.add(10, 20);
        System.out.println(sum);
    }

    public static void useAddable(Addable a, int x, int y) {
        int sum = a.add(x, y);
        System.out.println(sum);
    }

}
