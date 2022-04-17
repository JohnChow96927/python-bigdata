package c_static;

public class Demo1 {
    public static void main(String[] args) {
        double r = Math.random();
        A_Animal.static_fun();
        A_Animal a_animal = new A_Animal();
        a_animal.fun();
        a_animal.static_fun();  // 一般不这么用静态方法, 而是直接用类进行调用
        /*
        Report references to static methods and fields via a class instance rather than the class itself.
        Even though referring to static members via instance variables is allowed by The Java Language Specification, this makes the code confusing as the reader may think that the result of the method depends on the instance.
        The quick-fix replaces the instance variable with the class name.
         */
    }
}

class A_Animal {
    public static void static_fun() {
        System.out.println("This is a static function");
    }

    public void fun() {
        System.out.println("This is a normal function");
    }
}
