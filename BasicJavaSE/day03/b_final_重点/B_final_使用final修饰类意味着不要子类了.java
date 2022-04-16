package cn.itcast.day03.b_final_重点;

public class B_final_使用final修饰类意味着不要子类了 {

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

//class B_Dog extends B_Animal { }
