package e_set;

import org.junit.Test;
import pojo.Student;

import java.util.*;

public class B_Collection {
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
        cols.remove("aaa");
        System.out.println(cols);

        // 3 查
        System.out.println(cols.contains("aaa"));
        System.out.println(cols.size());

        // 4 清空容器内容
        cols.clear();
        System.out.println(cols.isEmpty());
        System.out.println(cols);

        // 5 将集合转成数组
        Object[] objectArr = cols.toArray();
        System.out.println(Arrays.toString(objectArr));
    }
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
        while (iterator.hasNext()) {
            String element = iterator.next();
            System.out.println(element);
        }
        System.out.println("=====================");

        // 遍历方式二
        for (String element: cols) {
            System.out.println(element);
        }
    }

    @Test
    public void show3() {
        // 目标: 存放复杂对象
        Collection<Student> cols = new ArrayList<>();
        Student s1 = new Student("霜霜", 18);
        cols.add(s1);
        cols.add(new Student("三炮", 3));

        for (Student student : cols) {
            System.out.println(student);
        }

        Iterator<Student> iterator = cols.iterator();
        while (iterator.hasNext()) {
            Student student = iterator.next();
            System.out.println(student);
        }
    }
}
