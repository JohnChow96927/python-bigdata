package cn.itcast.day04.e_集合;

import cn.itcast.day04.pojo.Student;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;

public class B_collection {
    @Test
    public void show1() {
        Collection<String> cols = new ArrayList<String>();

        // 1 增
        cols.add("aaa");
        cols.add("ccc");
        cols.add("eee");
        cols.add("ggg");

        System.out.println(cols);

        // 2 删
        // cols.remove("aaa");
        // System.out.println(cols);

        // 3 查
        System.out.println(cols.contains("aaa"));
        System.out.println(cols.size());

        // 4 清空容器的内容
        // cols.clear();
        System.out.println(cols.isEmpty());
        System.out.println(cols);

        // 5 将集合转成数组
        Object[] objectArr = cols.toArray();
        System.out.println(Arrays.toString(objectArr));
    }

    @Test
    public void show2() {
        Collection<String> cols = new ArrayList<String>();

        // 1 增
        cols.add("aaa");
        cols.add("ccc");
        cols.add("eee");
        cols.add("ggg");

        System.out.println(cols.size());

        // 遍历方式一: 迭代器方式
        Iterator<String> iterator = cols.iterator();
        // iterator.hasNext() 返回的结果为boolean类型: true代表有内容, false 反之
        while(iterator.hasNext()) {
            String element = iterator.next();
            System.out.println(element);
        }
        System.out.println("==========================");

        // 遍历方式二
        for(String element : cols) {
            System.out.println(element);
        }
    }

    @Test
    public void show3() {
        // 目标: 存放复杂对象
        Collection<Student> cols = new ArrayList<>();
        Student s1 = new Student("张三", 13);
        cols.add(s1);
        cols.add(new Student("李四", 14));
        cols.add(new Student("王五", 15));

        // System.out.println(cols);
        // 方式一 iter
        for (Student student : cols) {
            System.out.println(student);
        }

        // 方式二
        Iterator<Student> iterator = cols.iterator();
        // itit
        while (iterator.hasNext()) {
            Student student = iterator.next();
            System.out.println(student);
        }
    }
}
