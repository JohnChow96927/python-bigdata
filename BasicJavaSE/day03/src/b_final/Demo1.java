package b_final;

public class Demo1 {
    public static void main(String[] args) {
        A_Animal a1 = new A_Dog();
        a1.declare();
    }
}

class A_Animal {
    // 被final修饰的方法不能被覆写, 最终方法了, 不再拓展
    public final void declare() {
        System.out.println("动物类方法");
    }
}

class A_Dog extends A_Animal {

}
