package cn.itcast.day03.e_interface_重点;

// 要求: 了解 代码可以不敲(纯小白)
public class Demo03_综合案例 {
    public static void main(String[] args) {
        PingPangPlayer pingPangPlayer = new PingPangPlayer();
        pingPangPlayer.setName("马龙");
        pingPangPlayer.setAge(35);
        pingPangPlayer.eat();
        pingPangPlayer.study();
        pingPangPlayer.speakEnglish();
    }
}

//1.已知有乒乓球运动员(PingPangPlayer)和篮球运动员(BasketballPlayer),
// 乒乓球教练(PingPangCoach)和篮球教练(BasketballCoach).
//2.他们都有姓名和年龄, 都要吃饭, 但是吃的东西不同.
abstract class Person {
    private String name;
    private int age;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    //都要吃饭, 但是吃的东西不同.
    public abstract void eat();
}

//3.乒乓球教练教如何发球, 篮球教练教如何运球和投篮.
// 3.1 教练类
abstract class Coach extends Person {
    public abstract void teach();
}

// 3.2 乒乓球教练教如何发球
class PingPangCoach extends Coach implements Speak {

    @Override
    public void eat() {
        System.out.println("乒乓球教练 在吃鸡腿!");
    }

    @Override
    public void teach() {
        System.out.println("乒乓球教练 教如何发球");
    }

    @Override
    public void speakEnglish() {
        System.out.println("乒乓球教练 正在说英语!");
    }
}

// 3.3 篮球教练教如何运球和投篮.
class BasketballCoach extends Coach {
    @Override
    public void eat() {
        System.out.println("篮球教练 在吃海参和跳跳糖... ...");
    }

    @Override
    public void teach() {
        System.out.println("篮球教练教如何运球和投篮.");
    }
}

//4.乒乓球运动员学习如何发球, 篮球运动员学习如何运球和投篮.
// 4.1 运动员抽象类
abstract class Player extends Person {
    public abstract void study();
}

// 4.2 乒乓球运动员学习如何发球 PingPangPlayer
class PingPangPlayer extends Player implements Speak {
    @Override
    public void speakEnglish() {
        System.out.println("乒乓球运动员 正在说英语 ... ...");
    }

    @Override
    public void eat() {
        System.out.println("乒乓球运动员 在吃青菜... ...");
    }

    @Override
    public void study() {
        System.out.println("乒乓球运动员学习如何发球 ... ...");
    }
}
// 4.3 篮球运动员学习如何运球和投篮. BasketballPlayer
class BasketballPlayer extends Player {
    @Override
    public void eat() {
        System.out.println("篮球运动员 在吃丝瓜... ...");
    }

    @Override
    public void study() {
        System.out.println("篮球运动员学习如何运球和投篮 ... ...");
    }
}

//5.为了出国交流, 跟乒乓球相关的人员都需要学习英语.
interface Speak {
    void speakEnglish();
}

//6.请用所学, 模拟该知识.