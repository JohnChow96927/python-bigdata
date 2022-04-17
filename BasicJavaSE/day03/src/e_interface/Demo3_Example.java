package e_interface;

public class Demo3_Example {
    public static void main(String[] args) {
        Person pingpangCoach = new PingpangCoach();
        Person basketballCoach = new BasketBallCoach();
        Person pingpangPlayer = new PingpangPlayer();
        Person basketballPlayer = new BasketBallPlayer();
        pingpangCoach.setName("刘国梁");
        pingpangCoach.setAge(66);
        basketballCoach.setName("禅师");
        basketballCoach.setAge(88);
        pingpangPlayer.setName("马龙");
        pingpangPlayer.setAge(18);
        basketballPlayer.setName("詹姆斯");
        basketballPlayer.setAge(23);
        pingpangCoach.eat();
        ((PingpangCoach) pingpangCoach).teach();
        ((PingpangCoach) pingpangCoach).speak();
         basketballCoach.eat();
         ((BasketBallCoach) basketballCoach).teach();
         ((BasketBallCoach) basketballCoach).speak();
         pingpangPlayer.eat();
         ((PingpangPlayer) pingpangPlayer).study();
         ((PingpangPlayer) pingpangPlayer).speak();
         basketballPlayer.eat();
         ((BasketBallPlayer) basketballPlayer).study();
         ((BasketBallPlayer) basketballPlayer).speak();
    }
}

//1.已知有乒乓球运动员(PingPangPlayer)和篮球运动员(BasketballPlayer),
// 乒乓球教练(PingPangCoach)和篮球教练(BasketballCoach).
//2.他们都有姓名和年龄, 都要吃饭, 但是吃的东西不同.
abstract class Person {
    private String name;
    private Integer age;

    public String getName() {
        return name;
    }

    public Integer getAge() {
        return age;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public abstract void eat();
}

abstract class Coach extends Person {
    public abstract void teach();
}

abstract class Player extends Person {
    public abstract void study();
}

interface Speak {
    void speak();
}

class PingpangCoach extends Coach implements Speak {

    @Override
    public void eat() {
        System.out.println(this.getAge() + "岁的"+ this.getName() + "吃鸡蛋");
    }

    @Override
    public void teach() {
        System.out.println(this.getAge() + "岁的"+ this.getName() + "教乒乓球");
    }

    @Override
    public void speak() {
        System.out.println(this.getAge() + "岁的"+ this.getName() + "说乒乓球黑话");
    }
}

class BasketBallCoach extends Coach implements Speak {

    @Override
    public void eat() {
        System.out.println(this.getAge() + "岁的"+ this.getName() + "吃鸡胸肉");
    }

    @Override
    public void teach() {
        System.out.println(this.getAge() + "岁的"+ this.getName() + "教篮球");
    }

    @Override
    public void speak() {
        System.out.println(this.getAge() + "岁的"+ this.getName() + "说篮球术语");
    }
}

class PingpangPlayer extends Player implements Speak {

    @Override
    public void eat() {
        System.out.println(this.getAge() + "岁的"+ this.getName() + "吃海参");
    }

    @Override
    public void study() {
        System.out.println(this.getAge() + "岁的"+ this.getName() + "学习打乒乓球");
    }

    @Override
    public void speak() {
        System.out.println(this.getAge() + "岁的"+ this.getName() + "学习说英语");
    }
}

class BasketBallPlayer extends Player implements Speak {

    @Override
    public void eat() {
        System.out.println(this.getAge() + "岁的"+ this.getName() + "吃汉堡包");
    }

    @Override
    public void study() {
        System.out.println(this.getAge() + "岁的"+ this.getName() + "学习扣篮");
    }

    @Override
    public void speak() {
        System.out.println(this.getAge() + "岁的"+ this.getName() + "学说中文");
    }
}