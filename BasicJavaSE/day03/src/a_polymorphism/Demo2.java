package a_polymorphism;

public class Demo2 {
    public static void main(String[] args) {
        B_Actress p1 = new B_Actress();
        p1.name = "刘诗诗";
        cut(p1);

        B_Person p2 = new B_Barber();
        p2.name = "Tony老师";
        cut(p2);

        B_Person p3 = new B_Doctor();
        p3.name = "华佗";
        cut(p3);
    }

    public static void cut(B_Person p) {
        p.doSomething();
    }
}

class B_Person {
    String name;

    public void doSomething() {
        System.out.println("人类");
    }
}

class B_Actress extends B_Person {
    @Override
    public void doSomething() {
        System.out.println("女演员" + name);
    }
}

class B_Barber extends B_Person {
    @Override
    public void doSomething() {
        System.out.println("理发师" + name);
    }
}

class B_Doctor extends B_Barber {
    @Override
    public void doSomething() {
        System.out.println("医生" + name);
    }
}