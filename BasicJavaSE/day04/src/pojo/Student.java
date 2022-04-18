package pojo;

import java.util.Objects;

public class Student {
    private String name;
    private Integer age;

    // 构造
    public Student() {
    }

    public Student(String name, Integer age) {
        this.name = name;
        this.age = age;
    }

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

    @Override
    public int hashCode() {
        System.out.println("调用hashCode方法......");

        return Objects.hash(name, age);
    }

    @Override
    public boolean equals(Object obj) {
        System.out.println("调用equals方法......");
        if (this == obj) return true;
        if (obj == null || this.getClass() != obj.getClass()) return false;
        Student student = (Student) obj;
        return Objects.equals(name, student.name) && Objects.equals(age, student.age);
    }

    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
