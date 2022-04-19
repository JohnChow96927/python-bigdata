package b_lambda;

/*
lambda : JDK1.8中出现的功能, 用来简化匿名内部类的写法, 有点类似于python中的调用方式(函数式变成)

格式:
    (形参列表) -> {
        待实现的方法方法体
        return 具体的返回值
    }

# 需求:
1.	已知接口Animal中有一个抽象方法eat()
2.	在测试类Demo01中定义show(Animal an)方法, 实现调用Animal#eat()方法.
3.	并在main方法中, 调用AnimalTest#show()方法.

注意事项:
    lambda表达式只能针对有一个抽象方法的接口生效, 如果非几口或有多个抽象方法都无法使用lambda
    lambda和匿名内部类都解决了创建接口子类对象流程复杂的问题
 */
public class Demo1 {
    public static void main(String[] args) {
        // 需求: 调用show方法
        // 格式: show(animal的子类对象)
        // 方式1: 匿名内部类
        show(new Animal() {
            @Override
            public void eat() {
                System.out.println("此处为匿名内部类, 动物可以吃肉");
            }
        });

        // 方式2: lambda表达式, 思想: 不关心怎么做, 只关心做什么, 重写什么方法, 有系统自行处理与我们无关
        show(() -> {
            System.out.println("此处为lambda表达式, 动物可以吃素");
        });
    }

    private static void show(Animal animal) {
        animal.eat();
    }
}
