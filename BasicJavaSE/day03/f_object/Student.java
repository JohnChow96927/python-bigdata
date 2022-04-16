package cn.itcast.day03.f_object;

import java.util.Objects;

public class Student {
    // 1 私有的属性
    private String name;
    private int age;
    // 2 构造方法
    // 2.1 无参数的构造方法
    public Student() {
    }

    // 2.2 有参数的构造方法
    public Student(String name, int age) {
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

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    // 4 其他方法

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Student student = (Student) o;
        return age == student.age &&
                Objects.equals(name, student.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, age);
    }

    // 5 覆写toString
    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
