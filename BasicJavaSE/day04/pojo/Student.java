package cn.itcast.day04.pojo;

import java.util.Objects;

public class Student {
    // 1 私有属性
    private String name;
    private Integer age;

    // 2 构造
    public Student() {
    }

    public Student(String name, Integer age) {
        this.name = name;
        this.age = age;
    }

    // 3 属性的get/set方法
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }


    // 4 其他方法
    @Override
    public boolean equals(Object o) {
        System.out.println("调用 equals 方法... ...");
        // todo 如果传入的参数 和 当前对象 是同一个, 就返回true
        if (this == o) return true;
        // todo 如果传入的参数为null 或 传入的参数类型和当前对象的类型不一致, 就认为是不同的对象, 返回false
        if (o == null || getClass() != o.getClass()) return false;
        // todo 为了后面对象内容, 将传入的参数强转成 student对象
        Student student = (Student) o;
        // todo 通过工具类判断 姓名和年龄是否一致
        return Objects.equals(name, student.name) &&
                Objects.equals(age, student.age);
    }

    @Override
    public int hashCode() {
        System.out.println("调用 hashCode 方法... ...");

        return Objects.hash(name, age);
    }

    // 5 覆写 toString方法
    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
