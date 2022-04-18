package cn.itcast.day04.e_集合;

import cn.itcast.day04.pojo.Student;
import org.junit.Test;

import java.util.*;

public class C_list {
    @Test
    public void show1() {
        // 目标: 使用list保存普通变量, 且 遍历
        List<String> list = new ArrayList<>();
        list.add("aaa");
        list.add("ccc");
        list.add("eee");
        list.add("ggg");

        System.out.println("========方式一  itli ============");
        for (int i = 0; i < list.size(); i++) {
            String element =  list.get(i);
            System.out.println(element);
        }
        System.out.println("========方式二  iter 增强for循环 ============");
        for (String element : list) {
            System.out.println(element);
        }
        System.out.println("========方式三  itit 迭代器 ============");
        Iterator<String> iterator = list.iterator();
        // itit
        while (iterator.hasNext()) {
            String element = iterator.next();
            System.out.println(element);
        }
        System.out.println("----------");
        while (iterator.hasNext()) {
            String element = iterator.next();
            System.out.println(element);
        }

        System.out.println("========方式四  列表迭代器 ============");
        ListIterator<String> listIterator = list.listIterator();
        // 从上向下查
        while (listIterator.hasNext()) {
            String element = listIterator.next();
            System.out.println(element);
        }
        System.out.println("------------");
        // 从下往上查
        while(listIterator.hasPrevious()) {
            String element = listIterator.previous();
            System.out.println(element);
        }


    }

    @Test
    public void show2() {
        // 目标: 使用list保存普通变量, 且 遍历
        List<String> list = new ArrayList<>();
        list.add("aaa");
        list.add("ccc");
        list.add("eee");
        list.add("ggg");

        System.out.println(list);

        list.set(1, "66666666");
        System.out.println(list);

        list.remove(2);
        System.out.println(list);
    }

    @Test
    public void show3() {
        // 目标: 使用list保存复杂类型变量, 且 遍历
        List<Student> list = new ArrayList<>();
        list.add(new Student("张三", 13));
        list.add(new Student("李四", 14));
        list.add(new Student("王五", 15));

        System.out.println("======= 方式一");
        for (int i = 0; i < list.size(); i++) {
            Student student = list.get(i);
            System.out.println(student);
        }

        System.out.println("======= 方式二");
        for (Student student : list) {
            System.out.println(student);
        }

        System.out.println("======= 方式三");
        Iterator<Student> iterator = list.iterator();
        while (iterator.hasNext()) {
            Student student = iterator.next();
            System.out.println(student);
        }

        System.out.println("======= 方式四");
        ListIterator<Student> listIterator = list.listIterator();
        while (listIterator.hasNext()) {
            Student student = listIterator.next();
            System.out.println(student);
        }
        System.out.println("----");
        while(listIterator.hasPrevious()) {
            Student student = listIterator.previous();
            System.out.println(student);
        }
    }

    @Test
    public void show4() {
        // 目标: 使用list保存普通变量, 且 遍历
        List<String> list = new ArrayList<>();
        list.add("aaa");
        list.add("ccc");
        list.add("eee");
        list.add("ggg");

        System.out.println("========方式一  itli ============");
        for (int i = 0; i < list.size(); i++) {
            String element =  list.get(i);
            System.out.println(element);

            // 没有问题
            // if("ccc".equals(element)) {
            //     list.add("world");
            // }
        }

        System.out.println("========方式二  iter 增强for循环 ============");
        for (String element : list) {
            System.out.println(element);

             // 有问题: 报错 并发修改异常
             // if("ccc".equals(element)) {
             //     list.add("world");
             // }
        }

        System.out.println("========方式三  itit 迭代器 ============");
        Iterator<String> iterator = list.iterator();
        // itit
        while (iterator.hasNext()) {
            String element = iterator.next();
            System.out.println(element);

            // 有问题: 报错 并发修改异常
            // if("ccc".equals(element)) {
            //     list.add("world");
            // }
        }


        System.out.println("========方式四  列表迭代器 ============");
        ListIterator<String> listIterator = list.listIterator();
        // 从上向下查
        while (listIterator.hasNext()) {
            String element = listIterator.next();
            System.out.println(element);

            if("ccc".equals(element)) {
                // 有问题: 报错 并发修改异常
                // list.add("world");

                // 不报错
                listIterator.add("world");
            }
        }
        System.out.println("------------");
        // 从下往上查
        while(listIterator.hasPrevious()) {
            String element = listIterator.previous();
            System.out.println(element);
        }


    }

    @Test
    public void show5() {
        LinkedList<String> list = new LinkedList<>();
        list.add("aaa");
        list.add("ccc");
        list.add("eee");
        list.add("fff");

        list.addFirst("666");
        System.out.println(list);
    }
}
