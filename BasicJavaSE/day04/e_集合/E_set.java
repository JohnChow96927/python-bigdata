package cn.itcast.day04.e_集合;

import cn.itcast.day04.pojo.Student;
import org.junit.Test;

import java.util.*;

public class E_set {
    @Test
    public void show1() {
        // 为什么学习set?
        // 因为list有一个缺点, 不能去重
        List<String> list = new ArrayList<>();
        list.add("aaa");
        list.add("aaa");
        list.add("aaa");

        System.out.println(list);
    }

    @Test
    public void show2() {
        // set集合: 特点1 去重
        Set<String> set = new HashSet<>();
        set.add("aaa");
        set.add("aaa");
        set.add("aaa");

        System.out.println(set);
    }

    @Test
    public void show3() {
        // set集合: 特点2 无序性 ==> 取数据的顺序跟插入的顺序不一致
        Set<String> set = new HashSet<>();

        set.add("aaa");
        set.add("aaa");
        set.add("aaa");
        set.add("bbb");
        set.add("ccc");
        set.add("ddd");

        System.out.println(set);
    }

    @Test
    public void show4() {
        // 保存基本类型
        Set<String> set = new HashSet<>();
        set.add("aaa");
        set.add("bbb");
        set.add("ccc");
        set.add("ddd");

        // 遍历一 增强for循环
        for (String element : set) {
            System.out.println(element);
        }

        System.out.println("===================");

        // 遍历二 迭代器
        Iterator<String> iterator = set.iterator();
        while (iterator.hasNext()) {
            String element = iterator.next();
            System.out.println(element);
        }
    }

    @Test
    public void show5() {
        // 保存复杂类型
        Set<Student> set = new HashSet<>();
        set.add(new Student("张三", 13));
        set.add(new Student("李四", 14));
        set.add(new Student("王五", 15));

        for (Student student : set) {
            System.out.println(student);
        }
    }

    @Test
    public void show6() {
        // 保存复杂类型
        Set<Student> set = new HashSet<>();

        set.add(new Student("张三", 13));
        set.add(new Student("张三", 13));
        set.add(new Student("张三", 13));
        set.add(new Student("张三", 13));

        // 结论4个
        for (Student student : set) {
            System.out.println(student);
        }

        // 结论: set集合默认情况下, 碰到引用类型, 根据对象的地址值去重
        // 结论2: set集合默认情况下, 碰到引用类型, 想根据对象的内容进行去重, 重写java类的hashcode 和 equalse方法
        // 调用 hashCode 方法... ...  // set.add(new Student("张三", 13));
        // 调用 hashCode 方法... ...  // set.add(new Student("张三", 13));
        // 调用 equals 方法... ...    // 因为第二次add 和 第一次add 根据内容算出来的hash值相等, 意味内容可能一样, 所以调用equals方法 判断
                                    // 如果hash值不一样, 肯定是内容不一样, 意味着你是新元素
        // 调用 hashCode 方法... ... // set.add(new Student("张三", 13));
        // 调用 equals 方法... ...
        // 调用 hashCode 方法... ... // set.add(new Student("张三", 13));
        // 调用 equals 方法... ...
        // Student{name='张三', age=13}
    }

    @Test
    public void show7() {
        // 保存复杂类型(引用类型)
        Set<Student> set = new HashSet<>();

        Student s1 = new Student("张三", 13);

        set.add(s1);
        set.add(s1);
        set.add(s1);
        set.add(s1);

        // 结论: 1个
        for (Student student : set) {
            System.out.println(student);
        }
    }

    @Test
    public void show8() {
        Student student = new Student();
        System.out.println(student.hashCode()); // 961 // 580024961
    }
}
