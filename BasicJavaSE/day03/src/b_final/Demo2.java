package b_final;

public class Demo2 {
}

// 结论2: 如果使用final修饰类, 意味着 当前类以后没有子类
final class B_Animal {

    String name;
    // 结论3: 使用final修饰成员变量, 必须给值
    // 方案一
    //final String nickname = "张三";

    // 方案二
    final String nickname;

    public B_Animal(String name, String nickname) {
        this.name = name;
        this.nickname = nickname;
    }

    public void eat() {
        System.out.println("父类的的eat方法");
    }

    public void shout() {
        System.out.println("父类的的shout方法");
    }
}
